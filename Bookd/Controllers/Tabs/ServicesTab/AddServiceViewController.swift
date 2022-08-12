//
//  AddServiceViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-08.
//

import UIKit
import FirebaseAuth

class AddServiceViewController: UIViewController {

    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var minHoursInput: UITextField!
    @IBOutlet weak var hourlyRateInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        // check if all the textinputs are completed
        guard let title = titleInput.text, let category = categoryInput.text, let minHours = minHoursInput.text, let description = descriptionInput.text, let hourlyRate = hourlyRateInput.text, !title.isEmpty, !category.isEmpty, !minHours.isEmpty, !description.isEmpty, !hourlyRate.isEmpty else {
            print("Incomplete Fields"); // TODO: Show alert
            return;
        }
        
        // priting DEBUG
        let user = FirebaseAuth.Auth.auth().currentUser;
        print("Outside: Creating service for \(user?.uid ?? "Couldn't retreive UID")")
        
        // submit to firebase
        DatabaseManager.shared.insertService(uid: user!.uid, service: UserService(serviceID:"" ,title: title, description: description, hourlyRate: hourlyRate, minHours: minHours, category: category))
        
        // show alert
        print("Service Created Successfully")

        // Show Alert
        let alert = UIAlertController(title: "Service Created", message: "Service Created Successfully", preferredStyle: .alert)

        // add action and dismiss on ok
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))

        // present alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
