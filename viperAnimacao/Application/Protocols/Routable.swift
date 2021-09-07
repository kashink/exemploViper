//
//  Routable.swift
//  viperAnimacao
//
//  Created by Roberto Ruiz on 04/09/21.
//

import Foundation
import UIKit

protocol BaseRoutableProtocol {
    var navigationController: AppNavigationController { get set }
}

class BaseRoutable: BaseRoutableProtocol {
    var navigationController = AppNavigationController()
}

protocol Routable: BaseRoutable {
    var view: Viewable! { get }

    func dismiss(animated: Bool)
    func pop(animated: Bool)
}

extension Routable {
    func dismiss(animated: Bool) {
        view.dismiss(animated: animated)
    }

    func pop(animated: Bool) {
        view.pop(animated: animated)
    }
}
