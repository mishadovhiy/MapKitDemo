//
//  MapDetailVC.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 20.01.2022.
//

import UIKit

class MapDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    static var shared:MapDetailVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapDetailVC.shared = self
        tableView.delegate = self
        tableView.dataSource = self
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        /*let net = NetworkModel()
        net.loadPet { loadedData in
            
        }*/
    }
    
    var sbvsLoaded = false
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !sbvsLoaded {
            sbvsLoaded = true
            self.view.layer.masksToBounds = true
            self.view.layer.cornerRadius = Globals.Styles.cornerRadius1
            self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }

    
    lazy var tableData:[TableData] = {
        return Globals.test_mapDetailData
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataa = tableData[indexPath.row]
        if let data = dataa.regulareType {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RegularCell", for: indexPath) as! RegularCell
            
            cell.action = data.actions.0
            cell.titleLabel.text = data.title
            
            let hideIcon = data.leftImage == nil
            let hideSegueIndicator = !data.needSegueIndicator
            if cell.iconView.isHidden != hideIcon {
                cell.iconView.isHidden = hideIcon
            }
            if cell.segueImage.isHidden != hideSegueIndicator {
                cell.segueImage.isHidden = hideSegueIndicator
            }
            if !hideIcon {
                cell.iconView.backgroundColor = .white
                cell.iconView.layer.masksToBounds = true
                cell.iconView.layer.cornerRadius = (data.leftImage?.isOval ?? false) ? (cell.iconView.frame.width / 2) : 10
                if let imgName = data.leftImage?.name {
                    if let img = UIImage(named: imgName) {
                        cell.iconImageView.image = img
                    }
                }
            }
            cell.buttonBackgroundView.layer.cornerRadius = data.style == .gray ? 10 : (cell.buttonBackgroundView.layer.frame.height / 2)
            cell.titleLabel.font = .systemFont(ofSize: cell.titleLabel.font.pointSize, weight: data.style == .gray ? .regular : .semibold)
            cell.titleLabel.textAlignment = data.style == .green ? .center : .left
            

            switch data.style {
            case .darkPurpure:
                cell.buttonBackgroundView.backgroundColor = Globals.Colors.purpure1
                cell.titleLabel.textColor = .white
                cell.segueImage.tintColor = .white
            case .lightPurpure:
                cell.buttonBackgroundView.backgroundColor = Globals.Colors.purpure2
                cell.titleLabel.textColor = Globals.Colors.purpure1
                cell.segueImage.tintColor = Globals.Colors.purpure1
            case .gray:
                cell.buttonBackgroundView.backgroundColor = Globals.Colors.grey
                cell.titleLabel.textColor = .black
            case .green:
                cell.buttonBackgroundView.backgroundColor = Globals.Colors.green
                cell.titleLabel.textColor = .black
            }
            return cell
        } else {
            let needCollection = (dataa.blockType != nil || dataa.photosType != nil || dataa.isCalendar) && (dataa.photosType?.type ?? .servicePhotos != .multiplePhotos)
            if dataa.tableType != nil || needCollection {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellCollectionView", for: indexPath) as! TableCellCollectionView
                
                var scrollDir:UICollectionView.ScrollDirection {
                    let multiple:UICollectionView.ScrollDirection = dataa.photosType?.type == .multiplePhotos || dataa.isCalendar ? .horizontal : .vertical
                    return needCollection ? multiple : .vertical
                }
                if let layout = cell.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = scrollDir
                }
                let hideScroll = !dataa.isCalendar
                cell.caretLeftButton.isHidden = hideScroll
                cell.caretRightButton.isHidden = hideScroll
                cell.sectionTitleLabel.text = dataa.sectionTitle
                cell.Data = dataa

                return cell
            } else {
                if dataa.photosType?.type ?? .servicePhotos == .multiplePhotos {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "multiplePhotosTableCell", for: indexPath) as! multiplePhotosTableCell
                    cell.collectionData = dataa.photosType
                    return cell
                } else {
                    return UITableViewCell()
                }
                
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let storyBoardTopBottomMargins:CGFloat = 115//+collectionView top + btn inserts
        if let tableCell = tableData[indexPath.row].tableType {
            let rawHeight:CGFloat = TableCellCollectionView.rawHeight
            let tableHeight = CGFloat(tableCell.data.count) * rawHeight
            return tableHeight + storyBoardTopBottomMargins
        } else {
            if let blockDataType = tableData[indexPath.row].blockType {
                let dataCount = blockDataType.collectionData.count
                let rawsCount = Float(dataCount) / Float(blockDataType.itemsInRow ?? 3)
                let roundedRows = ceil(rawsCount)
                let isServicePhotos = tableData[indexPath.row].photosType?.type ?? .multiplePhotos == .servicePhotos
                let rawHeight:Float = !isServicePhotos ? 55 : 90
                let height = roundedRows * rawHeight
                let result = CGFloat(height) + storyBoardTopBottomMargins
                return result
            } else {
                
                if tableData[indexPath.row].regulareType != nil {
                    return UITableView.automaticDimension
                } else {
                    if let photoDataType = tableData[indexPath.row].photosType {
                        return photoDataType.type == .multiplePhotos ? 100 : 210
                    } else {
                        return tableData[indexPath.row].isCalendar ? 230 : 0
                    }
                }
                
            }
            

            
        }
    }
    
    
    struct TableData {
        var tableType:CellType.Table? = nil
        var regulareType:CellType.Regulate? = nil
        var blockType:CellType.BlockCollection? = nil
        var photosType:CellType.Photos? = nil
        var isCalendar:Bool = false
        var sectionTitle:String? = nil

    }

}



