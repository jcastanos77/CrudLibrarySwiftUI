//import Alamofire
//import RxSwift
//
//protocol UserInteractorProtocol {
//    func fetchUsers() -> Observable<[User]>
//    func createUser(_ user: User) -> Observable<User>
//    func updateUser(_ user: User) -> Observable<User>
//    func deleteUser(_ id: Int) -> Observable<Bool>
//}
//
//class UserInteractor: UserInteractorProtocol {
//    
//    private let baseURL = "https://jsonplaceholder.typicode.com/users"
//
//    func fetchUsers() -> Observable<[User]> {
//        return Observable.create { observer in
//            AF.request(self.baseURL).responseDecodable(of: [User].self) { response in
//                switch response.result {
//                case .success(let users):
//                    observer.onNext(users)
//                    observer.onCompleted()
//                case .failure(let error):
//                    observer.onError(error)
//                }
//            }
//            return Disposables.create()
//        }
//    }
//
//    func createUser(_ user: User) -> Observable<User> {
//        
//        return Observable.create { observer in
//            AF.request(self.baseURL, method: .post, parameters: user, encoder: JSONParameterEncoder.default)
//                .responseDecodable(of: User.self) { response in
//                switch response.result {
//                case .success(let users):
//                    print("✅ Users recibidos:", users)
//                    observer.onNext(users)
//                    observer.onCompleted()
//                case .failure(let error):
//                    observer.onError(error)
//                }
//            }
//            return Disposables.create()
//        }
//    }
//
//    func updateUser(_ user: User) -> Observable<User> {
//        return Observable.create { observer in
//            AF.request("\(self.baseURL)/\(user.id)", method: .put,  parameters: user, encoder: JSONParameterEncoder.default)
//                .responseDecodable(of: User.self){ response in
//                switch response.result {
//                case .success(let users):
//                    observer.onNext(users)
//                    observer.onCompleted()
//                case .failure(let error):
//                    observer.onError(error)
//                }
//            }
//            return Disposables.create()
//        }
//    }
//
//    func deleteUser(_ id: Int) -> Observable<Bool> {
//        return Observable.create { observer in
//            AF.request("\(self.baseURL)/\(id)", method: .delete).response { response in
//                print("✅ Users eliminados:", response)
//                observer.onNext(response.error == nil)
//                observer.onCompleted()
//            }
//            return Disposables.create()
//        }
//    }
//}

import Foundation
import RxSwift
import Alamofire

protocol UserInteractorProtocol {
    func fetchUsers() -> Observable<[User]>
    func createUser(_ user: User) -> Observable<User>
    func updateUser(_ user: User) -> Observable<User>
    func deleteUser(_ id: Int) -> Observable<Void>
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
            let parameters: [String: Any] = [
                "name": user.name,
                "email": user.email,
                "phone": user.phone
            ]
            
            AF.request(self.baseURL, method: .post, parameters: user, encoder: JSONParameterEncoder.default)
                .responseDecodable(of: User.self) { response in
                    switch response.result {
                    case .success(let newUser):
                        observer.onNext(newUser)
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
            let parameters: [String: Any] = [
                "name": user.name,
                "email": user.email,
                "phone": user.phone
            ]
            
            guard let userId = user.id else {
                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid ID"]))
                return Disposables.create()
            }
            
            let url = "\(self.baseURL)/\(userId)"
            
            AF.request(url, method: .put, parameters: user, encoder: JSONParameterEncoder.default)
                .responseDecodable(of: User.self) { response in
                    switch response.result {
                    case .success(let updatedUser):
                        observer.onNext(updatedUser)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func deleteUser(_ id: Int) -> Observable<Void> {
        return Observable.create { observer in
            let url = "\(self.baseURL)/\(id)"
            
            AF.request(url, method: .delete)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        observer.onNext(())
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
