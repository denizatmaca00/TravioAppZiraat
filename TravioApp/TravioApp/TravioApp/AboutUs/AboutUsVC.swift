//
//  AboutUsVC.swift
//  TravioApp
//
//  Created by web3406 on 11/6/23.
//

import UIKit

class AboutUsVC: UIViewController, WKNavigationDelegate {
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
        lbl.text = "About Us"
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
        loadWebView()
        view.backgroundColor = UIColor(named: "backgroundColor")
        super.viewDidLoad()
        setupViews()
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
        if let url = URL(string: "https://api.iosclass.live/about") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let backgroundColorCode = "document.body.style.backgroundColor = '#FFFFFF';"
        webView.evaluateJavaScript(backgroundColorCode)

        let jsCode = """
            var style = document.createElement('style');
            style.innerHTML = 'body { font-family: "Poppins", sans-serif; padding-top: 24px; }';
            document.head.appendChild(style);
        """
        webView.evaluateJavaScript(jsCode)

        let h1Styles = """
            var h1Elements = document.querySelectorAll('h1');
            for (var i = 0; i < h1Elements.length; i++) {
                h1Elements[i].style.fontFamily = 'Poppins-Bold, sans-serif';
                h1Elements[i].style.fontSize = '28px';
                h1Elements[i].style.color = 'black';
            }
        """
        webView.evaluateJavaScript(h1Styles)

        let pStyles = """
            var pElements = document.querySelectorAll('p');
            for (var i = 0; i < pElements.length; i++) {
                pElements[i].style.fontFamily = 'Poppins-Regular, sans-serif';
                pElements[i].style.fontSize = '16px';
                pElements[i].style.color = 'black';
            }
        """
        webView.evaluateJavaScript(pStyles)
    }
}


#if DEBUG
import SwiftUI
import WebKit

@available(iOS 13, *)
struct AboutUsVC_Preview: PreviewProvider {
    static var previews: some View{
        
        AboutUsVC().showPreview().ignoresSafeArea(.all)
    }
}
#endif
