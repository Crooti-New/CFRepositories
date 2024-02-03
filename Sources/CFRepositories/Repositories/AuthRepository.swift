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
import UIKit

public protocol AuthRepository: WebRepository {
    func signIn(email: String, password: String) async throws -> TokenInfo
    func getUserInfo() async throws -> User
    func syncDeviceInfo() async throws -> Bool
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
    
    func getUserInfo() async throws -> User {
        let user: User = try await execute(endpoint: API.getUserInfo, logLevel: .debug)
        
        if user.meta?.code == 200 {
            UserDefaultHandler.userInfo = user
            return user
        } else {
            throw NSError(domain: user.meta?.errorType ?? "", code: user.meta?.code ?? 400, userInfo: [NSLocalizedDescriptionKey: user.meta?.errorMessage ?? ""])
        }
    }
    
    func syncDeviceInfo() async throws -> Bool {
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let osVersion = await UIDevice.current.systemVersion
        let manufacturer = await UIDevice.current.model
        let model = GeneralFunctions.getDeviceType()
        let token = UserDefaultHandler.pushDeviceToken
        
        
        let param: Parameters = [
            "appVersion": appVersionString,
            "osVersion": osVersion,
            "manufacturer": manufacturer,
            "modelNumber": model,
            "deviceToken": token ?? ""
        ]
        let result = try await execute(endpoint: API.syncDeviceInfo(param: param), logLevel: .debug)
        let json = try? JSON(data: result.data)
        if let meta: MetaData = MetaData.metaFromJson(json: json?["meta"]), meta.code == 200 {
            return true
        } else {
            return false
        }
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
        
        let signUpInfo:SignUpInfo = try await execute(endpoint: API.signUp(param: param), logLevel: .debug)
        
        if signUpInfo.meta?.code == 200 {
            return signUpInfo
        } else {
            throw NSError(domain: signUpInfo.meta?.errorType ?? "", code: signUpInfo.meta?.code ?? 400, userInfo: [NSLocalizedDescriptionKey: signUpInfo.meta?.errorMessage ?? ""])
        }
    }
}

// MARK: - Configuration
extension AuthRepositoryImpl {
    enum API: ResourceType {
        case signIn(param: Parameters),
             signUp(param: Parameters),
             forgotPassword(param: Parameters),
             getUserInfo,
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
            case .getUserInfo:
                return .requestParameters(encoding: .urlEncodingGET, urlParameters: nil)
            }
        }
        
        var headers: HTTPHeaders? {
            switch self {
            case .signUp(_), .signIn(_):
                return nil
            default: 
                return authHeader
            }
        }
    }
}

#endif
