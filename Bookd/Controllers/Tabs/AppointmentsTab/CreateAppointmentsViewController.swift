//
//  CreateAppointmentsViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-10.
//

import UIKit
import FirebaseAuth

class CreateAppointmentsViewController: UIViewController {

    @IBOutlet weak var contactNameInput: UITextField!
    @IBOutlet weak var contactEmailInput: UITextField!
    @IBOutlet weak var aboutServiceInput: UITextField!
    @IBOutlet weak var notesInput: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func scheduleButtonPressed(_ sender: Any) {
        
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, hh:mm"
        let scheduledTime = dateFormatter.string(from: date)
        
        print(scheduledTime)

        // validation
        guard let contactName = contactNameInput.text,
              let contactEmail = contactEmailInput.text,
              let aboutService = aboutServiceInput.text,
              let notes = notesInput.text,
              !contactName.isEmpty,
              !contactEmail.isEmpty,
              !aboutService.isEmpty,
              !notes.isEmpty else {
            print("Incomplete Information")
            return;
        }
        
        
        // fetching user
        let user = FirebaseAuth.Auth.auth().currentUser;
        print("Outside: Creating appointment for \(user?.uid ?? "Couldn't retreive UID")")
        
        // submit to firebase
        DatabaseManager.shared.insertAppointment(uid: user!.uid, appointment: Appointment(appointmentID: "", contactName: contactName, contactEmail: contactEmail, scheduledTime: scheduledTime, service: aboutService, notes: notes, appointmentSchedule: "Scheduled"))
        
        
        // show alert
        print("Appointment Created Successfully")
        
        // dismiss view controller
        self.dismiss(animated: true)
    }
}
