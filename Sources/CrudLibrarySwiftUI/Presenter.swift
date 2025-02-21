import RxSwift

protocol UserPresenterProtocol {
    func loadUsers()
    func addUser(_ user: User)
    func editUser(_ user: User)
    func removeUser(_ id: Int)
    
    var users: PublishSubject<[User]> { get }
    var errorMessage: PublishSubject<String> { get }
}

class UserPresenter: UserPresenterProtocol {
    private let interactor: UserInteractorProtocol
    private let disposeBag = DisposeBag()
    
    var users = PublishSubject<[User]>()
    var errorMessage = PublishSubject<String>()
    
    init(interactor: UserInteractorProtocol) {
        self.interactor = interactor
    }
    
    func loadUsers() {
        interactor.fetchUsers()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { self.users.onNext($0) },
                       onError: { self.errorMessage.onNext($0.localizedDescription) })
            .disposed(by: disposeBag)
    }
    
    func addUser(_ user: User) {
        interactor.createUser(user)
            .subscribe(onNext: { _ in self.loadUsers() },
                       onError: { self.errorMessage.onNext($0.localizedDescription) })
            .disposed(by: disposeBag)
    }
    
    func editUser(_ user: User) {
        interactor.updateUser(user)
            .subscribe(onNext: { _ in self.loadUsers() },
                       onError: { self.errorMessage.onNext($0.localizedDescription) })
            .disposed(by: disposeBag)
    }
    
    func removeUser(_ id: Int) {
        interactor.deleteUser(id)
            .subscribe(onNext: { _ in self.loadUsers() },
                       onError: { self.errorMessage.onNext($0.localizedDescription) })
            .disposed(by: disposeBag)
    }
}
