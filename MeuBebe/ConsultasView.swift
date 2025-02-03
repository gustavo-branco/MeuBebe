import SwiftUI

struct ConsultasView: View {
    @State private var appointmentDate: Date = Date()
    @State private var appointments: [Date] = []

    var body: some View {
        VStack {
            DatePicker("Selecione a data da consulta", selection: $appointmentDate, displayedComponents: .date)
                .padding()

            Button(action: {
                self.appointments.append(appointmentDate)
                self.saveAppointments()
            }) {
                Text("Registrar Consulta")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            List {
                ForEach(appointments, id: \.self) { appointment in
                    Text("Consulta em: \(formatDate(appointment))")
                }
                .onDelete(perform: deleteAppointment)
            }
        }
        .navigationTitle("Consultas ao Pediatra")
        .onAppear {
            self.loadAppointments()
        }
    }

    // Função para salvar os registros no UserDefaults
    func saveAppointments() {
        UserDefaults.standard.set(appointments, forKey: "appointments")
    }

    // Função para carregar os registros do UserDefaults
    func loadAppointments() {
        if let savedAppointments = UserDefaults.standard.array(forKey: "appointments") as? [Date] {
            self.appointments = savedAppointments
        }
    }

    // Função para formatar a data
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    // Função para deletar uma consulta
    func deleteAppointment(at offsets: IndexSet) {
        appointments.remove(atOffsets: offsets)
        saveAppointments()
    }
}

struct ConsultasView_Previews: PreviewProvider {
    static var previews: some View {
        ConsultasView()
    }
}
