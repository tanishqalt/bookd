//
//  ShowInvoiceViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-11.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ShowInvoiceViewController: UIViewController {
    
    // the id for the firebase project
    var invoiceID: String?
    
    // alternate action for payment
    var alternateAction = "Paid"

    @IBOutlet weak var markPaidButton: UIBarButtonItem!
    @IBOutlet weak var sendReminderButton: UIBarButtonItem!
    
    // labels
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var completionLabel: UILabel!
    @IBOutlet weak var invoiceNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var invoiceTotalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Fetching data for \(invoiceID ?? "")")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadInvoice()
    }
    
    @IBAction func sendReminderPressed(_ sender: Any) {
        
        // get the currentuser
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // retrieve the uid
        let uid = currentUser!.uid;
        
        // Add to conversations
        DatabaseManager.shared.insertConversation(uid: uid, conversation: Conversation(conversationID: "", email: emailLabel.text!, subject: "Invoice #\(invoiceNumberLabel.text!) Reminder", message: "Hi! Requesting an update on Invoice# \(invoiceNumberLabel.text!) for the payment of CAD\(invoiceTotalLabel.text!)", invoiceNumber: invoiceNumberLabel.text!))
        
        // alert and dismiss
        self.tabBarController?.selectedIndex = 2
        self.dismiss(animated: true)
    }
    
    @IBAction func markPaidPressed(_ sender: Any) {
        // Update the invoice status as paid if its not already paid
        
        // get the currentuser
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // retrieve the uid
        let uid = currentUser?.uid;
        
        // update the invoice with the invoiceID
        let dbRef = FirebaseDatabase.Database.database().reference().child("Invoices").child(uid!).child(invoiceID!);
        
        // update the values
        dbRef.updateChildValues(["status": alternateAction])

        // Todo: add a success alert
        
        // go back to the previous view
        self.dismiss(animated: true)
        
        }
    
    private func loadInvoice(){
        
        // get the currentuser
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // retrieve the uid
        let uid = currentUser?.uid;
        
        let dbRef = FirebaseDatabase.Database.database().reference().child("Invoices").child(uid!).child(invoiceID!);
        
        dbRef.observeSingleEvent(of: .value) {
            (snapshot) in
            
            self.emailLabel.text = snapshot.childSnapshot(forPath: "contactEmail").value as? String
            
            self.statusLabel.text = "Status: \(String(describing: snapshot.childSnapshot(forPath: "status").value as! String))"
            
            self.completionLabel.text = snapshot.childSnapshot(forPath: "dateCompleted").value as? String
            
            self.invoiceNumberLabel.text = snapshot.childSnapshot(forPath: "invoiceNumber").value as? String
            
            self.descriptionLabel.text = snapshot.childSnapshot(forPath: "serviceDescription").value as? String
            
            self.invoiceTotalLabel.text = "$\(String(describing: snapshot.childSnapshot(forPath: "invoiceTotal").value as! String))"
            
            // check if the invoice is paid
            if snapshot.childSnapshot(forPath: "status").value as! String == "Paid"{
                self.sendReminderButton.isEnabled = false
                // set alternate action to paid
                self.alternateAction = "Paid"
            }

            // if the invoice is paid, show unpaid button and set the title of markPaid button to "Mark Unpaid"
            if snapshot.childSnapshot(forPath: "status").value as! String == "Paid"{
                self.markPaidButton.title = "Mark Unpaid"
                // set alternate action to unpaid
                self.alternateAction = "Unpaid"
            }

        }
        
    }
}
