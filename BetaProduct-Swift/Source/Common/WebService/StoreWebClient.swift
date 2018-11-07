//
//  StoreWebClient.swift
//  BetaProduct-Swift
//
//  Created by User on 11/8/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import Alamofire
import CocoaLumberjack

/// class implementation for StoreWebClientProtocol. see `StoreWebClientProtocol.swift`
class StoreWebClient: StoreWebClientProtocol {
    var session: Session?
    private var completionBlock: CompletionBlock<[Any]>?
    
    // MARK: StoreWebClientProtocol
    /// Protocol implementation. see `StoreWebClientProtocol.swift`
    func GET(_ url: String, parameters: [String : Any]?, block: @escaping CompletionBlock<[Any]>) {
        completionBlock = block
        callWS(url, method: .get, parameters: parameters, token: session?.getToken())
    }
    
    /// Protocol implementation. see `StoreWebClientProtocol.swift`
    func PUT(_ url: String, parameters: [String : Any]?, block: @escaping CompletionBlock<[Any]>) {
        completionBlock = block
        callWS(url, method: .put, parameters: parameters, token: session?.getToken())
    }
    
    /// Protocol implementation. see `StoreWebClientProtocol.swift` 
    func POST(_ url: String, parameters: [String : Any]?, block: @escaping CompletionBlock<[Any]>) {
        completionBlock = block
        callWS(url, method: .post, parameters: parameters, token: session?.getToken())
    }
    
    /// Protocol implementation. see `StoreWebClientProtocol.swift`
    func DELETE(_ url: String, parameters: [String : Any]?, block: @escaping CompletionBlock<[Any]>) {
        completionBlock = block
        callWS(url, method: .delete, parameters: parameters, token: session?.getToken())
    }
    
    /// Protocol implementation. see `StoreWebClientProtocol.swift`
    func PATCH(_ url: String, parameters: [String : Any]?, block: @escaping CompletionBlock<[Any]>) {
        completionBlock = block
        callWS(url, method: .patch, parameters: parameters, token: session?.getToken())
    }
    
    /// Protocol implementation. see `StoreWebClientProtocol.swift`
    func UploadImage(asData data: Data, toURL url: String, WithCompletionBlock block: @escaping CompletionBlock<[Any]>) {
        completionBlock = block
        print("CALL URL: \(url)")
        Alamofire.upload(data, to: url).responseJSON { response in
            if let rawdata = response.data, let processeddata = String(data: rawdata, encoding: .utf8) {
                print(processeddata)
            }
            self.handleResponse(response)
        }
    }
    
    // MARK: Privates
    
    /**
     calls webservice via Alamofire
     - Parameters:
         - url: url target
         - method: HTTP Method
         - parameters: Parameters attached, in Dictionary format [String: Any]
         - block: completion closure. Follows Response Class
     */
    private func callWS(_ url: String, method: HTTPMethod, parameters: [String : Any]?, token: String?) {
        var headers: HTTPHeaders? = nil
        if let nonNilToken = token {
            headers = ["Authorization" : "Bearer " + nonNilToken, "Content-Type" : "application/json"]
        }
        print("CALL URL: \(url) with parameters: \(String(describing: parameters))")
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
            // Check if there is a token and has expired
            if response.response?.statusCode == 401 && token != nil {
                self.requestForNewTokenAndRetry(url, method: method, parameters: parameters, token: token, headers: headers)
            } else {
                self.handleResponse(response)
            }
        }
    }
    
    /**
     generates new token and retries previously failed request
     - Parameters:
         - url: url request
         - method: http method
         - parameters: parameters to be passed in request in JSON
         - token: previous token used for auth
         - headers: http headers
     */
    private func requestForNewTokenAndRetry(_ url: String, method: HTTPMethod, parameters: [String : Any]?, token: String?, headers: HTTPHeaders?) {
        Alamofire.request(iDooh.kWSSessions(), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                var data: [String: Any]? = nil
                if let array = value as? [Any] {
                    if let dictionary = array.first as? [String: Any] {
                        data = dictionary
                    }
                } else if let dictionary = value as? [String: Any] {
                    data = dictionary
                }
                
                if let nonNilData = data {
                    let token = Token.init(dictionary: nonNilData)
                    self.session?.setToken(token)
                    let newHeaders: HTTPHeaders = ["Authorization" : "Bearer " + token.accessToken, "Content-Type" : "application/json"]
                    Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: newHeaders)
                        .validate(statusCode: 200 ..< 300)
                        .validate(contentType: ["application/json"])
                        .responseJSON { response in
                        self.handleResponse(response)
                    }
                } else {
                    let error = iDoohError.init(domain: iDooh.kErrorDomain,
                                             code: .WebService,
                                             description: "Unable to retrieve tokens",
                                             reason: iDooh.kGenericErrorMessage,
                                             suggestion: "Debug function \(#function)")
                    self.completionBlock?(.failure(error))
                }
                
            case .failure(let error):
                let caughtError = iDoohError.init(domain: iDooh.kErrorDomain,
                                               code: .WebService,
                                               description: error.localizedDescription,
                                               reason: iDooh.kGenericErrorMessage,
                                               suggestion: "Debug function \(#function)")
                caughtError.innerError = error
                DDLogError("Error  description : \(caughtError.localizedDescription) reason : \(caughtError.localizedFailureReason ?? "Unknown Reason") suggestion : \(caughtError.localizedRecoverySuggestion ?? "Unknown Suggestion")")
                self.completionBlock?(.failure(caughtError))
            }
        }
    }
    
    /**
     handle responses received from Alamofire requests and binds them completion blocks
     - Parameters:
        - response: response input from Alamofire's construct
     */
    private func handleResponse(_ response: (DataResponse<Any>)) {
        print(String(data: response.data!, encoding: .utf8)!)
        switch response.result {
        case .success(let value):
            var data: [Any]? = nil
            var error: iDoohError? = nil
            if let result = value as? [Any] {
                data = result
            } else if let result = value as? [String: Any] {
                data = [result]
            } else if let result = value as? String {
                data = [["value" : result]]
            } else {
                error = iDoohError.init(domain: iDooh.kErrorDomain,
                                     code: .WebService,
                                     description: iDooh.kGenericErrorMessage,
                                     reason: "Was Unable to parse data. Invalid Format",
                                     suggestion: "Debug function \(#function)")
            }
            if let nonNilError = error {
                completionBlock?(.failure(nonNilError))
            } else {
                completionBlock?(.success(data))
            }
        case .failure(let error):
            let caughtError = iDoohError.init(domain: iDooh.kErrorDomain,
                                           code: .WebService,
                                           description: error.localizedDescription,
                                           reason: iDooh.kGenericErrorMessage,
                                           suggestion: "Debug function \(#function)")
            caughtError.innerError = error
            DDLogError("Error  description : \(caughtError.localizedDescription) reason : \(caughtError.localizedFailureReason ?? "Unknown Reason") suggestion : \(caughtError.localizedRecoverySuggestion ?? "Unknown Suggestion")")
            completionBlock?(.failure(caughtError))
        }
    }
}
