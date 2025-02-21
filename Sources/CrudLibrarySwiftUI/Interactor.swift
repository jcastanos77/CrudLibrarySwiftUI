import Alamofire
import RxSwift

protocol UserInteractorProtocol {
    func fetchUsers() -> Observable<[User]>
    func createUser(_ user: User) -> Observable<User>
    func updateUser(_ user: User) -> Observable<User>
    func deleteUser(_ id: Int) -> Observable<Bool>
}

class UserInteractor: UserInteractorProtocol {
    
    private let baseURL = "https://jsonplaceholder.typicode.com/users"

    func fetchUsers() -> Observable<[User]> {
        return Observable.create { observer in
            AF.request(self.baseURL).responseDecodable(of: [User].self) { response in
                switch response.result {
                case .success(let users):
                    observer.onNext(users)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func createUser(_ user: User) -> Observable<User> {
        
        return Observable.create { observer in
            AF.request(self.baseURL, method: .post, parameters: user, encoder: JSONParameterEncoder.default)
                .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let users):
                    observer.onNext(users)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func updateUser(_ user: User) -> Observable<User> {
        return Observable.create { observer in
            AF.request("\(self.baseURL)/\(user.id)", method: .put,  parameters: user, encoder: JSONParameterEncoder.default)
                .responseDecodable(of: User.self){ response in
                switch response.result {
                case .success(let users):
                    observer.onNext(users)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func deleteUser(_ id: Int) -> Observable<Bool> {
        return Observable.create { observer in
            AF.request("\(self.baseURL)/\(id)", method: .delete).response { response in
                observer.onNext(response.error == nil)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
