import SwiftUI

struct VacinasView: View {
    @State private var vaccines: [Vaccine] = [
       
        Vaccine(name: "BCG", applied: false),
        Vaccine(name: "Hepatite B", applied: false),
        Vaccine(name: "Tríplice bacteriana acelular", applied: false),
        Vaccine(name: "Haemophilus influenzae tipo b", applied: false),
        Vaccine(name: "Poliomielite", applied: false),
        Vaccine(name: "Pneumocócica conjugada", applied: false),
        Vaccine(name: "Rotavírus", applied: false),
        Vaccine(name: "Meningocócica conjugada ACWY", applied: false),
        Vaccine(name: "Meningocócica B", applied: false),
        Vaccine(name: "Febre amarela", applied: false),
        Vaccine(name: "Sarampo", applied: false),
        Vaccine(name: "Caxumba", applied: false),
        Vaccine(name: "Rubéola", applied: false),
        Vaccine(name: "Varicela", applied: false),
        Vaccine(name: "Hepatite A", applied: false),
        Vaccine(name: "Tríplice viral", applied: false),
        Vaccine(name: "Dengue", applied: false),
        Vaccine(name: "HPV", applied: false),
        Vaccine(name: "Tríplice acelular tipo adulto", applied: false),
        Vaccine(name: "Meningocócica conjugada ACWY", applied: false)
    ]

    var body: some View {
        VStack {
            List {
                ForEach($vaccines) { $vaccine in
                    HStack {
                        Toggle(isOn: $vaccine.applied) {
                            Text(vaccine.name)
                                .font(.body)
                        }
                    }
                }
                .onDelete(perform: deleteVaccine)
            }

            Button(action: {
                self.saveVaccines() // Salva as vacinas
            }) {
                Text("Salvar Vacinas")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Vacinas")
        .onAppear {
            self.loadVaccines() // Carrega as vacinas salvas
        }
    }

    // Função para salvar os registros no UserDefaults
    func saveVaccines() {
        let vaccineData = vaccines.map { ["name": $0.name, "applied": $0.applied] }
        UserDefaults.standard.set(vaccineData, forKey: "vaccines")
    }

    // Função para carregar os registros do UserDefaults
    func loadVaccines() {
        if let savedVaccines = UserDefaults.standard.array(forKey: "vaccines") as? [[String: Any]] {
            self.vaccines = savedVaccines.compactMap { dict in
                if let name = dict["name"] as? String, let applied = dict["applied"] as? Bool {
                    return Vaccine(name: name, applied: applied)
                }
                return nil
            }
        }
    }

    // Função para deletar uma vacina
    func deleteVaccine(at offsets: IndexSet) {
        vaccines.remove(atOffsets: offsets)
        saveVaccines() // Salva os registros após deletar
    }
}

struct Vaccine: Identifiable {
    var id = UUID()
    var name: String
    var applied: Bool
}

struct VacinasView_Previews: PreviewProvider {
    static var previews: some View {
        VacinasView()
    }
}
