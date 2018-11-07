//
//  StoreWebClientProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 11/8/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// Store Web Clent Protocol. Abstract interface for Webservice used by the app
protocol StoreWebClientProtocol {
    /**
     function for url request with HTTP Method GET
     - Paramaters:
         - url: url target.
         - parameters: parameters for url request combined with the url target
         - block: callback closure. see `CompletionBlockTypes.swift`
     */
    func GET(_ url : String, parameters : [String : Any]?, block : @escaping CompletionBlock<[Any]>)
    
    /**
     function for url request with HTTP Method PUT
     - Paramaters:
         - url: url target.
         - parameters: parameters for url request combined with the url target
         - block: callback closure. see `CompletionBlockTypes.swift`
     */
    func PUT(_ url : String, parameters : [String : Any]?, block : @escaping CompletionBlock<[Any]>)
    
    /**
     function for url request with HTTP Method POST
     - Paramaters:
         - url: url target.
         - parameters: parameters for url request combined with the url target
         - block: callback closure. see `CompletionBlockTypes.swift`
     */
    func POST(_ url : String, parameters : [String : Any]?, block : @escaping CompletionBlock<[Any]>)
    
    /**
     function for url request with HTTP Method DELETE
     - Paramaters:
         - url: url target.
         - parameters: parameters for url request combined with the url target
         - block: callback closure. see `CompletionBlockTypes.swift`
     */
    func DELETE(_ url : String, parameters : [String : Any]?, block : @escaping CompletionBlock<[Any]>)
    
    /**
     function for url request with HTTP Method PATCH
     - Paramaters:
         - url: url target.
         - parameters: parameters for url request combined with the url target
         - block: callback closure. see `CompletionBlockTypes.swift`
     */
    func PATCH(_ url: String, parameters: [String : Any]?, block: @escaping CompletionBlock<[Any]>)
    
    /**
     function for uploading image file
     - Parameters:
         - data: image converted to Data
         - url: target url
         - block: completion closure for handling responses
     */
    func UploadImage(asData data: Data, toURL url: String, WithCompletionBlock block: @escaping CompletionBlock<[Any]>)
}
