//
//  Global.swift
//  mvvm-scaffold
//
//  Created by Dao Duy Duong on 1/18/16.
//  Copyright © 2016 Nover. All rights reserved.
//

import Foundation
import UIKit

let scheduler = Scheduler.sharedScheduler
let dataManager = DataManager.sharedManager
let dependencyManager = DependencyManager.sharedManager

let isPad = UIDevice.current.userInterfaceIdiom == .pad

// MARK: - Global funcs

func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}

func showGlobalHUD(withTitle title: String? = "Loading...", forView view: UIView? = nil) {
    GlobalLoaderView.showWithTitle(title, forView: view)
}

func hideGlobalHUD(forView view: UIView? = nil) {
    GlobalLoaderView.hide(forView: view)
}

func showSuccessGlobalHUD(withTitle title: String? = "Success", forView view: UIView? = nil) {
    GlobalSuccessLoaderView.showWithTitle(title, dismissAfter: 1.0)
}

func hideSuccessGlobalHUD(forView view: UIView? = nil) {
    GlobalSuccessLoaderView.hide(forView: view)
}

// MARK: - App icons

struct Image {
    
    static func make(fromName imageNamed: String) -> UIImage? {
        return UIImage(named: imageNamed)
    }
    
    static func make(fromHex hex: String) -> UIImage {
        return UIImage.from(color: .hex(hex))
    }
    
    static let subscribeIcon = make(fromName: "icon_subscribed")
}

// MARK: - Enums

enum ComponentViewPosition {
    case top(CGFloat), left(CGFloat), bottom(CGFloat), right(CGFloat), center
}

enum ViewState {
    case none, willAppear, didAppear, willDisappear, didDisappear
}

enum ApplicationState {
    case resignActive, didEnterBackground, willEnterForeground, didBecomeActive, willTerminate, none
}

public enum TaskStatus : String {
    case notStart = "Not Started"
    case inProgess = "In Progress"
    case completed = "Completed"
}















