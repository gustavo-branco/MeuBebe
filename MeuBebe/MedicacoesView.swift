import SwiftUI

struct Medication: Identifiable {
    var id = UUID() // Identificador único
    var name: String
    var date: Date
}

struct MedicacoesView: View {
    @State private var medicationName: String = ""
    @State private var medicationDate: Date = Date()
    @State private var medications: [Medication] = []

    @State private var editingIndex: Int?

    var body: some View {
        VStack {
            TextField("Nome da Medicação", text: $medicationName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            DatePicker("Selecione a data e horário", selection: $medicationDate, displayedComponents: [.date, .hourAndMinute])
                .padding()

            Button(action: {
                let newMedication = Medication(name: medicationName, date: medicationDate)
                self.medications.append(newMedication)
                self.saveMedications() // Salva os registros
                self.medicationName = "" // Limpa o campo após registrar
            }) {
                Text("Registrar Medicação")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            List {
                ForEach(medications) { medication in
                    VStack(alignment: .leading) {
                        Text("Medicação: \(medication.name)")
                        Text("Data: \(formatDate(medication.date))")
                    }
                }
                .onDelete(perform: deleteMedication)
            }
        }
        .navigationTitle("Últimas Medicações")
        .onAppear {
            self.loadMedications() // Carrega os registros ao abrir a tela
        }
    }

    // Função para salvar os registros no UserDefaults
    func saveMedications() {
        let medicationData = medications.map { ["name": $0.name, "date": $0.date] }
        UserDefaults.standard.set(medicationData, forKey: "medications")
    }

    // Função para carregar os registros do UserDefaults
    func loadMedications() {
        if let savedMedications = UserDefaults.standard.array(forKey: "medications") as? [[String: Any]] {
            self.medications = savedMedications.compactMap { dict in
                if let name = dict["name"] as? String, let date = dict["date"] as? Date {
                    return Medication(name: name, date: date)
                }
                return nil
            }
        }
    }

    // Função para formatar a data
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy - HH:mm"
        return formatter.string(from: date)
    }

    // Função para deletar uma medicação
    func deleteMedication(at offsets: IndexSet) {
        medications.remove(atOffsets: offsets)
        saveMedications() // Salva os registros após deletar
    }
}

struct MedicacoesView_Previews: PreviewProvider {
    static var previews: some View {
        MedicacoesView()
    }
}
