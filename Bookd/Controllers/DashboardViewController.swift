//
//  DashboardViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-07.
//

import UIKit
import FirebaseAuth

class DashboardViewController: UIViewController {

    @IBOutlet weak var WelcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // check if you can get the any user detail from current user object
        if(FirebaseAuth.Auth.auth().currentUser != nil) {
            let user = FirebaseAuth.Auth.auth().currentUser
            print(user?.uid) // use UID to store any details in firebase
        }
        
        self.WelcomeLabel.text = "Welcome"
    }
}
