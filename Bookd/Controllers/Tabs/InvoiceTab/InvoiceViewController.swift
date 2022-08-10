//
//  InvoiceViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-10.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class InvoiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // to store appointments
    var invoices = [Invoice]()

    @IBOutlet weak var tableView: UITableView!
    
    // identifier for show appointment segue
    let segueIdentifier = "showInvoiceSegue"
    var selectedInvoiceID: String?;
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell", for: indexPath)
        cell.textLabel?.text = invoices[indexPath.row].invoiceNumber
        return cell
    }
    
    // sets the selectedAppointmentID variable with the unique key of appointmentID and then performs the segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInvoiceID = invoices[indexPath.row].invoiceID
        performSegue(withIdentifier: segueIdentifier, sender: nil)
        return tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData();
    }
    
    // function to load the invoices database
    private func loadData(){
    
        // gets the current user
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // gets the uid
        let uid = currentUser?.uid;
        
        // sets the tabkey for the DB child reference
        let tabKey = "Invoices";
        
        // gets a database referenece
        let dbRef = FirebaseDatabase.Database.database().reference();
        
        // time to retrieve
        dbRef.child(tabKey).child(uid!).observe(.value) {
            (snapshot) in
            
            // cleans the invoices array to make sure it doesn't duplicate since it is observing continuously
            self.invoices.removeAll();
            
            // for each  children in the snapshot, it iterations, gets the child as DataSnapshot
            snapshot.children.forEach({ (child) in
                if let child = child as? DataSnapshot {
                    
                    // each value is an optional of struct Appointment, map it that way and add to array
                    let value = child.value as! NSDictionary
                    
                    // create a invoice using our model
                    let invoice = Invoice(
                        invoiceID: value["invoiceID"] as! String,
                        status: value["status"] as! String,
                        contactEmail: value["contactEmail"] as! String,
                        dateCompleted: value["dateCompleted"] as! String,
                        invoiceNumber: value["invoiceNumber"] as! String,
                        serviceDescription: value["serviceDescription"] as! String,
                        invoiceTotal: value["invoiceTotal"] as! String)
                    
                    // add it to the array
                    self.invoices.append(invoice)
                    
                    // reload data
                    self.tableView.reloadData();
                }
            })
        }
    }
    
}
