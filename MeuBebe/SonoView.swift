import SwiftUI
import Combine

// Estrutura para armazenar um registro de sono
struct SleepRecord: Identifiable, Codable {
    let id: UUID
    var start: Date
    var end: Date
    var duration: TimeInterval {
        end.timeIntervalSince(start)
    }
}

class SonoViewModel: ObservableObject {
    @Published var sleepStart: Date? = nil
    @Published var sleepEnd: Date? = nil
    @Published var sleepRecords: [SleepRecord] = []

    let userDefaultsKey = "SleepRecords"
    let sleepStartKey = "SleepStart"

    init() {
        loadSleepRecords()
        loadSleepStart()
    }

    func startSleep() {
        self.sleepStart = Date()
        saveSleepStart()
    }

    func endSleep() {
        self.sleepEnd = Date()
        if let start = self.sleepStart, let end = self.sleepEnd {
            let record = SleepRecord(id: UUID(), start: start, end: end)
            self.sleepRecords.append(record)
            saveSleepRecords()
            self.sleepStart = nil
            self.sleepEnd = nil
            clearSleepStart()
        }
    }

    func saveSleepRecords() {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(sleepRecords) {
            defaults.set(encoded, forKey: userDefaultsKey)
        }
    }

    func loadSleepRecords() {
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([SleepRecord].self, from: savedData) {
            sleepRecords = decoded
        }
    }

    func saveSleepStart() {
        let defaults = UserDefaults.standard
        defaults.set(sleepStart, forKey: sleepStartKey)
    }

    func loadSleepStart() {
        let defaults = UserDefaults.standard
        self.sleepStart = defaults.object(forKey: sleepStartKey) as? Date
    }

    func clearSleepStart() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: sleepStartKey)
    }
}

struct SonoView: View {
    @StateObject private var viewModel = SonoViewModel()

    @State private var editingRecord: SleepRecord? // Registro sendo editado

    var body: some View {
        VStack(spacing: 20) {
            // Botão para iniciar ou finalizar o sono
            if viewModel.sleepStart == nil {
                Button(action: {
                    viewModel.startSleep()
                }) {
                    Text("Início do Sono")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            } else {
                Button(action: {
                    viewModel.endSleep()
                }) {
                    Text("Fim do Sono")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }

            // Lista de registros de sono
            List {
                ForEach(viewModel.sleepRecords) { record in
                    VStack(alignment: .leading) {
                        Text("Início: \(formatDate(record.start))")
                        Text("Fim: \(formatDate(record.end))")
                        Text("Duração: \(formatDuration(record.duration))")
                        
                        Button(action: {
                            self.editingRecord = record // Abre a tela de edição
                        }) {
                            Text("Editar")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .onDelete(perform: deleteSleepRecord)
            }
        }
        .navigationTitle("Sono")
        .onAppear {
            viewModel.loadSleepStart()
        }
        .sheet(item: $editingRecord) { record in
            EditSleepRecordView(
                sleepRecord: record,
                onSave: { updatedRecord in
                    if let index = viewModel.sleepRecords.firstIndex(where: { $0.id == record.id }) {
                        viewModel.sleepRecords[index] = updatedRecord
                        viewModel.saveSleepRecords()
                    }
                }
            )
        }
    }

    // Função para formatar a data
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy - HH:mm"
        return formatter.string(from: date)
    }

    // Função para formatar a duração
    func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        return "\(hours)h \(minutes)min"
    }

    // Função para deletar um registro de sono
    func deleteSleepRecord(at offsets: IndexSet) {
        viewModel.sleepRecords.remove(atOffsets: offsets)
        viewModel.saveSleepRecords()
    }
}

// Tela de edição de registro de sono
struct EditSleepRecordView: View {
    @State var sleepRecord: SleepRecord
    var onSave: (SleepRecord) -> Void
    @Environment(\.presentationMode) var presentationMode // Para fechar a sheet

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Horário de Início")) {
                    DatePicker("Início", selection: $sleepRecord.start, displayedComponents: [.date, .hourAndMinute])
                }

                Section(header: Text("Horário de Fim")) {
                    DatePicker("Fim", selection: $sleepRecord.end, displayedComponents: [.date, .hourAndMinute])
                }

                Section {
                    Button(action: {
                        onSave(sleepRecord) // Salva as alterações
                        presentationMode.wrappedValue.dismiss() // Fecha a tela
                    }) {
                        Text("Salvar Alterações")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Editar Registro")
            .navigationBarItems(trailing: Button("Fechar") {
                presentationMode.wrappedValue.dismiss() // Fecha a tela
            })
        }
    }
}

struct SonoView_Previews: PreviewProvider {
    static var previews: some View {
        SonoView()
    }
}
