//
//  ApiRouter.swift
//  viperAnimacao
//
//  Created by Roberto Ruiz on 04/09/21.
//

import Foundation
import Alamofire

struct Header {
    var key: String
    var value: String
}

enum ApiRouter: URLRequestConvertible {
    
    case fetchHomeData

    func asURLRequest() throws -> URLRequest {

        let url = try AppConstants.baseURL().asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        var fullPathStr = AppConstants.baseURL() + path

        if path.contains("http") {
            fullPathStr = path
            urlRequest = URLRequest(url: URL(string: path) ?? url.appendingPathComponent(path))
        }

        if let encoded = fullPathStr.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let auxUrl = URL(string: encoded) {
            urlRequest = URLRequest(url: auxUrl)
        }

        // Http method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let headers = self.headers {
            for header in headers {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        // Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()

        urlRequest.httpBody = data
        return try encoding.encode(urlRequest, with: parameters)
    }

    // MARK: - Path
    private var path: String {
        switch self {
        case .fetchHomeData:
            return "/testelista"
        }
    }

    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    // MARK: - Headers
    private var headers: [Header]? {
        switch self {
        default:
            return nil
        }
    }

    // MARK: - Data
    private var data: Data? {
        switch self {
        default:
            return nil
        }
    }

    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
}
