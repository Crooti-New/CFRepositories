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
    func signIn(email: String, password: String) async throws -> TokenInfo
    func getUserInfo() async throws -> UserInfo
    func syncDeviceInfo()
    func signUp(model: SignUpModel) async throws -> SignUpInfo
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
        return UserInfo(email: "", firstName: "", lastName: "", username: "", userImageLink: "", emailConfirmed: true, numberOfShares: 0, numberOfFavourites: 0, phoneNumberConfirmed: true, phoneNumber: "", registeredOn: "", allowLogin: true, enablePushNotifications: true)
    }
    
    func syncDeviceInfo() {
        
    }
    
    func signUp(model: SignUpModel) async throws -> SignUpInfo {
        let param: Parameters = [
            Constants.IdentityClientIdHeader: Constants.IdentityClientIdValue,
            Constants.IdentityClientSecretHeader: Constants.IdentityClientSecretValue,
            Constants.IdentityGrantTypeHeader: Constants.IdentityGrantTypeValue,
            Constants.IdentityScopeHeader: Constants.IdentityScopeValue,
            "firstName": model.firstName,
            "lastName": model.lastName,
            "password": model.password,
            "email": model.email,
            "phonenumber": model.phonenumber,
            "userName":model.userName]
        
        let userInfo:SignUpInfo = try await execute(endpoint: API.signUp(param: param), isFullPath: true, logLevel: .debug)
        return userInfo
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
