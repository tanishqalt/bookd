//
//  ConversationsViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-09.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ConversationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // to store conversations
    var conversations = [Conversation]()
    
    // identifier for edit segue
    let segueIdentifier = "showMessageSegue"
    var selectedConversationID: String?;
    
    // returns the services count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    // returns the cell after mapping the service title
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath)
        cell.textLabel?.text = conversations[indexPath.row].subject
        return cell
    }
    
    
    // sets the selectedConversationID variable with the unique key of conversation and then performs the segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedConversationID = conversations[indexPath.row].conversationID
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
            // do something later
            guard let newViewController = segue.destination as? NewViewController else { return }
            newViewController.conversationID = self.selectedConversationID
        }
    }
    
    // function to load the service database
    private func loadData(){
    
        // gets the current user
        let currentUser = FirebaseAuth.Auth.auth().currentUser;
        
        // gets the uid
        let uid = currentUser?.uid;
        
        // sets the tabkey for the DB child reference
        let tabKey = "Conversations";
        
        // gets a database referenece
        let dbRef = FirebaseDatabase.Database.database().reference();
        
        // time to retrieve
        dbRef.child(tabKey).child(uid!).observe(.value) {
            (snapshot) in
            
            // cleans the services array to make sure it doesn't duplicate since it is observing continuously
            self.conversations.removeAll();
            
            // for each  children in the snapshot, it iterations, gets the child as DataSnapshot
            snapshot.children.forEach({ (child) in
                if let child = child as? DataSnapshot {
                    
                    // each value is an optional of struct UserService, map it that way and add to array
                    let value = child.value as! NSDictionary
                    
                    // create a service using our model
                    let new_conversation = Conversation(conversationID: value["conversationID"] as! String, email: value["email"] as! String, subject: value["subject"] as! String, message: value["message"] as! String, invoiceNumber: value["invoiceNumber"] as! String)
                    
                    // add it to the array
                    self.conversations.append(new_conversation)
                    
                    // reload data
                    self.tableView.reloadData();
                }
            })
        }
        
    }

}
