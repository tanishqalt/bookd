//
//  AddConversationViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-09.
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
        
        // show alert
        print("Conversation Created Successfully")
        
        // dismiss view controller
        self.dismiss(animated: true)
    }
}
