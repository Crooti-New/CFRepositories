//
//  ParameterEncoder.swift
//  iOSRepositories
//
//  Created by Cuong Le on 2/3/21.
//  Copyright © All rights reserved.
//
// swiftlint:disable conditional_returns_on_newline
import Foundation

typealias Parameters = [String: Any]

protocol JSONParameterEncoderProtocol {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

protocol ParameterEncoderProtocol {
    func encodePOST(urlRequest: inout URLRequest, with parameters: Parameters) throws
    func encodeGET(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

enum EncodingError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

enum ParameterEncoding {
    case urlEncodingPOST
    case urlEncodingPUT
    case urlEncodingGET
    case jsonEncoding
    case urlAndJsonEncoding
    
    func encode(urlRequest: inout URLRequest,
                bodyParameters: Parameters?,
                urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncodingPOST:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encodePOST(urlRequest: &urlRequest, with: urlParameters)
            case .urlEncodingGET:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encodeGET(urlRequest: &urlRequest, with: urlParameters)
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                      let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encodeGET(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            case .urlEncodingPUT:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encodePOST(urlRequest: &urlRequest, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
}

private struct URLParameterEncoder: ParameterEncoderProtocol {
    private func percentEscapeString(_ string: String) -> String {
      var characterSet = CharacterSet.alphanumerics
      characterSet.insert(charactersIn: "-._* ")
      
      return string
        .addingPercentEncoding(withAllowedCharacters: characterSet)!
        .replacingOccurrences(of: " ", with: "+")
        .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    func encodePOST(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw EncodingError.missingURL }
        
        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percentEscapeString(value as! String))"
        }
        urlRequest.httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
        
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
    
    func encodePUT(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw EncodingError.missingURL }
        
        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percentEscapeString(value as! String))"
        }
        urlRequest.httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
        urlRequest.httpMethod = "PUT"
        
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
    
    func encodeGET(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw EncodingError.missingURL }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                var value = "\(value)"
                let queryItem = URLQueryItem(name: key, value: value)
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

private struct JSONParameterEncoder: JSONParameterEncoderProtocol {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw EncodingError.encodingFailed
        }
    }
}
