//
//  multiplePhotosTable.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 10.02.2022.
//

import UIKit


class multiplePhotosTableCell:UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let cellHeight:CGFloat = 80
    
    var _collectionData: CellType.Photos?
    var collectionData: CellType.Photos? {
        get { return _collectionData }
        set {
            _collectionData = newValue
            if let idx = newValue?.selectedIndex {
                if idx < newValue?.photos.count ?? 0 {
                    DispatchQueue.main.async {
                        
                        self.collectionView.scrollToItem(at: IndexPath(item: idx, section: 0), at: .centeredHorizontally, animated: self.animateScroll)
                        if self.animateScroll {
                            self.animateScroll = false
                        }
                        
                    }
                }
            }
        }
    }
    private var animateScroll = false
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var rightScrollButton: UIButton!
    
    @IBAction func scrollPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            print(sender.tag)
            let cellSize = CGSize(width: self.layer.frame.width, height: self.layer.frame.height)
            let scrollAmount = cellSize.width / 2
            self.collectionView.scrollRectToVisible(CGRect(x: self.collectionView.contentOffset.x + (sender.tag == 1 ? scrollAmount : -(scrollAmount)), y: self.collectionView.contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        }
    }
    
    var drCalled = false
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !drCalled {
            rightScrollButton.transform = rightScrollButton.transform.rotated(by: .pi)
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
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
        cell.contentView.alpha = collectionData?.selectedIndex == indexPath.row ? 1 : 0.3
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: multiplePhotosTableCell.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        animateScroll = true
        collectionData?.selectedIndex = indexPath.row
        collectionView.reloadData()
    }
    
}

class MultiplePhotoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
}

