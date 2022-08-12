//
//  NewViewController.swift
//  Bookd
//
//  Created by TM Humber Group on 2022-08-10.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewViewController: UIViewController {
    
    var conversationID: String?

    @IBOutlet weak var emailView: UILabel!
    @IBOutlet weak var invoiceNumberView: UILabel!
    @IBOutlet weak var subjectView: UILabel!
    @IBOutlet weak var messageView: UITextView!
    
    @IBOutlet weak var markReadButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Fetching data for \(conversationID ?? "")")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadConversation()
    }
    
    private func loadConversation(){
        
        // get the currentuser
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // retrieve the uid
        let uid = currentUser?.uid;
        
        let dbRef = FirebaseDatabase.Database.database().reference().child("Conversations").child(uid!).child(conversationID!);
        
        dbRef.observeSingleEvent(of: .value) {
            (snapshot) in
            
            // set the values to the textfields
            self.emailView.text = snapshot.childSnapshot(forPath: "email").value as? String
            self.invoiceNumberView.text = snapshot.childSnapshot(forPath: "invoiceNumber").value as? String
            self.messageView.text = snapshot.childSnapshot(forPath: "message").value as? String
            self.subjectView.text = snapshot.childSnapshot(forPath: "subject").value as? String
        }
        
    }
    
    @IBAction func markReadPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
