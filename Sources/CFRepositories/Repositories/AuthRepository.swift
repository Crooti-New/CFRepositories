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
    func signIn(email: String, password: String) async throws
    func refreshToken() async throws
    func getUserInfo() async throws -> User
    func syncDeviceInfo() async throws -> Bool
    func signUp(model: SignUpModel) async throws -> SignUpInfo
    func forgotPassword(email: String) async throws -> ForgotPWInfo
    func changeUserName(userName: String) async throws -> ChangeUsernameInfo
    func changePasswod(currentPassword: String, newPassword: String, confirmPassword: String) async throws -> ChangePasswordInfo
}

struct AuthRepositoryImpl {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_auth_queue") // , attributes: .concurrent
    var interceptor: RequestInterceptor?
    
    @Injected var appState: AppStore<AppState>
    
    init(configuration: ServiceConfiguration) {
        self.session = configuration.urlSession
        self.baseURL = configuration.environment.url
        self.interceptor = configuration.interceptor
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
    func signIn(email: String, password: String) async throws {
        let param: Parameters = [
            Constants.IdentityClientIdHeader: Constants.IdentityClientIdValue,
            Constants.IdentityClientSecretHeader: Constants.IdentityClientSecretValue,
            Constants.IdentityGrantTypeHeader: Constants.IdentityGrantTypeValue,
            Constants.IdentityScopeHeader: Constants.IdentityScopeValue,
            "username": email, "password": password]
        
        let tokenInfo:TokenInfo = try await execute(endpoint: API.signIn(param: param), isFullPath: true, logLevel: .debug)
        UserDefaultHandler.userTokenInfo = tokenInfo
    }
    
    func refreshToken() async throws {
        let param: Parameters = [
            Constants.IdentityClientIdHeader: Constants.IdentityClientIdValue,
            Constants.IdentityClientSecretHeader: Constants.IdentityClientSecretValue,
            Constants.IdentityGrantTypeHeader: Constants.IdentityGrantTypeRefreshValue,
            Constants.IdentityScopeHeader: Constants.IdentityScopeValue,
            Constants.IdentityRefreshHeader: UserDefaultHandler.userTokenInfo?.refresh_token ?? ""]
        
        let tokenInfo:TokenInfo = try await execute(endpoint: API.signIn(param: param), isFullPath: true, logLevel: .debug)
        UserDefaultHandler.userTokenInfo = tokenInfo
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
    
    func forgotPassword(email: String) async throws -> ForgotPWInfo {
        let param: Parameters = [
            Constants.IdentityClientIdHeader: Constants.IdentityClientIdValue,
            Constants.IdentityClientSecretHeader: Constants.IdentityClientSecretValue,
            Constants.IdentityGrantTypeHeader: Constants.IdentityGrantTypeValue,
            Constants.IdentityScopeHeader: Constants.IdentityScopeValue,
            "email": email]
        
        let forgotPWInfo: ForgotPWInfo = try await execute(endpoint: API.forgotPassword(param: param), logLevel: .debug)
        if forgotPWInfo.meta?.code == 200 {
            return forgotPWInfo
        } else {
            throw NSError(domain: forgotPWInfo.meta?.errorType ?? "", code: forgotPWInfo.meta?.code ?? 400, userInfo: [NSLocalizedDescriptionKey: forgotPWInfo.meta?.errorMessage ?? ""])
        }
        
    }
    
    func changePasswod(currentPassword: String, newPassword: String, confirmPassword: String) async throws -> ChangePasswordInfo {
        let param: Parameters = [
            Constants.IdentityClientIdHeader: Constants.IdentityClientIdValue,
            Constants.IdentityClientSecretHeader: Constants.IdentityClientSecretValue,
            Constants.IdentityGrantTypeHeader: Constants.IdentityGrantTypeValue,
            Constants.IdentityScopeHeader: Constants.IdentityScopeValue,
            "oldPassword": currentPassword,
            "newPassword": newPassword,
            "confirmNewPassword": confirmPassword]
        
        let info: ChangePasswordInfo = try await execute(endpoint: API.changePassword(param: param), logLevel: .debug)
        if info.meta?.code == 200 {
            return info
        } else {
            throw NSError(domain: info.meta?.errorType ?? "", code: info.meta?.code ?? 400, userInfo: [NSLocalizedDescriptionKey: info.meta?.errorMessage ?? ""])
        }
    }
    
    func changeUserName(userName: String) async throws -> ChangeUsernameInfo {
        let info: ChangeUsernameInfo = try await execute(endpoint: API.changeUserName(value: userName), logLevel: .debug)
    
        if info.meta?.code == 200 {
            return info
        } else {
            throw NSError(domain: info.meta?.errorType ?? "", code: info.meta?.code ?? 400, userInfo: [NSLocalizedDescriptionKey: info.meta?.errorMessage ?? ""])
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
             syncDeviceInfo(param: Parameters),
             changeUserName(value: String),
             changePassword(param: Parameters)
        
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
            case .changeUserName(let value):
                return .post(path: "/account/submitUsername/\(value)")
            case .changePassword:
                return .post(path: "/account/changePassword")
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .signUp(let param), .forgotPassword(let param), .syncDeviceInfo(let param) :
                return .requestParameters(bodyParameters: param, encoding: .jsonEncoding)
            case .signIn(let param), .changePassword(let param):
                return .requestParameters(encoding: .urlEncodingPOST, urlParameters: param)
            case .getUserInfo:
                return .requestParameters(encoding: .urlEncodingGET, urlParameters: nil)
            case .changeUserName:
                return .requestParameters(encoding: .urlEncodingPOST, urlParameters: nil)
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
