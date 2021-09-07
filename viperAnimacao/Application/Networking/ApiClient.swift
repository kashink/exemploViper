//
//  ApiClient.swift
//  viperAnimacao
//
//  Created by Roberto Ruiz on 04/09/21.
//

import Foundation
import Alamofire

//MARK: - Multipart form data mime type
public struct DataMimeType {
    public init(data: Data, name: String, file: String, mimeType: String) {
        self.data = data
        self.name = name
        self.file = file
        self.mimeType = mimeType
    }
    
    public var data: Data
    public var name: String
    public var file: String
    public var mimeType: String
}


//MARK: - Enum to return the request result or error
public enum ApiResult<T>: Equatable {
    case success(T)
    case failure(ApiError)
    
    public static func == (lhs: ApiResult, rhs: ApiResult) -> Bool {
        switch (lhs, rhs) {
        case (.failure, .failure), (.success, .success):
            return true
            
        default:
            return false
        }
    }
}

//MARK: - Errors Mapped
public enum ApiError: Error, Equatable {
    case forbidden(codeError: Int) //Status code 403
    case notFound(codeError: Int) //Status code 404
    case conflict(codeError: Int) //Status code 409
    case internalServerError(codeError: Int) //Status code 500
    case empty(codeError: Int) //no data
    case generic(codeError: Int) //generic error
    case parse(codeError: Int) //parse error
    case unauthorized(codeError: Int) //401
    case noInternetConnection(codeError: Int)
    case noContent(codeError: Int) //204
    case preCondition(codeError: Int) //412
    case customized(msgError: String, codeError: Int)
    
    public var errorMsg: String {
        switch self {
        case .forbidden:
            return "Acesso Negado"
        case .notFound:
            return "Não encontrado"
        case .conflict:
            return "Conflito"
        case .internalServerError:
            return "Ocorreu um erro no servidor"
        case .empty:
            return "Nenhum resultado"
        case .generic:
            return "Ocorreu um erro"
        case .parse:
            return "Não foi possível opter o dado"
        case .unauthorized:
            return "Não autorizado"
        case .customized(let msgError, _):
            return msgError
        case .noInternetConnection:
            return "Sem conexão"
        case .noContent:
            return "Nenhum conteúdo"
        case .preCondition:
            return "Condições incorretas"
        }
    }
    
    public var errorCode: Int {
        switch self {
        case .forbidden(let codeError):
            return codeError
        case .notFound(let codeError):
            return codeError
        case .conflict(let codeError):
            return codeError
        case .internalServerError(let codeError):
            return codeError
        case .empty(let codeError):
            return codeError
        case .generic(let codeError):
            return codeError
        case .parse(let codeError):
            return codeError
        case .unauthorized(let codeError):
            return codeError
        case .customized(_ , let codeError):
            return codeError
        case .noInternetConnection(let codeError):
            return codeError
        case .noContent(let codeError):
            return codeError
        case .preCondition(let codeError):
            return codeError
        }
    }
}

//MARK: - ApiClient to do requests
open class ApiClient {
    
    public lazy var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        let manager = Alamofire.Session(
            configuration: configuration
        )
        return manager
    }()
    
    public lazy var sessionManagerCode: Session = {
        let configuration = URLSessionConfiguration.default
        let manager = Alamofire.Session(
            configuration: configuration
        )
        return manager
    }()
    
    public lazy var sessionManagerToken: Session = {
        let configuration = URLSessionConfiguration.default
        let manager = Alamofire.Session(
            configuration: configuration
        )
        return manager
    }()
    
    public init() {
    }
    
    //MARK: Check if has access token for request
    public func request(useRetrier: Bool, _ urlConvertible: URLRequestConvertible, completion: @escaping (ApiResult<Data>) -> Void) {
        
        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            completion(.failure(.noInternetConnection(codeError: 999)))
        }
        
        self.apiRequest(useRetrier: useRetrier, urlConvertible) { (result) in
            completion(result)
        }
    }
    
    //MARK: Check if has access token for request
    public func requestWithBodyResponse(useRetrier: Bool, _ urlConvertible: URLRequestConvertible, completion: @escaping (ApiResult<Data>) -> Void) {
        
        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            completion(.failure(.noInternetConnection(codeError: 999)))
        }
        
        self.apiRequestWithBodyResponse(useRetrier: useRetrier, urlConvertible) { (result) in
            completion(result)
        }
    }
    
    //MARK: The request
    private func apiRequestWithBodyResponse(useRetrier: Bool, _ urlConvertible: URLRequestConvertible, completion: @escaping (ApiResult<Data>) -> Void) {
        
        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            completion(.failure(.noInternetConnection(codeError: 999)))
        }
        
        let request = self.sessionManager.request(urlConvertible)
        print("----------------------- cURL ------------------------------")
        Swift.debugPrint(request)
        request.validate().responseData { response in
            self.handleResponseWithBody(response, completion)
        }
    }
    
    //MARK: The request
    private func apiRequest(useRetrier: Bool, _ urlConvertible: URLRequestConvertible, completion: @escaping (ApiResult<Data>) -> Void) {
        
        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            completion(.failure(.noInternetConnection(codeError: 999)))
        }
        
        let request = self.sessionManager.request(urlConvertible)
        print("----------------------- cURL ------------------------------")
        Swift.debugPrint(request)
        request.validate().responseData { response in
            self.handleResponse(response, completion)
        }
    }
    
    //MARK: Check if has access token for request
    public func upload(useRetrier: Bool,
                       _ urlConvertible: URLRequestConvertible,
                       formData: @escaping (MultipartFormData) -> (),
                       completion: @escaping (ApiResult<Data>) -> Void) {
        
        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            completion(.failure(.noInternetConnection(codeError: 999)))
        }
        
        self.apiUpload(useRetrier: useRetrier, urlConvertible, formData) { result in
            completion(result)
        }
    }
    
    // MARK: - The upload
    private func apiUpload(useRetrier: Bool,
                           _ urlConvertible: URLRequestConvertible,
                           _ formDataCallback: @escaping (MultipartFormData) -> (),
                           completion: @escaping (ApiResult<Data>) -> Void) {
        
        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            completion(.failure(.noInternetConnection(codeError: 999)))
        }
        
        self.sessionManager
            .upload(multipartFormData: { multipart in
                formDataCallback(multipart)
            }, with: urlConvertible)
            .responseData(completionHandler: { response in
                if response.error != nil {
                    completion(.failure(.generic(codeError: 0)))
                }
                
                self.handleResponse(response, completion)
            })
    }
    
    private func handleResponseWithBody(_ response: DataResponse<Data, AFError>,
                                        _ completion: @escaping (ApiResult<Data>) -> Void) {
        #if DEBUG
        self.debugPrint(dataResponse: response)
        #endif
        
        guard let statusCode = response.response?.statusCode else {
            return completion(.failure(.generic(codeError: response.response?.statusCode ?? 0)))
        }
        
        if let data = response.data {
            completion(.success(data))
        } else {
            switch response.result {
            case .success:
                
                if statusCode == 204 {
                    completion(.failure(.noContent(codeError: statusCode)))
                }
                
                if statusCode >= 400 {
                    fallthrough
                }
                
                if let data = response.data {
                    completion(.success(data))
                    break
                } else {
                    completion(.failure(.empty(codeError: statusCode)))
                    break
                }
                
            case .failure:
                switch statusCode {
                case 403:
                    completion(.failure(.forbidden(codeError: statusCode)))
                case 404:
                    completion(.failure(.notFound(codeError: statusCode)))
                case 409:
                    completion(.failure(.conflict(codeError: statusCode)))
                case 500:
                    completion(.failure(.internalServerError(codeError: statusCode)))
                case 401:
                    completion(.failure(.unauthorized(codeError: statusCode)))
                case 412:
                    completion(.failure(.preCondition(codeError: statusCode)))
                default:
                    if NetworkReachabilityManager()?.isReachable ?? false {
                        completion(.failure(.generic(codeError: statusCode)))
                    } else {
                        completion(.failure(.noInternetConnection(codeError: statusCode)))
                    }
                }
            }
        }
    }
    
    private func handleResponse(_ response: DataResponse<Data, AFError>,
                                _ completion: @escaping (ApiResult<Data>) -> Void) {
        #if DEBUG
        self.debugPrint(dataResponse: response)
        #endif
        
        guard let statusCode = response.response?.statusCode else {
            return completion(.failure(.generic(codeError: response.response?.statusCode ?? 0)))
        }
        
        switch response.result {
        case .success:
            
            if statusCode == 204 {
                completion(.failure(.noContent(codeError: statusCode)))
            }
            
            if statusCode >= 400 {
                fallthrough
            }
            
            if let data = response.data {
                completion(.success(data))
                break
            } else {
                completion(.failure(.empty(codeError: statusCode)))
                break
            }
            
        case .failure:
            switch statusCode {
            case 403:
                completion(.failure(.forbidden(codeError: statusCode)))
            case 404:
                completion(.failure(.notFound(codeError: statusCode)))
            case 409:
                completion(.failure(.conflict(codeError: statusCode)))
            case 500:
                completion(.failure(.internalServerError(codeError: statusCode)))
            case 401:
                completion(.failure(.unauthorized(codeError: statusCode)))
            case 412:
                completion(.failure(.preCondition(codeError: statusCode)))
            default:
                if NetworkReachabilityManager()?.isReachable ?? false {
                    completion(.failure(.generic(codeError: statusCode)))
                } else {
                    completion(.failure(.noInternetConnection(codeError: statusCode)))
                }
            }
        }
    }
    
    func debugPrint(dataResponse: DataResponse<Data, AFError>) {
        guard let response = dataResponse.response else {
            print("Invalid response")
            return
        }
        
        print("----------------------- RESPONSE ------------------------------")
        print("Request \(response.url?.absoluteString ?? "-no url-") completed with status code \(response.statusCode)")
        print("headers:")
        response.allHeaderFields.forEach() { (key,value) in
            print("\(key) = \(value)")
        }
        
        if let data = dataResponse.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data:")
            print("\(utf8Text)")
        }
        
        print("---------------------------------------------------------------")
        
        guard let request = dataResponse.request else {
            print("Invalid request")
            return
        }
        print("----------------------- RESQUEST ------------------------------")
        print("Request \(request.url?.absoluteString ?? "-no url-") completed with status code \(response.statusCode)")
        print("Method: \(request.httpMethod ?? "?")")
        print("headers:")
        request.allHTTPHeaderFields?.forEach() { (key,value) in
            print("\(key) = \(value)")
        }
        if let data = request.httpBody, let utf8Text = String(data: data, encoding: .utf8) {
            print("Body:")
            print("\(utf8Text)")
        }
    }
    
    //MARK: Check if has access token for request with response header
    public func requestWithResponseHeader(useRetrier: Bool, _ urlConvertible: URLRequestConvertible, completion: @escaping (ApiResult<(Data, [AnyHashable : Any]?)>) -> Void) {
        
        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            completion(.failure(.noInternetConnection(codeError: 999)))
        }
        
        self.apiRequestWithResponseHeader(useRetrier: useRetrier, urlConvertible) { (result) in
            completion(result)
        }
    }
    
    //MARK: The request with response header
    private func apiRequestWithResponseHeader(useRetrier: Bool, _ urlConvertible: URLRequestConvertible, completion: @escaping (ApiResult<(Data, [AnyHashable : Any]?)>) -> Void) {
        
        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            completion(.failure(.noInternetConnection(codeError: 999)))
        }
        
        let request = self.sessionManager.request(urlConvertible)
        print("----------------------- cURL ------------------------------")
        Swift.debugPrint(request)
        request.validate().responseData(completionHandler: { response in
            
            #if DEBUG
            self.debugPrint(dataResponse: response)
            #endif
            
            switch response.result {
            case .success:
                if response.response?.statusCode == 204 {
                    completion(.failure(.noContent(codeError: response.response?.statusCode ?? 0)))
                }else {
                    if let data = response.data {
                        let total = response.response?.allHeaderFields
                        completion(.success((data, total)))
                        break
                    }else {
                        completion(.failure(.empty(codeError: response.response?.statusCode ?? 0)))
                        break
                    }
                }
                
            case .failure:
                guard let statusCode = response.response?.statusCode else {
                    return completion(.failure(.generic(codeError: response.response?.statusCode ?? 0)))
                }
                switch statusCode {
                case 403:
                    completion(.failure(.forbidden(codeError: statusCode)))
                case 404:
                    completion(.failure(.notFound(codeError: statusCode)))
                case 409:
                    completion(.failure(.conflict(codeError: statusCode)))
                case 500:
                    completion(.failure(.internalServerError(codeError: statusCode)))
                case 401:
                    completion(.failure(.unauthorized(codeError: statusCode)))
                case 412:
                    completion(.failure(.preCondition(codeError: statusCode)))
                default:
                    if NetworkReachabilityManager()?.isReachable ?? false {
                        completion(.failure(.generic(codeError: statusCode)))
                    }else {
                        completion(.failure(.noInternetConnection(codeError: statusCode)))
                    }
                }
            }
        })
        
    }
}
