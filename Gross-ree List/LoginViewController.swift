//
//  ViewController.swift
//  Gross-ree List
//
//  Created by Shawn Roller on 1/27/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signInOrUp() {
        // Attempt to first log the user in
        guard let password = passwordTextField.text, let email = emailTextField.text else {
            self.showAlert(title: "Attention", message: "Ensure the email and password have been entered.", buttonTitle: "OK")
            return
        }
        
        signIn(with: email, and: password) { (success) in
            guard success else {
                self.signUp(with: email, and: password, completion: { (successful) in
                    guard successful else {
                        self.showAlert(title: "Attention", message: "Bad username or password. Please try again.", buttonTitle: "OK")
                        return
                    }
                    self.performSegue(withIdentifier: Segue.LoginToListSegue, sender: nil)
                })
                return
            }
            self.performSegue(withIdentifier: Segue.LoginToListSegue, sender: nil)
        }
    }
    
    private func signUp(with email: String, and password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: { (user, error) in
            guard error == nil else { completion(false); return }
            completion(true)
        })
    }
    
    private func signIn(with email: String, and password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (user, error) in
            guard error == nil else { completion(false); return }
            completion(true)
        }
    }

}

