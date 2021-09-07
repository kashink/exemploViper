//
//  HomePresenter.swift
//  viperAnimacao
//
//  Created by Roberto Ruiz on 04/09/21.
//

import Foundation
import RxSwift
import RxCocoa

typealias HomePresenterDependencies = (
    interactor: HomeInteractor,
    router: HomeRouter
)

protocol HomePresenterInputs {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var tabSelectedTrigger: PublishSubject<IndexPath> { get }
}

protocol HomePresenterOutputs {
    var isLoading: BehaviorRelay<Bool> { get }
    var error: BehaviorRelay<ApiError?> { get }
    var homeData: BehaviorRelay<HomeFeedEntity?> { get }
    var selectedTab: BehaviorRelay<IndexPath?> { get }
}

protocol HomePresenterInterface {
    var inputs: HomePresenterInputs { get }
    var outputs: HomePresenterOutputs { get }
}

final class HomePresenter: HomePresenterInterface, HomePresenterInputs, HomePresenterOutputs {

    var inputs: HomePresenterInputs { return self }
    var outputs: HomePresenterOutputs { return self }
    
    // Inputs
    let viewDidLoadTrigger = PublishSubject<Void>()
    let tabSelectedTrigger = PublishSubject<IndexPath>()

    // Outputs
    let isLoading: BehaviorRelay<Bool>
    var error: BehaviorRelay<ApiError?>
    let homeData: BehaviorRelay<HomeFeedEntity?>
    var selectedTab: BehaviorRelay<IndexPath?>

    private let dependencies: HomePresenterDependencies
    private let disposeBag = DisposeBag()

    init(dependencies: HomePresenterDependencies) {

        self.dependencies = dependencies

        self.isLoading = dependencies.interactor.isLoading
        self.error = dependencies.interactor.error
        self.homeData = dependencies.interactor.homeData
        self.selectedTab = dependencies.interactor.selectedTab
        
        viewDidLoadTrigger
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.viewDidLoad()
            }).disposed(by: disposeBag)
        
        tabSelectedTrigger
            .asObservable()
            .subscribe(onNext: { [weak self] tabSelected in
                self?.dependencies.interactor.selectedTab(indexPath: tabSelected)
            }).disposed(by: disposeBag)
    }
    
    func viewDidLoad() {
        dependencies.interactor.viewDidLoad()
    }
}
