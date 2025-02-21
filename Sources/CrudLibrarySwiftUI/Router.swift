//
//  Router.swift
//  CrudLibrarySwiftUI
//
//  Created by JECASTAÑOSM on 20/02/25.
//

import SwiftUI
 
@available(iOS 14.0.0, *)
class UserRouter {
    @MainActor static func createUserView() -> some View {
        let interactor = UserInteractor()
        let presenter = UserPresenter(interactor: interactor)
        return UserView(presenter: presenter)
    }
}
