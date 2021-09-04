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
    var homeData: BehaviorRelay<[String]> { get }
}

protocol HomeInteractorInputs {
    func viewDidLoad()
}

final class HomeInteractor {
    private let disposeBag = DisposeBag()
    
    // Outputs
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = BehaviorRelay<ApiError?>(value: nil)
    let homeData = BehaviorRelay<[String]>(value: [])
    
    let homeService: HomeService = HomeService()
    
    init() {}
    
    func viewDidLoad() {
        fetchHomeData()
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
