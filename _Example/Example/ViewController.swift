//
//  ViewController.swift
//  Example
//
//  Created by Dillon Nys on 2/5/21.
//

import UIKit
import AuthenticationServices
import FTAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    private let viewModel = LoginViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.initialize()
        setupAppleLoginView()
    }
    
    func setupAppleLoginView() {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
            self.loginProviderStackView.addArrangedSubview(authorizationButton)
        }
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        viewModel.signInWithApple { (user, error) in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            
            print("Signed in with user: \(user!)")
        }
    }

    @IBAction func login(_ sender: UIButton) {
        viewModel.login() { (user: User?, error: Error?) in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                return
            }
            
            print("Logged in with user: \(user!)")
        }
    }
    
}

