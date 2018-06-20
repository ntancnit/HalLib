//
//  AlertController.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 3/2/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import UIKit
import RxSwift

class AlertView: UIAlertController {
    
    private var alertWindow: UIWindow? = nil
    
    fileprivate func show() {
        let blankViewController = UIViewController()
        blankViewController.view.backgroundColor = .clear
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = blankViewController
        window.backgroundColor = .clear
        window.windowLevel = UIWindowLevelAlert + 1
        window.makeKeyAndVisible()
        alertWindow = window
        
        blankViewController.present(self, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // we only remove window when user clicked on button
        alertWindow?.isHidden = true
        alertWindow = nil
    }

}

// MARK: - Alert utilities

extension AlertView {
    
    static func presentOkayAlert(withTitle title: String? = "OK", message: String? = nil) {
        let alertView = AlertView(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel)
        
        alertView.addAction(okayAction)
        
        alertView.show()
    }
    
    static func presentObservableOkayAlert(withTitle title: String?, message: String?) -> Observable<Void> {
        return Observable.create({ o in
            let alertView = AlertView(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                o.onNext(())
                o.onCompleted()
            }
            
            alertView.addAction(okayAction)
            
            alertView.show()
            
            return Disposables.create { }
        })
    }
    
    static func presentObservableConfirmAlert(withTitle title: String?, message: String?, yesText: String = "Yes", noText: String = "No") -> Observable<Bool> {
        return Observable.create { o in
            let alertView = AlertView(title: title, message: message, preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: yesText, style: .cancel) { _ in
                o.onNext(true)
                o.onCompleted()
            }
            let noAction = UIAlertAction(title: noText, style: .default) { _ in
                o.onNext(false)
                o.onCompleted()
            }
            
            alertView.addAction(yesAction)
            alertView.addAction(noAction)
            
            alertView.show()
            
            return Disposables.create { }
        }
    }
    
    static func presentObservaleActionSheet(withTitle title: String?, message: String?, actionTitles: [String] = ["Cancel"], cancelTitle: String = "Cancel") -> Observable<String> {
        return Observable.create { o in
            let alertView = AlertView(title: title, message: message, preferredStyle: .actionSheet)
            
            for title in actionTitles {
                let action = UIAlertAction(title: title, style: .default) { _ in
                    o.onNext(title)
                    o.onCompleted()
                }
                alertView.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                o.onNext(cancelTitle)
                o.onCompleted()
            }
            alertView.addAction(cancelAction)
            
            
            //MARK:_Check device is iPad
            if UIDevice.current.userInterfaceIdiom == .pad {
                let superView = UIApplication.shared.keyWindow
                alertView.popoverPresentationController?.sourceView = superView
                alertView.popoverPresentationController?.sourceRect = CGRect(x: (superView?.bounds.maxX)! * 0.86, y: (superView?.bounds.maxY)! * 0.86, width: 0, height: 0)
            }
            alertView.show()
            
            return Disposables.create { }
        }
    }
    
    static func presentOkayAlert(withError error: Error) {
        if let netError = error as? NetworkError {
            presentOkayAlert(withTitle: "Error", message: netError.message ?? "")
            return
        }
        
        let error = error as NSError
        var message = error.localizedDescription
        if error.code == 402 {
            return
        } else if error.code == -1003 || error.code == -1009 {
            message = "Please connect to Halliburton network."
        }
        presentOkayAlert(withTitle: "Error", message: message)
    }

}












