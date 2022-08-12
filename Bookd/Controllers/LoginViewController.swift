//
//  LoginViewController.swift
//  Bookd
//
//  Created by TM Humber Group on 2022-08-07.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // checking if the firebase auth is active or not
        if(FirebaseAuth.Auth.auth().currentUser != nil){
            print("User is already logged in");
            
            // if the user is already logged in, creating an instance for the dashboard vc and then presenting it
            redirectToDashboard()
        }
    }
    
    
    // Login functionality
    @IBAction func loginPressed(_ sender: Any) {
        print("Login Pressed")
        
        // attempt to sign in the user, clean it further
        FirebaseAuth.Auth.auth().signIn(withEmail: emailInput.text!, password: passwordInput.text!, completion: {
            authResult, error in
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(self.emailInput.text!)")
                return;
            }
            
            let user = result.user
            print("Logged in User: \(user)");
            self.redirectToDashboard()
        })
    }
    
    private func redirectToDashboard(){
        let dashboardVC = self.storyboard!.instantiateViewController(withIdentifier: "Dashboard");
        let nvc = UINavigationController(rootViewController: dashboardVC);
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true)
    }
}
