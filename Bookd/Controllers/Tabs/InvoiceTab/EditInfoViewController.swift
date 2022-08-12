//
//  EditInfoViewController.swift
//  Bookd
//
//  Created by TM Humber Group on 2022-08-11.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditInfoViewController: UIViewController {

    @IBOutlet weak var paypalEmailInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        guard let uid = currentUser?.uid else { return };
        
        // get user using DatabaseManager
        let _: () = DatabaseManager.shared.getUser(with: uid, completion:
            { (user) in
            self.paypalEmailInput.text = user.emailAddress;
        });

    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {

        // check if the email is valid and correct format using the isValidEmail function
        guard let email = paypalEmailInput.text, isValidEmail(testStr: email) else {
            print("Invalid Email"); // TODO: Show alert
            // show alert
            let alert = UIAlertController(title: "Invalid Email", message: "Please enter a valid email address", preferredStyle: .alert)

            // add action and dismiss on ok
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            // present alert
            self.present(alert, animated: true, completion: nil)

            return;
        }

        // update the user with the new email id
        let currentUser = FirebaseAuth.Auth.auth().currentUser;

        guard let uid = currentUser?.uid else { return };
        guard let email = paypalEmailInput.text else { return };

        let dbRef = Database.database().reference().child("Users").child(uid);

        // update the user with the new email id
        dbRef.updateChildValues(["email": email]);

        // show alert
        let alert = UIAlertController(title: "Email Updated", message: "Email Updated Successfully", preferredStyle: .alert)
                
        // add action and dismiss on ok
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))

        // present alert
        self.present(alert, animated: true, completion: nil)
    }

    // function to validate email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
