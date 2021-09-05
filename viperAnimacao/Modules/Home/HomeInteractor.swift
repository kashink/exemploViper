//
//  HomeInteractor.swift
//  viperAnimacao
//
//  Created by fleury on 04/09/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol HomeInteractorOutputs {
    var isLoading: PublishSubject<Bool> { get }
    var error: BehaviorRelay<ApiError?> { get }
    var homeData: BehaviorRelay<HomeFeedEntity> { get }
    var selectedTab: BehaviorRelay<IndexPath?> { get }
}

protocol HomeInteractorInputs {
    func viewDidLoad()
    func selectedTab(indexPath: IndexPath)
}

final class HomeInteractor {
    private let disposeBag = DisposeBag()
    
    // Outputs
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = BehaviorRelay<ApiError?>(value: nil)
    let homeData = BehaviorRelay<HomeFeedEntity?>(value: nil)
    let selectedTab = BehaviorRelay<IndexPath?>(value: nil)
    
    let homeService: HomeService = HomeService()
    
    init() {}
    
    func viewDidLoad() {
        fetchHomeData()
    }
    
    func selectedTab(indexPath: IndexPath) {
        selectedTab.accept(indexPath)
    }
    
    // MARK: Fetch Home Data
    private func fetchHomeData() {
        self.isLoading.accept(true)
        
        homeService.fetchHomeData()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case let .success(data):
                    self.error.accept(nil)
                    self.homeData.accept(data)
                case .failure:
                    self.error.accept(ApiError.generic(codeError: 0))
                }
                self.isLoading.accept(false)
            }).disposed(by: disposeBag)
    }
}
