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
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var appointmentID: String?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var scheduledTime: UILabel!
    @IBOutlet weak var service: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    @IBOutlet weak var appointmentStatusLabel: UILabel!
    
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
            
            // if the appointment status is cancelled, disable the cancel button
            if snapshot.childSnapshot(forPath: "status").value as? String == "Cancelled" {
                self.cancelButton.isEnabled = false
            }
            
            
            // if the appointment status is cancelled, set the appointmentStatusLabel background as red else set is to green with text "Scheduled"
            if snapshot.childSnapshot(forPath: "status").value as? String == "Cancelled" {
                self.appointmentStatusLabel.backgroundColor = UIColor.red
                self.appointmentStatusLabel.text = "Cancelled"
                // add insets to the text
                self.appointmentStatusLabel.textAlignment = .center
                self.appointmentStatusLabel.textColor = UIColor.white
                
            } else {
                // dark green background
                self.appointmentStatusLabel.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
                
                self.appointmentStatusLabel.textColor = UIColor.white
                self.appointmentStatusLabel.text = "Scheduled"
                
            }
            
            // increase letter spacing, set the text to semi-bold
            let attributedString = NSMutableAttributedString(string: self.appointmentStatusLabel.text!)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.5), range: NSRange(location: 0, length: self.appointmentStatusLabel.text!.count))
            
            self.appointmentStatusLabel.attributedText = attributedString
            
            // text weight to semibold
            self.appointmentStatusLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            
            // round the corners
            self.appointmentStatusLabel.layer.cornerRadius = 10
            self.appointmentStatusLabel.layer.masksToBounds = true
            
            
            // uppercase text
            self.appointmentStatusLabel.text = self.appointmentStatusLabel.text?.uppercased()
            
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        // get the currentuser
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // retrieve the uid
        let uid = currentUser?.uid;
        
        DatabaseManager.shared.updateAppointmentStatus(uid: uid!, appointmentID: appointmentID ?? "", status: "Cancelled")
        
        // alert and dismiss the view
        let alert = UIAlertController(title: "Appointment Cancelled", message: "Your appointment has been cancelled", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
