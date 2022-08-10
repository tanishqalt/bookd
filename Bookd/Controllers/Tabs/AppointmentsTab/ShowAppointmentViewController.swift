//
//  ShowAppointmentViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-10.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ShowAppointmentViewController: UIViewController {
    
    var appointmentID: String?

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var scheduledTime: UILabel!
    @IBOutlet weak var service: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Fetching data for \(appointmentID ?? "")")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAppointment()
    }
    
    private func loadAppointment(){
        
        // get the currentuser
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // retrieve the uid
        let uid = currentUser?.uid;
        
        let dbRef = FirebaseDatabase.Database.database().reference().child("Appointments").child(uid!).child(appointmentID!);
        
        dbRef.observeSingleEvent(of: .value) {
            (snapshot) in
            
            // set the values to the textfields
            self.name.text = snapshot.childSnapshot(forPath: "contactName").value as? String
            self.email.text = snapshot.childSnapshot(forPath: "contactEmail").value as? String
            self.scheduledTime.text = snapshot.childSnapshot(forPath: "scheduledTime").value as? String
            self.service.text = snapshot.childSnapshot(forPath: "service").value as? String
            self.notes.text = snapshot.childSnapshot(forPath: "notes").value as? String
        }
        
    }
    
}
