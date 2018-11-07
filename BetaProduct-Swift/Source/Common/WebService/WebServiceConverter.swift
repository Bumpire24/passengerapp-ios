//
//  WebServiceConverter.swift
//  BetaProduct-Swift
//
//  Created by User on 11/9/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import CocoaLumberjack

/// helper class for converting Dictionary structures returned by webservice to usable data types in the app
class WebServiceConverter {
    var dataDict = Dictionary<String, Any>()
    
    convenience init(_ dictionary : Dictionary<String, Any>) {
        self.init()
        dataDict = dictionary
    }
    
    /**
     logs error for not found keys
     - Parameters:
        - key: target key
     */
    private func logErrorKeyNotFound(_ key : String) {

        let error : iDoohError = iDoohError.init(domain: iDooh.kErrorDomain,
                                           code: .WebService,
                                           description: "Unable to convert data dictionary",
                                           reason: "\(key) does not exist in dictionary",
                                           suggestion: "debug function \(#function)")
        DDLogError("Error  description : \(error.localizedDescription) reason : \(error.localizedFailureReason ?? "Unknown Reason") suggestion : \(error.localizedRecoverySuggestion ?? "Unknown Suggestion")")
    }
    
    /**
     logs error for incorrect dataTypes
     - Parameters:
         - key: target key
         - value: Generic Type
     */
    private func logErrorKeyIsNotTheExpectedType<T>(_ key : String, value : T) {
        let error : iDoohError = iDoohError.init(domain: iDooh.kErrorDomain,
                                           code: .WebService,
                                           description: "Unable to convert data dictionary",
                                           reason: "\(key) does not follow correct Type \(String(describing: type(of: value)))",
                                           suggestion: "debug function \(#function)")
        DDLogError("Error  description : \(error.localizedDescription) reason : \(error.localizedFailureReason ?? "Unknown Reason") suggestion : \(error.localizedRecoverySuggestion ?? "Unknown Suggestion")")
    }
    
    private func serverDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
    
    /**
     finds key value for String Data Type
     - Parameters:
        - key: target key
     - Returns: String value
     */
    func stringWithKey(_ key : String) -> String {
        var value = ""
        if let nonNilData = dataDict[key] {
            if let x = nonNilData as? String {
                value = x
            } else {
                logErrorKeyIsNotTheExpectedType(key, value: value)
            }
        } else {
            logErrorKeyNotFound(key)
        }
        return value
    }
    
    // TODO: Date Format must be alligned with service's date format
    /**
     finds key value for Date Data Type
     - Parameters:
        - key: target key
     - Returns: Date value
     */
    func dateWithKey(_ key : String) -> Date {
        var value : Date = Date()
        let stringDate = stringWithKey(key)
        let testValue = serverDateFormatter().date(from: stringDate)
        if let testValue = testValue {
            value = testValue
        } else {
            logErrorKeyIsNotTheExpectedType(key, value: value)
        }
        return value
    }
    
    /**
     finds key value for Int16 Data Type
     - Parameters:
        - key: target key
     - Returns: Int16 value
     */
    func int16WithKey(_ key : String) -> Int16 {
        var value : Int16 = -1
        if let nonNilData = dataDict[key] {
            if let x = nonNilData as? Int16 {
                value = x
            } else {
                logErrorKeyIsNotTheExpectedType(key, value: value)
            }
        } else {
            logErrorKeyNotFound(key)
        }
        return value
    }
    
    /**
     finds key value for Int Data Type
     - Parameters:
        - key: target key
     - Returns: Int value
     */
    func intWithKey(_ key : String) -> Int {
        var value : Int = -1
        if let nonNilData = dataDict[key] {
            if let x = nonNilData as? Int {
                value = x
            } else {
                logErrorKeyIsNotTheExpectedType(key, value: value)
            }
        } else {
            logErrorKeyNotFound(key)
        }
        return value
    }
    
    /**
     finds key value for Double Data Type
     - Parameters:
        - key: target key
     - Returns: Double value
     */
    func doubleWithKey(_ key : String) -> Double {
        var value : Double = 0.00
        if let nonNilData = dataDict[key] {
            if let x = nonNilData as? Double {
                value = x
            } else {
                logErrorKeyIsNotTheExpectedType(key, value: value)
            }
        } else {
            logErrorKeyNotFound(key)
        }
        return value
    }
    
    /**
     finds key value for Decimal Data Type
     - Parameters:
        - key: target key
     - Returns: Decimal value
     */
    func decimalWithKey(_ key: String) -> Decimal {
        var value : Decimal = 0.00
        if let nonNilData = dataDict[key] {
            if let x = nonNilData as? Double {
                value = Decimal.init(x)
            } else {
                logErrorKeyIsNotTheExpectedType(key, value: value)
            }
        } else {
            logErrorKeyNotFound(key)
        }
        return value
    }
    
    /**
     finds key value for Float Data Type
     - Parameters:
        - key: target key
     - Returns: Float value
     */
    func floatWithKey(_ key: String) -> Float {
        var value : Float = 0.00
        if let nonNilData = dataDict[key] {
            if let x = nonNilData as? Float {
                value = x
            } else {
                logErrorKeyIsNotTheExpectedType(key, value: value)
            }
        } else {
            logErrorKeyNotFound(key)
        }
        return value
    }
}
