//
//  CreateInvoiceViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-10.
//

import UIKit
import FirebaseAuth

class CreateInvoiceViewController: UIViewController {

    @IBOutlet weak var invoiceNumberInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var serviceDescriptionInput: UITextField!
    @IBOutlet weak var invoiceTotalInput: UITextField!
    @IBOutlet weak var completionDateInput: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        let date = completionDateInput.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d"
        
        let completionDate = dateFormatter.string(from: date)
  
        
        guard let invoiceNumber = invoiceNumberInput.text,
              let email = emailInput.text,
              let serviceDescription = serviceDescriptionInput.text,
              let invoiceTotal = invoiceNumberInput.text,
              !invoiceNumber.isEmpty,
              !email.isEmpty,
              !serviceDescription.isEmpty,
              !invoiceTotal.isEmpty else {
            print("Incomplete Values");
            return;
        }
        
        // get the current user
        let user = FirebaseAuth.Auth.auth().currentUser;
        print("Outside: Creating invoice for \(user?.uid ?? "Couldn't retreive UID")")
        
        // database input
        DatabaseManager.shared.insertInvoice(uid: user!.uid, invoice: Invoice(invoiceID: "", status: "Unpaid", contactEmail: email, dateCompleted: completionDate, invoiceNumber: invoiceNumber, serviceDescription: serviceDescription, invoiceTotal: invoiceTotal))
        
        // show alert
        print("Invoice Created Successfully")
        
        // dismiss view controller
        self.dismiss(animated: true)
    }
}
