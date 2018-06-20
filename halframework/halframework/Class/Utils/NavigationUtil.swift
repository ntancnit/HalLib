//
//  NavigationUtil.swift
//  phimbo
//
//  Created by Dao Duy Duong on 7/27/17.
//  Copyright © 2017 Nover. All rights reserved.
//

import UIKit
import RxSwift

enum PushType {
    case auto, push, modally, popup(type: PopupType)
}

enum PopType {
    case auto, pop, dismiss
}

enum PopupType {
    case popup, picker
    
    var showDuration: Double {
        switch self {
        case .popup: return 0.7
        case .picker: return 0.4
        }
    }
    
    var dismissDuration: Double {
        switch self {
        case .popup: return 0.25
        case .picker: return 0.4
        }
    }
}

struct PopupOptions {
    let type: PopupType
    let hasCloseButton: Bool
}

// MARK: - Navigation cores

class NavigationUtil {
    
    fileprivate static var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    fileprivate static var rootPage: UIViewController? {
        get { return keyWindow?.rootViewController }
        set { keyWindow?.rootViewController = newValue }
    }
    
    fileprivate static var appRootPage: UIViewController? {
        return UIApplication.shared.windows
            .filter { $0.rootViewController is UINavigationController }
            .first?.rootViewController
    }
    
    static var topPage: UIViewController? {
        if let rootPage = appRootPage {
            var currPage: UIViewController? = rootPage.presentedViewController ?? rootPage
            while currPage?.presentedViewController != nil {
                currPage = currPage?.presentedViewController
            }
            
            while currPage is UINavigationController || currPage is UITabBarController {
                if currPage is UINavigationController {
                    currPage = (currPage as? UINavigationController)?.viewControllers.last
                }
                
                if currPage is UITabBarController {
                    currPage = (currPage as? UITabBarController)?.selectedViewController
                }
            }
            
            return currPage
        }
        
        return nil
    }
    
    fileprivate static func destroyPage(_ page: UIViewController?) {
        var viewControllers = [UIViewController]()
        if page is UINavigationController {
            viewControllers = (page as! UINavigationController).viewControllers
        }
        
        if page is UITabBarController {
            viewControllers = (page as! UITabBarController).viewControllers ?? []
        }
        
        viewControllers.forEach { destroyPage($0) }
        (page as? Destroyable)?.destroy()
    }
}

// MARK: - Main navigations

extension NavigationUtil {
    
    static func pop(usingType type: PopType = .auto, animated: Bool = true) {
        guard let topPage = topPage else { return }
        switch type {
        case .auto:
            if let navPage = topPage.navigationController {
                navPage.popViewController(animated: true) { poppedPage in
                    self.destroyPage(poppedPage)
                }
            } else {
                if let navPage = topPage.navigationController {
                    navPage.dismiss(animated: animated, completion: {
                        destroyPage(topPage)
                    })
                } else {
                    topPage.dismiss(animated: animated) {
                        destroyPage(topPage)
                    }
                }
            }
            
        case .pop:
            topPage.navigationController?.popViewController(animated: true) { poppedPage in
                self.destroyPage(poppedPage)
            }
            
        case .dismiss:
            if let navPage = topPage.navigationController {
                navPage.dismiss(animated: animated, completion: {
                    destroyPage(topPage)
                })
            } else {
                topPage.dismiss(animated: animated) {
                    destroyPage(topPage)
                }
            }
        }
    }
    
    static func push(toPage page: UIViewController, usingType type: PushType = .auto, animated: Bool = true) {
        guard let topPage = topPage else { return }
        switch type {
        case .auto:
            if let navPage = topPage.navigationController {
                navPage.pushViewController(page, animated: animated)
            } else {
                topPage.present(page, animated: animated, completion: nil)
            }
            
        case .push:
            topPage.navigationController?.pushViewController(page, animated: animated)
            
        case .modally:
            topPage.present(page, animated: animated, completion: nil)
            
        case .popup(let type):
            let popupPage = BasePopupPage(contentPage: page, popupType: type)
            popupPage.modalPresentationStyle = .overFullScreen
            topPage.present(popupPage, animated: false)
        }
    }
    
    static func push(withTransitioningDelegate transitioningDelegate: TransitioningDelegate, toPage page: UIViewController, asNavigationPage isNavPage: Bool = true) {
        if isNavPage {
            let navPage = UINavigationController(rootViewController: page)
            navPage.transitioningDelegate = transitioningDelegate
            navPage.modalPresentationStyle = .custom
            
            push(toPage: navPage, usingType: .modally)
        } else {
            page.transitioningDelegate = transitioningDelegate
            page.modalPresentationStyle = .custom
            push(toPage: page, usingType: .modally)
        }
    }
    
}

// MARK: - For keyboards

extension NavigationUtil {
    
    static func forceKeyboardToHide() {
        topPage?.view.endEditing(true)
    }
    
}

// MARK: - Specific navigations

extension NavigationUtil {
    
//    static func navigateToLoginPage() {
//        let oldPage = rootPage
//        rootPage = LoginPage(viewModel: LoginPageViewModel())
//        destroyPage(oldPage)
//    }
//    
//    static func navigateToSearchPage() {
//        let oldPage = rootPage
//        rootPage = UINavigationController(rootViewController: SearchPage(viewModel: SearchPageViewModel(model: nil)))
//        destroyPage(oldPage)
//    }
    
//    static func navigateToListPage(model : TaskItem? = nil) {
//        let oldPage = rootPage
//        let viewModel = ListItemViewModel(model: model)
//        viewModel.varIsNew.value = true
//        rootPage = UINavigationController(rootViewController:ListItemViewController(viewModel: viewModel))
//        destroyPage(oldPage)
//    }
    
}










