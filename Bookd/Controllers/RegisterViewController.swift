//
//  RegisterViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-07.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerButton(_ sender: Any) {
        print("Registering with Firebase")
        
        //guard statements to see if the things are empty
        guard let firstName = firstNameInput.text, let lastName = lastNameInput.text, let username = usernameInput.text, let email = emailInput.text, let password = passwordInput.text, !username.isEmpty, !password.isEmpty, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
                    alertUserRegisterError()
                    return
         }
             
        // Firebase Authentication Process
        FirebaseAuth.Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!, completion: {
            [weak self] authResult, error in
            
            guard let strongSelf = self else {
                return
            }
            
            guard let result = authResult, error == nil else {
                  print("Error creating user")
                 return
            }
            
            let user = result.user
            
            DatabaseManager.shared.insertUser(with: User(firstName: firstName, lastName: lastName, username: username, emailAddress: email, uid: user.uid))
            print("Created User: \(user)")
            strongSelf.dismiss(animated: true)
        })
    }
    
    // Alert the user for incomplete information
    func alertUserRegisterError(message: String = "Incomple information") {
        let alert = UIAlertController(title: "Whoops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}


