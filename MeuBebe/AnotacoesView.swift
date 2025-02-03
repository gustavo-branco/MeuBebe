import SwiftUI

struct AnotacoesView: View {
    @State private var notes: [String] = []
    @State private var newNote: String = ""
    @State private var editingNoteIndex: Int? = nil

    var body: some View {
        VStack {
            TextField("Digite sua anotação...", text: $newNote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                if !newNote.isEmpty {
                    if let index = editingNoteIndex {
                        notes[index] = newNote // Edita a anotação existente
                        editingNoteIndex = nil
                    } else {
                        notes.append(newNote) // Adiciona uma nova anotação
                    }
                    saveNotes() // Salva as anotações
                    newNote = ""
                }
            }) {
                Text(editingNoteIndex == nil ? "Adicionar Anotação" : "Salvar Edição")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            List {
                ForEach(Array(notes.enumerated()), id: \.element) { index, note in
                    VStack(alignment: .leading) {
                        Text(note)
                        
                        Button(action: {
                            self.newNote = note
                            self.editingNoteIndex = index
                        }) {
                            Text("Editar")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .onDelete(perform: deleteNote)
            }
        }
        .navigationTitle("Anotações")
        .onAppear {
            loadNotes() // Carrega as anotações ao abrir a tela
        }
    }

    // Função para salvar as anotações no UserDefaults
    func saveNotes() {
        UserDefaults.standard.set(notes, forKey: "notes")
    }

    // Função para carregar as anotações do UserDefaults
    func loadNotes() {
        if let savedNotes = UserDefaults.standard.array(forKey: "notes") as? [String] {
            self.notes = savedNotes
        }
    }

    // Função para deletar uma anotação
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes() // Salva as anotações após deletar
    }
}

struct AnotacoesView_Previews: PreviewProvider {
    static var previews: some View {
        AnotacoesView()
    }
}
