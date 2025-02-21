//
//  UserFormView.swift
//  CrudLibrarySwiftUI
//
//  Created by JECASTAÑOSM on 20/02/25.
//


import SwiftUI

@available(iOS 14.0, *)
struct UserFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var name: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    var user: User?
    var onSave: (User) -> Void
    
    init(user: User? = nil, onSave: @escaping (User) -> Void) {
        self.user = user
        self.onSave = onSave
        _name = State(initialValue: user?.name ?? "")
        _email = State(initialValue: user?.email ?? "")
        _phone = State(initialValue: user?.phone ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información del Usuario")) {
                    TextField("Nombre", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Teléfono", text: $phone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle(user == nil ? "Nuevo Usuario" : "Editar Usuario")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        let newUser = User(id: user?.id, name: name, email: email, phone: phone)
                        onSave(newUser)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
