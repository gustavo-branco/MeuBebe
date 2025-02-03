import SwiftUI
import UIKit

struct ContentView: View {
    @State private var babyName: String = UserDefaults.standard.string(forKey: "babyName") ?? ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Meu Bebê")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // Foto do bebê
                ZStack {
                    if let image = inputImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }

                // Campo para digitar o nome do bebê
                TextField("Digite o nome do bebê", text: $babyName, onCommit: saveBabyName)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Botões para funcionalidades
                NavigationLink(destination: AmamentacaoView()) {
                    Text("Amamentação")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: SonoView()) {
                    Text("Sono")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: TrocaFraldasView()) {
                    Text("Troca de Fraldas")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: MedicacoesView()) {
                    Text("Últimas Medicações")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: ConsultasView()) {
                    Text("Consultas ao Pediatra")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: VacinasView()) {
                    Text("Vacinas")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: AcompanhamentoView()) {
                    Text("Acompanhamento de Altura e Peso")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: AnotacoesView()) {
                    Text("Anotações")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationBarHidden(true)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .onAppear {
                loadSavedImage()
            }
        }
    }

    // Salva o nome do bebê no UserDefaults
    func saveBabyName() {
        UserDefaults.standard.set(babyName, forKey: "babyName")
    }

    // Salva a imagem no armazenamento local
    func saveImage() {
        guard let image = inputImage else { return }
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent("babyImage.jpg")
            try? data.write(to: filename)
        }
    }

    // Carrega a imagem salva
    func loadSavedImage() {
        let filename = getDocumentsDirectory().appendingPathComponent("babyImage.jpg")
        if let data = try? Data(contentsOf: filename), let savedImage = UIImage(data: data) {
            inputImage = savedImage
        }
    }

    // Obtém o diretório de documentos do app
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // Função para carregar a imagem e salvá-la
    func loadImage() {
        saveImage()
    }
}

// Estrutura para o seletor de fotos
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
