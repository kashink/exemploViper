//
//  HomeService.swift
//  viperAnimacao
//
//  Created by Roberto Ruiz on 04/09/21.
//

import Foundation
import RxSwift

class HomeService {
    public typealias DataHome = ApiResult<HomeFeedEntity>

    init() {}
    
    func fetchHomeData() -> Observable<DataHome> {

        return Observable<DataHome>.create { observer in

            AppConstants.apiClient.fetchHomeData() { data in

                observer.onNext(data)
                observer.onCompleted()

            }
            return Disposables.create()
        }
    }
}
