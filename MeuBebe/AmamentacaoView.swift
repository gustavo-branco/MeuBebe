import SwiftUI

struct AmamentacaoView: View {
    @State private var feedings: [Date] = []

    var body: some View {
        VStack {
            List {
                ForEach(feedings, id: \.self) { feeding in
                    Text("Mamou em: \(formatDate(feeding))")
                }
                .onDelete(perform: deleteFeeding)
            }

            Button(action: {
                self.feedings.append(Date())
                self.saveFeedings() // Salva os registros
            }) {
                Text("Registrar Amamentação")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Amamentação")
        .onAppear {
            self.loadFeedings() // Carrega os registros ao abrir a tela
        }
    }

    // Função para salvar os registros no UserDefaults
    func saveFeedings() {
        UserDefaults.standard.set(feedings, forKey: "feedings")
    }

    // Função para carregar os registros do UserDefaults
    func loadFeedings() {
        if let savedFeedings = UserDefaults.standard.array(forKey: "feedings") as? [Date] {
            self.feedings = savedFeedings
        }
    }

    // Função para formatar a data
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm - dd/MM/yyyy"
        return formatter.string(from: date)
    }

    // Função para deletar uma mamada
    func deleteFeeding(at offsets: IndexSet) {
        feedings.remove(atOffsets: offsets)
        saveFeedings() // Salva os registros após deletar
    }
}

struct AmamentacaoView_Previews: PreviewProvider {
    static var previews: some View {
        AmamentacaoView()
    }
}
