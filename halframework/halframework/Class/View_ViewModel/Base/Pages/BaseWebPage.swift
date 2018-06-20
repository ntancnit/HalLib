//
//  BaseWebPage.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 2/8/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

class BaseWebPage: BasePage<BaseWebPageViewModel> {

    var webView: WKWebView!
    
    override func initialize() {

        enableLogoutButton = true

        let configuration = WKWebViewConfiguration()
        if #available(iOS 10.0, *) {
            configuration.mediaTypesRequiringUserActionForPlayback = .all
        } else {
            configuration.requiresUserActionForMediaPlayback = true
        }
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        configuration.preferences = preferences
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .primaryBackgroundColor
        webView.isOpaque = false
        view.addSubview(webView)
        webView.autoPin(toTopLayoutOf: self)
        webView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    override func destroy() {
        super.destroy()
        
        webView.removeFromSuperview()
    }
    
    override func bindViewAndViewModel() {
        viewModel.varUrl ~> webView.rx.url => disposeBag
    }

}

class BaseWebPageViewModel: ViewModel<Model> {
    
    let varUrl = Variable<URL?>(nil)
    
}










