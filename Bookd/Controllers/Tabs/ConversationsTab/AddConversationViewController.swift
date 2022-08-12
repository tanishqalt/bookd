//
//  AddConversationViewController.swift
//  Bookd
//
//  Created by TM Humber Group on 2022-08-09.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddConversationViewController: UIViewController {
    
    @IBOutlet weak var invoiceNumberInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var subjectInput: UITextField!
    @IBOutlet weak var messageInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        let uid = currentUser?.uid
        
        // guard against empty inputs
        guard let invoiceNumber = invoiceNumberInput.text, let email = emailInput.text, let subject = subjectInput.text, let message = messageInput.text, !invoiceNumber.isEmpty, !email.isEmpty, !subject.isEmpty, !message.isEmpty else {
            // Todo: Show an alert
            return
        }
        
        let new_conversation = Conversation(conversationID: "", email: email, subject: subject, message: message, invoiceNumber: invoiceNumber);
        
        DatabaseManager.shared.insertConversation(uid: uid!, conversation: new_conversation)
        
        print("Conversation Created Successfully")
        // show alert

        let alert = UIAlertController(title: "Success", message: "Your message has been sent", preferredStyle: .alert)

        // add action to alert and dismiss

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))

        self.present(alert, animated: true)
    }
}
