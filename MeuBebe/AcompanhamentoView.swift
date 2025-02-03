import SwiftUI

struct AcompanhamentoView: View {
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var records: [(height: String, weight: String, date: Date)] = []

    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Altura (cm)", text: $height)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            TextField("Peso (kg)", text: $weight)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            
            Button(action: {
                if !height.isEmpty && !weight.isEmpty {
                    let newRecord = (height: height, weight: weight, date: Date())
                    self.records.append(newRecord)
                    self.saveRecords()
                    self.height = ""
                    self.weight = ""
                }
            }) {
                Text("Salvar Registro")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            
            List {
                ForEach(Array(records.enumerated()), id: \.element.date) { index, record in
                    VStack(alignment: .leading) {
                        Text("Data: \(formatDate(record.date))")
                        Text("Altura: \(record.height) cm")
                        Text("Peso: \(record.weight) kg")
                        
                        Button(action: {
                            self.editRecord(index: index)
                        }) {
                            Text("Editar")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .onDelete(perform: deleteRecord)
            }
        }
        .navigationTitle("Acompanhamento de Altura e Peso")
        .onAppear {
            self.loadRecords()
        }
    }

    
    func saveRecords() {
        let recordsData = records.map { ["height": $0.height, "weight": $0.weight, "date": $0.date] }
        UserDefaults.standard.set(recordsData, forKey: "alturaPesoRecords")
    }

    
    func loadRecords() {
        if let recordsData = UserDefaults.standard.array(forKey: "alturaPesoRecords") as? [[String: Any]] {
            self.records = recordsData.compactMap { dict in
                guard let height = dict["height"] as? String,
                      let weight = dict["weight"] as? String,
                      let date = dict["date"] as? Date else { return nil }
                return (height: height, weight: weight, date: date)
            }
        }
    }

    
    func editRecord(index: Int) {
        let record = records[index]
        self.height = record.height
        self.weight = record.weight
        self.records.remove(at: index)
    }

    
    func deleteRecord(at offsets: IndexSet) {
        records.remove(atOffsets: offsets)
        saveRecords() // Salva os registros após deletar
    }

    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy - HH:mm"
        return formatter.string(from: date)
    }
}

struct AcompanhamentoView_Previews: PreviewProvider {
    static var previews: some View {
        AcompanhamentoView()
    }
}

