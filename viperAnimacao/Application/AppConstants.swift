//
//  AppConstants.swift
//  viperAnimacao
//
//  Created by Roberto Ruiz on 04/09/21.
//

import Foundation

struct AppConstants {

    static var apiClient: AppApiClient = AppApiClient()

    public static func baseURL() -> String {
        return "https://demo7472892.mockable.io"
    }
}
