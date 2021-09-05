//
//  AppApiClient.swift
//  viperAnimacao
//
//  Created by fleury on 04/09/21.
//

import Foundation
import RxSwift
import RxCocoa

public class AppApiClient: ApiClient {
    
    // MARK: Fetch Home Data
    func fetchHomeData(completion: @escaping (ApiResult<HomeFeedEntity>) -> Void) {

        self.request(useRetrier: true, ApiRouter.fetchHomeData) { (profile) in
            switch profile {
            case let .success(data):
                do {
                    let data = try JSONDecoder().decode(HomeFeedEntity.self, from: data)
                    completion(.success(data))
                } catch let error {
                    print(error)
                    completion(.failure(.parse(codeError: 0)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
