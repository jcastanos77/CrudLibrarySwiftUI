import SwiftUI
import RxSwift

@available(iOS 14.0, *)
struct UserView: View {
    @ObservedObject private var viewModel: UserViewModel
    
    init(presenter: UserPresenter) {
        self.viewModel = UserViewModel(presenter: presenter)
    }

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.users) { user in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(user.name).font(.headline)
                            Text(user.email).font(.subheadline)
                        }
                        Spacer()
                        Button(action: {
                            viewModel.deleteUser(id: user.id)
                        }) {
                            Image(systemName: "trash").foregroundColor(.red)
                        }
                    }
                }
                
                Button(action: {
                    viewModel.addUser(name: "Nuevo Usuario", email: "nuevo@correo.com")
                }) {
                    Text("Agregar Usuario").padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
                }
                .padding()
            }
            .onAppear {
                viewModel.loadUsers()
            }
            .navigationTitle("Usuarios")
        }
    }
}

@available(iOS 13.0, *)
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    
    private let presenter: UserPresenter
    private let disposeBag = DisposeBag()

    init(presenter: UserPresenter) {
        self.presenter = presenter
        bind()
    }

    private func bind() {
        presenter.users
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { users in
                self.users = users
            })
            .disposed(by: disposeBag)
    }

    func loadUsers() {
        presenter.loadUsers()
    }

    func addUser(name: String, email: String) {
        presenter.addUser(name: name, email: email)
    }

    func deleteUser(id: Int) {
        presenter.removeUser(id: id)
    }
}
