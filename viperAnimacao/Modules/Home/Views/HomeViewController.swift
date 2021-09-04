//
//  HomeViewController.swift
//  viperAnimacao
//
//  Created by fleury on 04/09/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    var presenter: HomePresenterInterface!
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: "HomeViewController", bundle: Bundle(for: HomeViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        presenter.outputs.isLoading
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
//                print(isLoading)
            }).disposed(by: disposeBag)
        
        presenter.outputs.homeData
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
//                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        presenter.outputs.error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
//                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        presenter.inputs.viewDidLoadTrigger.onNext(())
    }
}

extension HomeViewController: Viewable {}
