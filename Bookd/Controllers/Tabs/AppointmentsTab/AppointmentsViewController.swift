//
//  AppointmentsViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-10.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AppointmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // to store appointments
    var appointments = [Appointment]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // identifier for show appointment segue
    let segueIdentifier = "showAppointmentSegue"
    var selectedAppointmentID: String?;
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath)
        cell.textLabel?.text = appointments[indexPath.row].contactName
        return cell
    }
    
    // sets the selectedAppointmentID variable with the unique key of appointmentID and then performs the segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAppointmentID = appointments[indexPath.row].appointmentID
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
    
    // function to load the appointment database
    private func loadData(){
    
        // gets the current user
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // gets the uid
        let uid = currentUser?.uid;
        
        // sets the tabkey for the DB child reference
        let tabKey = "Appointments";
        
        // gets a database referenece
        let dbRef = FirebaseDatabase.Database.database().reference();
        
        // time to retrieve
        dbRef.child(tabKey).child(uid!).observe(.value) {
            (snapshot) in
            
            // cleans the appointments array to make sure it doesn't duplicate since it is observing continuously
            self.appointments.removeAll();
            
            // for each  children in the snapshot, it iterations, gets the child as DataSnapshot
            snapshot.children.forEach({ (child) in
                if let child = child as? DataSnapshot {
                    
                    // each value is an optional of struct Appointment, map it that way and add to array
                    let value = child.value as! NSDictionary
                    
                    // create a appointment using our model
                    let appointment = Appointment(appointmentID: value["appointmentID"] as! String, contactName: value["contactName"] as! String, contactEmail: value["contactEmail"] as! String, scheduledTime: value["scheduledTime"] as! String, service: value["service"] as! String, notes: value["notes"] as! String, appointmentSchedule: value["appointmentSchedule"] as? String)
                    
                    
                    // add it to the array
                    self.appointments.append(appointment)
                    
                    // reload data
                    self.tableView.reloadData();
                }
            })
        }
    }
    
    // prepares for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == segueIdentifier) {
            // do something later
            guard let showAppointmentVC = segue.destination as? ShowAppointmentViewController else { return }
            showAppointmentVC.appointmentID = self.selectedAppointmentID
        }
    }
}

