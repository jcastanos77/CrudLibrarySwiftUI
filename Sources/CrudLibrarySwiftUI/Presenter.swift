import Foundation
import RxSwift

protocol UserPresenterProtocol {
    var users: PublishSubject<[User]> { get }
    func loadUsers()
    func addUser(name: String, email: String)
    func removeUser(id: Int)
}

class UserPresenter: UserPresenterProtocol {
    private let interactor: UserInteractorProtocol
    private let disposeBag = DisposeBag()
    
    var users = PublishSubject<[User]>()

    init(interactor: UserInteractorProtocol) {
        self.interactor = interactor
    }

    func loadUsers() {
        interactor.fetchUsers()
            .subscribe(onNext: { users in
                self.users.onNext(users)
            }, onError: { error in
                print("Error fetching users: \(error)")
            }).disposed(by: disposeBag)
    }

    func addUser(name: String, email: String) {
        let newUser = User(id: Int.random(in: 1000...9999), name: name, email: email)
        interactor.createUser(newUser)
            .subscribe(onNext: { success in
                    self.loadUsers()
            }).disposed(by: disposeBag)
    }

    func removeUser(id: Int) {
        interactor.deleteUser(id)
            .subscribe(onNext: { success in
                if success { self.loadUsers() }
            }).disposed(by: disposeBag)
    }
}
