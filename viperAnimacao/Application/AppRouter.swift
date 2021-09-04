//
//  AppRouter.swift
//  viperAnimacao
//
//  Created by fleury on 04/09/21.
//

import Foundation
import UIKit
import RxSwift

class AppRouter: BaseRoutable {
    var window = UIWindow(frame: UIScreen.main.bounds)
    private let disposeBag = DisposeBag()
    
    override init() { }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let vc = HomeRouter().view(parentView: navigationController)
        navigationController.push(vc, animated: true)
    }
}
