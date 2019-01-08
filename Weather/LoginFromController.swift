//
//  LoginFromController.swift
//  Weather
//
//  Created by Karim Razhanov on 25/04/2018.
//  Copyright © 2018 Karim Razhanov. All rights reserved.
//

import UIKit
import WebKit

class LoginFromController: UIViewController {
    var myFriends = [MyFriend]()
    @IBOutlet weak var webview: WKWebView! {
        didSet{
            webview.navigationDelegate = self
        }
    }

    //
//    @IBOutlet weak var loginInput: UITextField!
//    @IBOutlet weak var passwordInput: UITextField!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBAction func DidTapButton(_ sender: UIButton) {
//
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vkScope = 2 + 4 + 8192 + 262144 + 4096
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6471210"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: String(vkScope)), //262150
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.74")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        webview.load(request)
        
       
        
//        let vkService = VKService()
//        vkService.getFriend()
        
//        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        scrollView.addGestureRecognizer(hideKeyboardGesture)

        // Do any additional setup after loading the view.
    }
    
    
    
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        
//        let checkResult = checkUserData()
//        
//        if !checkResult {
//            showLoginError()
//        }
//        
//        return checkResult
//    }
//    
//    func checkUserData() -> Bool {
//        let login = loginInput.text!
//        let password = passwordInput.text!
//        if login == "Admin" && password == "123456" {
//            return true
//        } else {
//            return false
//        }
//    }
    
//    func showLoginError() {
//        let alert = UIAlertController(title: "Ошибка", message: "Неверные логин или пароль", preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
//    @objc func hideKeyboard() {
//        self.scrollView.endEditing(true)
//    }
    
//    @objc func keyboardWillShow(notification: Notification) {
//        let info = notification.userInfo! as NSDictionary
//        let keyboardSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
//        let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
//
//    }
//    @objc func keyboardWillBeHidden(notification: Notification) {
//        let contentInsets = UIEdgeInsets.zero
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
public var token: String?
public var userId: String?

extension LoginFromController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        token = params["access_token"]
        userId = params["user_id"]
        performSegue(withIdentifier: "loginSegue", sender: self)
        print("user_id = \(userId!)")
        print("token = \(token!)")
        
        

        decisionHandler(.cancel)
    }
}




