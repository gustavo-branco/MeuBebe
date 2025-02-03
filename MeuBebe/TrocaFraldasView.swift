import SwiftUI

struct TrocaFraldasView: View {
    @State private var changes: [Date] = []

    var body: some View {
        VStack {
            List {
                ForEach(changes, id: \.self) { change in
                    Text("Troca de Fralda em: \(formatDate(change))")
                }
                .onDelete(perform: deleteChange)
            }

            Button(action: {
                self.changes.append(Date())
                self.saveChanges() // Salva os registros
            }) {
                Text("Registrar Troca de Fralda")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Troca de Fraldas")
        .onAppear {
            self.loadChanges() // Carrega os registros ao abrir a tela
        }
    }

    // Função para salvar os registros no UserDefaults
    func saveChanges() {
        UserDefaults.standard.set(changes, forKey: "changes")
    }

    // Função para carregar os registros do UserDefaults
    func loadChanges() {
        if let savedChanges = UserDefaults.standard.array(forKey: "changes") as? [Date] {
            self.changes = savedChanges
        }
    }

    // Função para formatar a data
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm - dd/MM/yyyy"
        return formatter.string(from: date)
    }

    // Função para deletar uma troca de fralda
    func deleteChange(at offsets: IndexSet) {
        changes.remove(atOffsets: offsets)
        saveChanges() // Salva os registros após deletar
    }
}

struct TrocaFraldasView_Previews: PreviewProvider {
    static var previews: some View {
        TrocaFraldasView()
    }
}
