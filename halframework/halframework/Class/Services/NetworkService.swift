//
//  Requester.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 10/7/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

class NetworkService {
    
    let reqManager: SessionManager
    
    private static var isHandlingSessionExpired = false
    
    private var tmpBag: DisposeBag!
    
    // MARK: - Init
    
    init() {
        let config = URLSessionConfiguration.default
        config.httpShouldSetCookies = true
        config.httpCookieAcceptPolicy = .always
        config.requestCachePolicy = .reloadRevalidatingCacheData
        config.timeoutIntervalForRequest = 25
        
        reqManager = Alamofire.SessionManager(configuration: config)
        reqManager.delegate.sessionDidReceiveChallengeWithCompletion = sessionDidReceiveChallengeWithCompletion
    }
    
    deinit { tmpBag = nil }
    
    func post(withAction soapAction: String? = nil, body: String? = nil, additionalHeaders: HTTPHeaders? = nil) -> Observable<String> {
        return Observable.create { observer in
            let headers = self.makeHeaders(soapAction, additionalHeaders: additionalHeaders)
            let request = self.reqManager.request(Api.endpoint, method: .post, parameters: nil, encoding: body ?? URLEncoding.default, headers: headers)
            
            request.responseString { response in
                print (response)
                if let error = response.result.error {
                    observer.onError(error)
                } else if let result = response.result.value {
                    observer.onNext(result)
                } else {
                    observer.onError(NSError.unknownError)
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create { request.cancel() }
            }
    }
    
   
    
    private func makeHeaders(_ soapAction: String?, additionalHeaders: HTTPHeaders?) -> HTTPHeaders {
        var headers = ["Content-Type": "text/xml; charset=utf-8"]
        if let soapAction = soapAction {
            headers["SOAPAction"] = soapAction
        }
        
        if let additionalHeaders = additionalHeaders {
            additionalHeaders.forEach { pair in
                headers.updateValue(pair.value, forKey: pair.key)
            }
        }
        
        return headers
    }
    
    private func sessionDidReceiveChallengeWithCompletion(_ session: URLSession, _ challenge: URLAuthenticationChallenge, _ completionHandler: ((URLSession.AuthChallengeDisposition, URLCredential?) -> Void)) {
        
        completionHandler(.performDefaultHandling, nil)
        
    }
}


