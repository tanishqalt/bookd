//
//  WithdrawMoneyViewController.swift
//  Bookd
//
//  Created by TM Humber Group on 2022-08-11.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class WithdrawMoneyViewController: UIViewController {

    @IBOutlet weak var editInfoButton: UIBarButtonItem!
    @IBOutlet weak var withdrawButton: UIBarButtonItem!
    
    
    @IBOutlet weak var emailDisplayLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // load data
        loadUserData()
    }
    
    
    @IBAction func withdrawButtonPressed(_ sender: Any) {
        
        // get the currentuser
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // retrieve the uid
        let uid = currentUser!.uid;
        
        // update the database so that the "currentBalance" becomes -
        DatabaseManager.shared.updateUserBalance(uid: uid, balance: "0")
        
        // show alert
        let alert = UIAlertController(title: "Success", message: "You have successfully withdrawn your money", preferredStyle: .alert)
        
        // reload UI / fetch data again
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.loadUserData()
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    public func loadUserData(){
        
        // get the currentuser
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // retrieve the uid
        let uid = currentUser?.uid;
        
        let dbRef = FirebaseDatabase.Database.database().reference().child("Users").child(uid!);
        
        dbRef.observe(.value) {
            (snapshot) in
            
            // get the currentBalance value
            let currentBalance = snapshot.childSnapshot(forPath: "currentBalance").value as? String ?? "0";

            // set the values to the textfields
            self.currentBalanceLabel.text = "$" + currentBalance;
            
            // set the values to the textfields
            self.emailDisplayLabel.text = snapshot.childSnapshot(forPath: "email").value as? String
        }
    }
}
