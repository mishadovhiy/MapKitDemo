//
//  multiplePhotosTable.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 10.02.2022.
//

import UIKit


class multiplePhotosTableCell:UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionData: CellType.Photos?
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var drCalled = false
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !drCalled {
            
        }
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiplePhotoCollectionCell", for: indexPath) as! MultiplePhotoCollectionCell
        
        cell.petImage.image = collectionData?.photos[indexPath.row].photo
        cell.petNameLabel.text = collectionData?.photos[indexPath.row].petName
        return cell
    }
    
    
}

class MultiplePhotoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
}

