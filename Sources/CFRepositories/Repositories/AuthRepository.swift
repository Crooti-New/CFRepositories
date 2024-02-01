//
//  AuthWebRepository.swift
//  iOSRepositories
//
//  Created by Cuong Le on 28/5/21.
//  Copyright © All rights reserved.
//
// swiftlint:disable line_length
#if canImport(Combine) && os(iOS)
import Combine
import Foundation

public protocol AuthRepository: WebRepository {
//    func singUp(customer: UserInfo) async throws -> UserInfo
//    func forgotPassword(login: String) async throws -> SessionOutput
//
    func signIn(email: String, password: String) async throws -> TokenInfo
    func getUserInfo() async throws -> UserInfo
    func syncDeviceInfo()
}

struct AuthRepositoryImpl {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_auth_queue") // , attributes: .concurrent
    var interceptor: RequestInterceptor?
    
//    @Injected var appState: AppStore<AppState>
//    @Injected var env: EnvironmentCompany
    
    init(configuration: ServiceConfiguration) {
        self.session = configuration.urlSession
        self.baseURL = configuration.environment.url
//        self.interceptor = configuration.interceptor
    }
}

public enum AuthError: Error, LocalizedError {
    case tokenFindError
    case authNeeded
    public var errorDescription: String? {
        "Unable to find the token, please check the request header."
    }
}

// MARK: - Async impl
extension AuthRepositoryImpl: AuthRepository {
//    func singUp(customer: Customer) async throws -> Customer {
//        let tmpCustomer = customer.with {
//            $0.companyId = self.env.companyId
//            $0.customerType = "MEMBER"
//            $0.language = Locale.current.languageCode
//        }.asDictionary
//        let result = try await tokenParser(endpoint: API.singUp(param: tmpCustomer), logger: .debug)
//        let customer: Customer = try await decodeJSON(data: result.data)
//        _ = try? KeychainStore.shared.store(item: customer, for: .customer, update: \.userData.customer)
//        return customer
//    }
//
//    func forgotPassword(login: String) async throws -> SessionOutput {
//        let param: Parameters = ["email": login, "companyId": env.companyId]
//        return try await execute(endpoint: API.forgotPassword(param: param), logLevel: .debug)
//    }
//
    func signIn(email: String, password: String) async throws -> TokenInfo {
        
        let param: Parameters = [
            Constants.IdentityClientIdHeader: Constants.IdentityClientIdValue,
            Constants.IdentityClientSecretHeader: Constants.IdentityClientSecretValue,
            Constants.IdentityGrantTypeHeader: Constants.IdentityGrantTypeValue,
            Constants.IdentityScopeHeader: Constants.IdentityScopeValue,
            "username": email, "password": password]
        
        let tokenInfo:TokenInfo = try await execute(endpoint: API.signIn(param: param), isFullPath: true, logLevel: .debug)
        UserDefaultHandler.userTokenInfo = tokenInfo
        return tokenInfo
    }
    
    func getUserInfo() async throws -> UserInfo {
        
    }
    
    func syncDeviceInfo() {
        
    }
    
}

// MARK: - Configuration
extension AuthRepositoryImpl {
    enum API: ResourceType {
        case signIn(param: Parameters),
             signUp(param: Parameters),
             forgotPassword(param: Parameters),
             getUserInfo(param: Parameters),
             syncDeviceInfo(param: Parameters)
        
        var endPoint: Endpoint {
            switch self {
            case .signIn:
                return .post(path: "https://auth.crooti.com/connect/token")
            case .signUp:
                return .post(path: "/account/register")
            case .forgotPassword:
                return .post(path: "/account/forgotPassword")
            case .getUserInfo:
                return .get(path: "/account/getUserInfo")
            case .syncDeviceInfo:
                return .post(path: "/account/submitDeviceInfo")
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .signUp(let param), .forgotPassword(let param), .syncDeviceInfo(let param) :
                return .requestParameters(bodyParameters: param, encoding: .jsonEncoding)
            case .signIn(let param):
                return .requestParameters(encoding: .urlEncodingPOST, urlParameters: param)
            case .getUserInfo(let param):
                return .requestParameters(encoding: .urlEncodingGET, urlParameters: param)
            }
        }
        
        var headers: HTTPHeaders? {
            authHeader
        }
    }
}

#endif
