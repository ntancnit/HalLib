//
//  ObservableExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Observable where E == Int64 {
    
    static func countdown(_ seconds: Int64) -> Observable<Int64> {
        var secs = seconds
        return Observable.create { observer in
            return Observable<Int64>.interval(1, scheduler: scheduler.mainScheduler)
                .subscribe(onNext: { _ in
                    secs -= 1
                    observer.onNext(secs)
                    if secs <= 0 { observer.onCompleted() }
                })
        }
    }
    
}








