//
//  DashboardViewController.swift
//  Bookd
//
//  Created by TM Humber Group  on 2022-08-07.
//

import UIKit
import FirebaseAuth

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var WelcomeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // array for collection view with name, image
    var collectionViewData = [
        ["name": "Invoices", "image": "invoice"],
        ["name": "Appointments", "image": "appointment"],
        ["name": "Conversations", "image": "message"],
        ["name": "Services", "image": "service"],
        ["name": "Settings", "image": "settings"],
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.WelcomeLabel.text = "Welcome"
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        collectionView.collectionViewLayout = layout
        
        // Registering the View
        collectionView.register(DashboardCollectionViewCell.nib(), forCellWithReuseIdentifier: DashboardCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func goToTab(index: Int){
        let tabVC = self.storyboard!.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        tabVC.selectedIndex = index
        tabVC.modalPresentationStyle = .fullScreen
        self.present(tabVC, animated: true)
    }
}

extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Selected \(indexPath.row)")
        goToTab(index: indexPath.row)
    }
}


extension DashboardViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardCollectionViewCell.identifier, for: indexPath) as! DashboardCollectionViewCell
        cell.imageView.image = UIImage(named: collectionViewData[indexPath.row]["image"] ?? "invoice")
        cell.label.text = collectionViewData[indexPath.row]["name"]
        return cell
    }
}
