//
//  TermsOfUseVC.swift
//  TravioApp
//
//  Created by web3406 on 11/6/23.
//

import UIKit

class TermsOfUseVC: UIViewController, WKNavigationDelegate {
    private lazy var contentViewBig: AppView = {
        let view = AppView()
        return view
    }()
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Terms Of Use"
        lbl.textColor = .white
        lbl.font = .Fonts.pageHeader32.font
        return lbl
    }()
    private lazy var leftBarButton: UIButton = {
        let leftBarButton = UIButton()
        leftBarButton.tintColor = .white
        leftBarButton.setImage(UIImage(named: "leftArrow"), for: .normal)
         leftBarButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return leftBarButton
    }()
    override func viewDidLoad()
    {
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        super.viewDidLoad()
        setupViews()
        loadWebView()
        applyCustomStyles()
    }

    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubviews(contentViewBig, titleLabel, leftBarButton)
        contentViewBig.addSubviews(webView)
        setupLayout()
    }
    
    func setupLayout() {
        
        leftBarButton.snp.makeConstraints({ btn in
            btn.centerY.equalTo(titleLabel)
            btn.leading.equalToSuperview().offset(24)
            btn.height.width.equalTo(20)
        })
        titleLabel.snp.makeConstraints({ lbl in
            lbl.top.equalToSuperview().offset(60)
            lbl.leading.equalTo(leftBarButton.snp.trailing).offset(24)
        })
        contentViewBig.snp.makeConstraints ({ view in
            view.height.equalToSuperview().multipliedBy(0.8)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
            
        })
        webView.snp.makeConstraints ({ make in
            make.top.equalTo(contentViewBig)
            make.leading.equalTo(contentViewBig)
            make.trailing.equalTo(contentViewBig)
            make.bottom.equalTo(contentViewBig)
        })
    }
    func loadWebView() {
        if let url = URL(string: "https://api.iosclass.live/terms") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    func applyCustomStyles() {
        let script = """
        var style = document.createElement('style');
        style.innerHTML = 'p { font-family: "Poppins-Light", sans-serif !important; font-size: 8px !important; color: #333 !important; }';
        document.head.appendChild(style);
        """
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)

        webView.configuration.userContentController = userContentController
    }
}
#if DEBUG
import SwiftUI
import WebKit

@available(iOS 13, *)
struct TermsOfUseVC_Preview: PreviewProvider {
    static var previews: some View{
        
        TermsOfUseVC().showPreview().ignoresSafeArea(.all)
    }
}
#endif
