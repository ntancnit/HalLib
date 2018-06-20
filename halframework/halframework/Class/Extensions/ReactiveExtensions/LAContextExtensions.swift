//
//  LAContextExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 2/9/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import Foundation
import RxSwift
import LocalAuthentication

extension LAContext {
    
    func evaluatePolicyObs(_ policy: LAPolicy, localizedReason reason: String) -> Observable<(success: Bool, error: Error?)> {
        return Observable.create { o in
            self.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login Application") { (success, error) in
                o.onNext((success: success, error: error))
            }
            
            return Disposables.create { }
        }
    }
    
}

