//
//  ServicesViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-08.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ServicesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // identifier for edit segue
    let segueIdentifier = "editServiceSegue"
    var selectedServiceID: String?;
    
    @IBOutlet weak var tableView: UITableView!
    
    // to store services
    var services = [UserService]()
    
    // returns the services count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    // returns the cell after mapping the service title
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath)
        cell.textLabel?.text = services[indexPath.row].title + " ($" + services[indexPath.row].hourlyRate + " per hour)"
        return cell
    }
    
    // sets the selectedServiceID variable with the unique key of service and then performs the segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedServiceID = services[indexPath.row].serviceID
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
    
    // prepares for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == segueIdentifier) {
            guard let editServiceVC = segue.destination as? EditServiceViewController else { return }
            editServiceVC.serviceID = self.selectedServiceID
        }
    }
    
    
    // function to load the service database
    private func loadData(){
    
        // gets the current user
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // gets the uid
        let uid = currentUser?.uid;
        
        // sets the tabkey for the DB child reference
        let tabKey = "Services";
        
        // gets a database referenece
        let dbRef = FirebaseDatabase.Database.database().reference();
        
        // time to retrieve
        dbRef.child(tabKey).child(uid!).observe(.value) {
            (snapshot) in
            
            // cleans the services array to make sure it doesn't duplicate since it is observing continuously
            self.services.removeAll();
            
            // for each  children in the snapshot, it iterations, gets the child as DataSnapshot
            snapshot.children.forEach({ (child) in
                if let child = child as? DataSnapshot {
                    
                    // each value is an optional of struct UserService, map it that way and add to array
                    let value = child.value as! NSDictionary
                    
                    // create a service using our model
                    let service = UserService(serviceID: value["serviceID"] as! String, title: value["title"] as! String, description: value["description"] as! String, hourlyRate: value["hourlyRate"] as! String, minHours: value["minHours"] as! String, category: value["category"] as! String)
                    
                    // add it to the array
                    self.services.append(service)
                    
                    // reload data
                    self.tableView.reloadData();
                }
            })
        }
        
    }
}
