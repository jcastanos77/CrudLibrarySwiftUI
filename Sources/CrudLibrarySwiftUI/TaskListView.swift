import SwiftUI
import RxSwift

@available(iOS 14.0, *)
struct UserListView: View {
    @StateObject var viewModel = UserViewModel(presenter: UserPresenter(interactor: UserInteractor()))
    @State private var showForm = false
    @State private var selectedUser: User?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.users, id: \.id) { user in
                    VStack(alignment: .leading) {
                        Text(user.name).font(.headline)
                        Text(user.email).font(.subheadline)
                    }
                    .onTapGesture {
                        selectedUser = user
                        showForm = true
                    }
                }
                .onDelete(perform: deleteUser)
            }
            .navigationTitle("Usuarios")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedUser = nil
                        showForm = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showForm) {
                UserFormView(user: selectedUser) { user in
                    if let _ = user.id {
                        viewModel.editUser(user: user)
                    } else {
                        viewModel.addUser(user: user)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadUsers()
        }
    }
    
    private func deleteUser(at offsets: IndexSet) {
        offsets.forEach { index in
            let user = viewModel.users[index]
            if let userId = user.id {
                viewModel.removeUser(userId: userId)
            }
        }
    }
}


@available(iOS 13.0, *)
@MainActor
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
            .subscribe(onNext: { self.users = $0 })
            .disposed(by: disposeBag)
    }
    
    func loadUsers() {
        presenter.loadUsers()
    }
    
    func editUser(user: User) {
        presenter.editUser(user)
    }
    
    func removeUser(userId: Int) {
        presenter.removeUser(userId)
    }
    
    func addUser(user: User) {
        presenter.addUser(user)
    }
}
