//
//  HomeRouter.swift
//  viperAnimacao
//
//  Created by fleury on 04/09/21.
//

import Foundation
import UIKit

class HomeRouter {
    
    private(set) weak var view: Viewable!
    var delegate: AppNavigationController?
    var navigationController: UINavigationController = UINavigationController()
    
    init(_ view: Viewable? = nil, delegate: AppNavigationController? = nil) {
        self.delegate = delegate
        self.view = view
    }
    
    func view(parentView: Viewable) -> HomeViewController {
        if let vc = parentView as? AppNavigationController {
            delegate = vc
        }

        let view = HomeViewController()
        let interactor = HomeInteractor()
        let dependencies = HomePresenterDependencies(interactor: interactor, router: HomeRouter(view, delegate: delegate))
        let presenter = HomePresenter(dependencies: dependencies)
        view.presenter = presenter

        return view
    }
    
    func present(from: Viewable) {
        let vc = view(parentView: from)
        from.present(vc, animated: true)
    }

    func push(from: Viewable) {
        let vc = view(parentView: from)
        from.push(vc, animated: true)
    }
    
}
