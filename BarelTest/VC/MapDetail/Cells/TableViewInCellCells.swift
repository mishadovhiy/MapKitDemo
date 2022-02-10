//
//  TableViewInCellCells.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 10.02.2022.
//

import UIKit

class cellOfTableCell: UITableViewCell {

    @IBOutlet weak var annotationIconImage: UIImageView!
    
    @IBOutlet weak var annotationBackgroundImage: UIImageView!
    @IBOutlet weak var annotationNumberLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    
}


class CollectionBlockCell:UICollectionViewCell {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 12
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorImage: UIImageView!
    
}

class CollectionPhotoCell: UICollectionViewCell{
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 15
    }
    

}

class CollectionThreePhotosCell:UICollectionViewCell {
    @IBOutlet weak var noPhotoLabel: UILabel!
    
    @IBOutlet weak var primaryView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var petPhoto: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        self.layer.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1).cgColor//grey
    }
}


class RegularCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var segueImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var buttonBackgroundView: UIView!
    var action:(()->())?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    override func didMoveToWindow() {
        buttonBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.buttonPressed(_:))))
    }
                                     
    @objc private func buttonPressed(_ sender:UITapGestureRecognizer) {
        if let action = action {
            action()
        }
    }
}


class callendarCollectionCell:UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 16
    }
}
