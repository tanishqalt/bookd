//
//  EditServiceViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-08.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class EditServiceViewController: UIViewController {
    
    // identifier for edit segue
    let editSegueIdentifier = "editServiceSegue"
    
    var serviceID: String?
    
    @IBOutlet weak var serviceTitle: UITextField!
    @IBOutlet weak var serviceCategory: UITextField!
    @IBOutlet weak var minHours: UITextField!
    @IBOutlet weak var hourlyRate: UITextField!
    @IBOutlet weak var serviceDescription: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Fetching data for \(serviceID ?? "")")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadService()
    }
    
    private func loadService(){
        
        // get the currentuser
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // retrieve the uid
        let uid = currentUser?.uid;
        
        let dbRef = FirebaseDatabase.Database.database().reference().child("Services").child(uid!).child(serviceID!);
        
        dbRef.observeSingleEvent(of: .value) {
            (snapshot) in
            
            // set the values to the textfields
            self.serviceTitle.text = snapshot.childSnapshot(forPath: "title").value as? String
            self.serviceCategory.text = snapshot.childSnapshot(forPath: "category").value as? String
            self.minHours.text = snapshot.childSnapshot(forPath: "minHours").value as? String
            self.hourlyRate.text = snapshot.childSnapshot(forPath: "hourlyRate").value as? String
            self.serviceDescription.text = snapshot.childSnapshot(forPath: "description").value as? String
        }
        
    }
    
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        // get the currentuser
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // retrieve the uid
        let uid = currentUser?.uid;
        
        // update the service with the serviceID
        let dbRef = FirebaseDatabase.Database.database().reference().child("Services").child(uid!).child(serviceID!);
        
        // update the values
        dbRef.updateChildValues(["title": serviceTitle.text!, "category": serviceCategory.text!, "minHours": minHours.text!, "hourlyRate": hourlyRate.text!, "description": serviceDescription.text!])
        
        // go back to the previous view
        self.dismiss(animated: true)
    }
    
}
