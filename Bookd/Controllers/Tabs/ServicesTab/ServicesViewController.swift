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
        cell.textLabel?.text = services[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    
    // function to load the service database
    
    private func loadData(){
        
        print(self.services)
        
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        let uid = currentUser?.uid;
        
        let tabKey = "Services";
        let dbRef = FirebaseDatabase.Database.database().reference();
        
        dbRef.child(tabKey).child(uid!).observe(.value) {
            (snapshot) in
            self.services.removeAll();
            snapshot.children.forEach({ (child) in
                if let child = child as? DataSnapshot {
                    
                    // each value is an optional of struct UserService, map it that way and add to array
                    let value = child.value as! NSDictionary
                    let service = UserService(title: value["title"] as! String, description: value["description"] as! String, hourlyRate: value["hourlyRate"] as! String, minHours: value["minHours"] as! String, category: value["category"] as! String)
                    self.services.append(service)
                    self.tableView.reloadData();
                }
            })
        }
        
    }
}
