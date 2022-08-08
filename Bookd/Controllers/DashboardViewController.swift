//
//  DashboardViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-07.
//

import UIKit
import FirebaseAuth

class DashboardViewController: UIViewController {

    @IBOutlet weak var WelcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.WelcomeLabel.text = "Welcome"
    }
    
    @IBAction func invoiceButtonPressed(_ sender: Any) {
        goToTab(index: 0)
    }
    
    @IBAction func appointmentButtonPressed(_ sender: Any) {
        goToTab(index: 1)
    }
    
    @IBAction func conversationButtonPressed(_ sender: Any) {
        goToTab(index: 2)
    }
    
    @IBAction func serviceButtonPressed(_ sender: Any) {
        goToTab(index: 3)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        goToTab(index: 4)
    }
    
    
    private func goToTab(index: Int){
        let tabVC = self.storyboard!.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        tabVC.selectedIndex = index
        tabVC.modalPresentationStyle = .fullScreen
        self.present(tabVC, animated: true)
    }
}
