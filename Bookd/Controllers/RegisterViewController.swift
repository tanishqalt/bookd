//
//  RegisterViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-07.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerButton(_ sender: Any) {
        print("Registering with Firebase")
        
        // guard statements to see if the things are empty
        
        // make sure the password prompt (>6 characters) is sent
        
        FirebaseAuth.Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!, completion: {
            authResult, error in
            print(authResult)
        })
    }
}
