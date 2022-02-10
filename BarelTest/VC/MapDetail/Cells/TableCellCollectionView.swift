//
//  TableCellCollectionView.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 10.02.2022.
//

import UIKit

class TableCellCollectionView:UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var caretRightButton: UIButton!
    
    @IBOutlet weak var caretLeftButton: UIButton!
    @IBAction func caretPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            print(sender.tag)
            let cellSize = CGSize(width: self.layer.frame.width, height: self.layer.frame.height)
            let scrollAmount = cellSize.width / 2
            self.collectionView.scrollRectToVisible(CGRect(x: self.collectionView.contentOffset.x + (sender.tag == 1 ? scrollAmount : -(scrollAmount)), y: self.collectionView.contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        }
    }
    
    
    var _Data:MapDetailVC.TableData?
    var Data:MapDetailVC.TableData? {
        get {
            return _Data
        }
        set {
            _Data = newValue
            let needCollection = (newValue?.isCalendar ?? false) || newValue?.photosType != nil || newValue?.blockType != nil
            let hideTable = newValue?.tableType == nil

            DispatchQueue.main.async {
                self.collectionView.isHidden = !needCollection
                self.tableView.isHidden = hideTable
                
                if needCollection {
                    self.collectionView.reloadData()
                }
                
                if !hideTable {
                    self.tableView.reloadData()
                }
                
            }
            
        }
    }
    
    
    //collection view - save appeared cell and scroll back or forward
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
  //  var cellData:CellType?
    

    var drwed = false
    static var shadowOpasity:Float = 0.10
    @IBOutlet weak var tableView: UITableView!
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if !drwed {
            caretLeftButton.transform = caretLeftButton.transform.rotated(by: .pi)
            let radius:CGFloat = 15
            let secRad = secHeadBackView.frame.height / 2
            primaryBackgroundView.layer.cornerRadius = radius
            secHeadBackView.layer.cornerRadius = secRad
            secHeadBackBackgroundView.layer.cornerRadius = secRad - 5
            primaryBackgroundView.setShadows(radius: radius, shadowOpacity: TableCellCollectionView.shadowOpasity)
            secHeaderShadows.setShadows(radius: secRad, shadowOpacity: TableCellCollectionView.shadowOpasity)
            collectionView.showsVerticalScrollIndicator = false
            
            
            lded = true
            deviWidth = self.layer.frame.width
        }
        
        
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        Data = nil
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()

        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        baseMonth = todayComponents.month ?? 0
    }
    
    @IBOutlet weak var secHeaderShadows: UIView!
    @IBOutlet weak var primaryBackgroundView: UIView!
    @IBOutlet weak var secHeadBackView: UIView!
    @IBOutlet weak var secHeadBackBackgroundView: UIView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let blockData = Data?.blockType {
            return blockData.collectionData.count
        } else {
            if let imagesData = Data?.photosType {
                return imagesData.photos.count
            } else {
                if Data?.isCalendar ?? false {
                    return days.count - 1
                } else {
                    return 0
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("i: ", indexPath)
        print("data:", Data)
        if let blockData = Data?.blockType {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionBlockCell", for: indexPath) as! CollectionBlockCell
            if indexPath.row > (blockData.collectionData.count - 1) {
            //    cell.contentView.alpha = 0.2
                return cell
            }
            let data = blockData.collectionData[indexPath.row]

            var backgound:UIColor {
                if let isGreen = data.isGreen {
                    return isGreen ? Globals.Colors.green2 : Globals.Colors.red
                } else {
                    return Globals.Colors.purpure2
                }
            }
            
            if let isGreen = data.isGreen {
                cell.indicatorImage.image = isGreen ? UIImage.init(named: "Symbols/ok") : UIImage.init(named: "Symbols/clock")
                cell.indicatorImage.tintColor = isGreen ? Globals.Colors.green : .red
            }
            
            cell.backgroundColor = backgound
            cell.titleLabel.text = data.title
            cell.titleLabel.textAlignment = data.isGreen == nil ? .center : .left
            cell.titleLabel.textColor = data.isGreen == nil ? Globals.Colors.purpure1 : .black
            let hideImage = data.isGreen == nil ? true : false
            if cell.indicatorImage.isHidden != hideImage {
                cell.indicatorImage.isHidden = hideImage
            }
            //title center
            return cell
        } else {
            if let imagesData = Data?.photosType {
                switch imagesData.type {
                case .multiplePhotos:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionPhotoCell", for: indexPath) as! CollectionPhotoCell
                    cell.petImage.image = imagesData.photos[indexPath.row].photo
                    cell.petNameLabel.text = imagesData.photos[indexPath.row].petName
                    cell.contentView.alpha = imagesData.selectedIndex == nil ? 1 : (indexPath.row == imagesData.selectedIndex ? 1 : 0.3)
                    return cell
                case .servicePhotos:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionThreePhotosCell", for: indexPath) as! CollectionThreePhotosCell
                    let hidePrimary = imagesData.photos[indexPath.row].photo == nil
                    if cell.primaryView.isHidden != hidePrimary {
                        cell.primaryView.isHidden = hidePrimary
                    }
                    cell.petPhoto.image = imagesData.photos[indexPath.row].photo
                    cell.dateLabel.text = imagesData.photos[indexPath.row].petName
                    if cell.noPhotoLabel.superview?.isHidden ?? true != !hidePrimary {
                        cell.noPhotoLabel.superview?.isHidden = !hidePrimary
                    }
                    cell.noPhotoLabel.text = imagesData.photos[indexPath.row].defaultText?.rawValue ?? "-"
                    return cell
                }

            } else {
                
                if Data?.isCalendar ?? false {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "callendarCollectionCell", for: indexPath) as! callendarCollectionCell
                    if indexPath.row < (days.count - 1) {
                        let rawDate = Calendar.current.dateComponents(neededComponents, from: days[indexPath.row].date)
                        
                        cell.contentView.backgroundColor = todayComponents == rawDate ? .red : .clear
                        cell.dayLabel.text = days[indexPath.row].number
                        cell.dayLabel.alpha = rawDate.month == baseMonth ? 1 : 0.2
                    }
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionThreePhotosCell", for: indexPath) as! CollectionThreePhotosCell
                    cell.contentView.backgroundColor = .red
                    return cell
                }
                
            }
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let blockData = Data?.blockType {
            let numberOfItemsInRaw:CGFloat = CGFloat(blockData.itemsInRow ?? 1)
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets(top: 15, left: 4, bottom: 5, right: 4)
            layout.minimumInteritemSpacing = 04
            layout.minimumLineSpacing = 04
            layout.invalidateLayout()
            let deviceWidth = self.layer.frame.width
            print(deviceWidth)
            let storyBoardLeftMargin:CGFloat = 15
            return CGSize(width: ((deviceWidth/numberOfItemsInRaw) - (6 + storyBoardLeftMargin)), height: 45)
        } else {
            if Data?.photosType?.type ?? .servicePhotos == .multiplePhotos {
                return CGSize(width: 120, height: multiplePhotosTableCell.cellHeight)
            } else {
                return (Data?.isCalendar ?? false) ? CGSize(width: 70, height: 65) : CGSize(width: 80, height: 80)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    //set items for raw count
    
    
    //TABLE TYPE
 //   var tableData:[CellTypeTable.CellTypeRaw] = []
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data?.tableType?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfTableCell", for: indexPath) as! cellOfTableCell
        
        let tableData = Data?.tableType?.data ?? []
        if indexPath.row > tableData.count - 1 {
            //cell.contentView.alpha = 0.1
            return cell
        }
        cell.locationAddressLabel.text = tableData[indexPath.row].address + ((indexPath.row + 1) == tableData.count ? " Last" : "")
        let iconName = tableData[indexPath.row].icon
        let number = tableData[indexPath.row].number
        let hideIcon = iconName == nil ? true : false
        let hideNumberLabel = hideIcon ? (number == nil ? true : false) : true
        
        if cell.annotationIconImage.isHidden != hideIcon {
            cell.annotationIconImage.isHidden = hideIcon
        }
        if cell.annotationNumberLabel.isHidden != hideNumberLabel {
            cell.annotationNumberLabel.isHidden = hideNumberLabel
        }
        cell.annotationNumberLabel.text = number
        cell.locationTitleLabel.text = tableData[indexPath.row].locationTitle
        cell.annotationIconImage.image = Globals.imageNamed(iconName)
        let colorName = "Colors/" + tableData[indexPath.row].color.rawValue
        cell.annotationBackgroundImage.tintColor = UIColor.init(named: colorName + "2")
        cell.annotationIconImage.tintColor = UIColor.init(named: colorName + "1")
        cell.annotationNumberLabel.textColor = UIColor.init(named: colorName + "1")
        
        return cell
    }
    
    static let rawHeight:CGFloat = 80
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableCellCollectionView.rawHeight
    }
    
    
    
    
    
    //calendar
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Data?.isCalendar ?? false {
            let scrollX = scrollView.contentOffset.x
            print(scrollX, "scrolll pos")
            let contentSize = scrollView.contentSize.width - deviWidth
            print(contentSize, "contentSizeee")
            if lded {
                if scrollX < -120 || scrollX > (contentSize + 120) {
                    lded = false
                    changeMonth(forward: !(scrollX < -120))
                }
            }
        }
    }
    func changeMonth(forward:Bool) {
        print(forward)
        self.baseDate = self.calendar.date(byAdding: .month, value: forward ? 1 : (-1), to: self.baseDate) ?? self.baseDate
    }
    let neededComponents:Set<Calendar.Component> = [.year, .month, .day]
    lazy var todayComponents:DateComponents = {
        var today = Date()
        return Calendar.current.dateComponents(neededComponents, from: today)
    }()
    var lded = false
    var deviWidth:CGFloat = 0
    lazy var days = {
        generateDaysInMonth(for: baseDate)
    }()
    
    
    var baseMonth:Int = 0
    let calendar = Calendar(identifier: .gregorian)
    var selectedDate: Date?
    var baseDate: Date {
      set {
          days = generateDaysInMonth(for: newValue)
          selectedDate = newValue
          let comp = Calendar.current.dateComponents([.month, .year], from: newValue)
          baseMonth = comp.month ?? 0
          DispatchQueue.main.async {
              //self.currentMonthLabel.text = "\(comp.month ?? -1).\(comp.year ?? -1)" ------ set data title and reload table view
              self.sectionTitleLabel.text = "\(comp.month ?? -1).\(comp.year ?? -1)"
              self.collectionView.reloadData()
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
              self.lded = true
          }
      }
        get {
            return selectedDate ?? Date()
        }
    }
    
    
    lazy var dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "d"
      return dateFormatter
    }()
}




