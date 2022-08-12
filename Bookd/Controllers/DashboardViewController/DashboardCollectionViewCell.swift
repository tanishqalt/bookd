//
//  DashboardCollectionViewCell.swift
//  Bookd
//
//  Created by TM Humber Group on 2022-08-12.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DashboardCollectionViewCell"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage, text: String){
        self.imageView.image = image
        self.label.text = text
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "DashboardCollectionViewCell", bundle: nil)
    }

}
