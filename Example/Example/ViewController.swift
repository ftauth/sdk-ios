//
//  ViewController.swift
//  Example
//
//  Created by Dillon Nys on 2/5/21.
//

import UIKit
import FTAuth

class ViewController: UIViewController {
    
    private let client = FTAuthClient.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try client.initialize()
        } catch {
            print("Error initializing FTAuth: \(error.localizedDescription)")
        }
    }

    @IBAction func login(_ sender: UIButton) {
        client.login { (user: User?, error: Error?) in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                return
            }
            
            print("Logged in with user: \(user!)")
        }
    }
    
}

