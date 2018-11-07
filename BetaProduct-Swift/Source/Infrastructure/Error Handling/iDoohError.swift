//
//  BetaProductError.swift
//  BetaProduct-Swift
//
//  Created by User on 11/10/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import CocoaLumberjack

/// enum for idooh error codes
public enum iDoohErrorCode : Int {
    case Database = 1000,
    WebService,
    Business,
    Other
}

/// class for idooh custom error
public class iDoohError: NSError {
    public var errorCode : iDoohErrorCode?
    public var innerError : Error?
    public var innerNSError : NSError?
    public var innerBPError : iDoohError?
    
    /**
     parameterized convenience init for iDoohError
     - Parameters:
         - domain: iDooh Error Domain
         - code: iDooh Error Code
         - description: error description
         - reason: error reason. Used mostly for display messages in views
         - suggestion: error suggestion
     */
    convenience init(domain : String, code : iDoohErrorCode, description : String, reason : String, suggestion : String) {
        let userInfo = [
            NSLocalizedDescriptionKey : description,
            NSLocalizedFailureReasonErrorKey : reason,
            NSLocalizedRecoverySuggestionErrorKey : suggestion
        ]
        self.init(domain: domain, code: code.rawValue, userInfo: userInfo)
    }
    
    static func genericError() -> iDoohError {
        return iDoohError.init(domain: iDooh.kErrorDomain, code: .Other, description: iDooh.kGenericErrorMessage, reason: iDooh.kGenericErrorMessage, suggestion: iDooh.kGenericErrorMessage)
    }
    
    static func logError(message: String) {
        DDLogError("Error description: \(message)")
    }
    
    static func logError(withDescription description: String?, withReason reason: String?, withSuggestion suggestion: String?) {
        DDLogError("Error description: \(description ?? "unknown") reason: \(reason ?? "unknown") suggestion: \(suggestion ?? "unknown")")
    }
    
    static func logError(withiDoohError error: iDoohError?) {
        DDLogError("Error description: \(error?.localizedDescription ?? "unknown") reason: \(error?.localizedFailureReason ?? "unknown") suggestion: \(error?.localizedRecoverySuggestion ?? "unknown")")
    }
}
