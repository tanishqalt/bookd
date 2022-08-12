//
//  SettingsViewController.swift
//  Bookd
//
//  Created by TM Humber Group on 2022-08-08.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut();
            
            // dismisses the parent of a parent for the same.
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
            
        } catch {
            print("Error")
        }
    }
}
