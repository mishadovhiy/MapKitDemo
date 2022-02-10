//
//  Globals.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 25.01.2022.
//

import UIKit
extension UITableView {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.contentInset.bottom = (TabBar.shared?.cornerRadius ?? -500)
    }
}

class TableViewNoSpace: UITableView {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.contentInset.bottom = 0
    }
}




class Globals {
    static var _messsages:[String] = []
    static var messsages:[String] {
        get{ return _messsages }
        set {
            _messsages = newValue
            if let mapVC = MapVC.shared {
                mapVC.checkMessage()
            }
            TabBarController.shared?.viewDidLoad()
            
        }
    }
    
    static func imageNamed(_ name:String?) -> UIImage? {
        let def = UIImage(named: "unknown")!
        if name != "" {
            return UIImage(named: name ?? "unknown") ?? def
        } else {
            return def
        }
    }
    
    
    class Offline {
        static var blogs:[[String:Any]] {
            get {
                return UserDefaults.standard.value(forKey: "OfflineBlogs") as? [[String:Any]] ?? []
            }
            set {
                UserDefaults.standard.value(forKey: "OfflineBlogs")
            }
        }
    }
    
    class Colors {
        /**
         -dark
         */
        static let purpure1 = UIColor.init(named: "Colors/Purpure1") ?? UIColor(red: 247/255, green: 238/255, blue: 245/255, alpha: 1)
        
        static let purpure2 = UIColor.init(named: "Colors/Purpure2")  ?? UIColor(red: 155/255, green: 36/255, blue: 127/255, alpha: 1)

        static let green = UIColor.init(named: "Colors/Green1") ?? .red
        static let green2 = UIColor.init(named: "Colors/Green2") ?? .red
        
        static let red = UIColor(red: 251/255, green: 239/255, blue: 241/255, alpha: 1)
        
        static let grey = UIColor(red: 210/255, green: 216/255, blue: 214/255, alpha: 1)
        
    }
    class User {
        static var dict:[String:Any] {
            get {
                return UserDefaults.standard.value(forKey: "LoggedUser") as? [String:String] ?? [:]
            }
            set {
                var currect:[String:String] = [:]
                for (key,value) in newValue {
                    if newValue[key] != nil {
                        currect[key] = "\(value)"
                    }
                }
                if !currect.isEmpty {
                    UserDefaults.standard.setValue(currect, forKey: "LoggedUser")
                }
                
            }
        }
        
        
        static var username:String {
            get {
                return dict["email"] as? String ?? ""
            }
            set {
                var all = dict
                all["email"] = newValue
                dict = all
            }
        }
        static var password:String {
            get {
                return dict["password"] as? String ?? ""
            }
            set {
                var all = dict
                all["password"] = newValue
                dict = all
            }
        }
    }
    
    
    class Styles {
        static var cornerRadius1:CGFloat = 20
    }
    
    static var test_mapDetailData: [MapDetailVC.TableData]  {
        let collectionSection = [
            CellType.BlockCollection.BlockType(isGreen: true, title: "Snack1"),
            CellType.BlockCollection.BlockType(isGreen: true, title: "Water2"),
            CellType.BlockCollection.BlockType(isGreen: false, title: "Medication3"),
            CellType.BlockCollection.BlockType(isGreen: false, title: "Pee4"),
            CellType.BlockCollection.BlockType(isGreen: true, title: "Poop5"),
        ]
        let collectionSection2 = [
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Snack"),
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Water"),
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Medication"),
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Pee"),
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Poop1"),
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Poop2"),
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Poop3"),
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Poop4"),
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Poop5"),
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Poop6"),
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Poop7"),
            CellType.BlockCollection.BlockType(isGreen: nil, title: "Poop8"),
        ]
        
        let dogPhotos:[CellType.Photos.PhotoType] = [
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffael", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffaelre", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffa", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "ffael", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Rel", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffael", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "RuffaelRuffael", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffaelsfs", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffael", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffaelre", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffa", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffael", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffaelre", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffa", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "ffael", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Rel", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffael", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "RuffaelRuffael", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffaelsfs", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffael", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffaelre", defaultText: nil),
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog"), petName: "Ruffa", defaultText: nil),
        ]
        
        
        
        let tableSection = [
            CellType.Table.CellTypeRaw(locationTitle: "Pick Up Location", address: "123 Address Ave, Sarasota, FL 12345", icon: "Symbols/home", number: nil, color: .orange),
            CellType.Table.CellTypeRaw(locationTitle: "Drop Off Location #1", address: "456 Address Ave, Sarasota, FL 12345", icon: nil, number: "1", color: .purpure),
            CellType.Table.CellTypeRaw(locationTitle: "Drop Off Location #2", address: "789 Address Ave, Sarasota, FL 12345", icon: nil, number: "2", color: .purpure),
            CellType.Table.CellTypeRaw(locationTitle: "Final Drop Off Location", address: "159 Address Ave, Sarasota, FL 12345", icon: "Symbols/ok", number: nil, color: .purpure)
        ]
        let tableSection2 = [
            CellType.Table.CellTypeRaw(locationTitle: "2Pick Up Location", address: "123 Address Ave, Sarasota, FL 12345", icon: "Symbols/home", number: nil, color: .orange),
            CellType.Table.CellTypeRaw(locationTitle: "2Drop Off Location #1", address: "456 Address Ave, Sarasota, FL 12345", icon: nil, number: "1", color: .purpure),
            CellType.Table.CellTypeRaw(locationTitle: "2Drop Off Location #2", address: "789 Address Ave, Sarasota, FL 12345", icon: nil, number: "2", color: .green),
            CellType.Table.CellTypeRaw(locationTitle: "2Final Drop Off Location", address: "159 Address Ave, Sarasota, FL 12345", icon: "Symbols/ok", number: nil, color: .purpure)
        ]
        
        let regulare1Action = {
            print("pressed!!!")
        }
        let regulare1 = CellType.Regulate(title: "Safe Entry Instructions", style: .lightPurpure, leftImage: CellType.Regulate.LeftImage(name: "Symbols/locker", isOval: true), needSegueIndicator: true, actions: (regulare1Action, nil))
        let regulare2 = CellType.Regulate(title: "Access the Location", style: .darkPurpure, leftImage: CellType.Regulate.LeftImage(name: "Symbols/door", isOval: true), needSegueIndicator: true, actions: (regulare1Action, nil))
        
        let regulare3 = CellType.Regulate(title: "Provider at the service location now.", style: .gray, leftImage: CellType.Regulate.LeftImage(name: "Symbols/door", isOval: false), needSegueIndicator: false, actions: (regulare1Action, nil))
        let regulare4 = CellType.Regulate(title: "View Service Details", style: .lightPurpure, leftImage: nil, needSegueIndicator: true, actions: (regulare1Action, nil))
        let regulare5 = CellType.Regulate(title: "Green button", style: .green, leftImage: nil, needSegueIndicator: false, actions: (regulare1Action, nil))
        
        
        let afterBefore = [
            CellType.Photos.PhotoType(photo: UIImage(named: "test/dog2"), petName: "12:01 PM", defaultText: .before),
            CellType.Photos.PhotoType(photo: nil, petName: "12:01 PM", defaultText: .during),
            CellType.Photos.PhotoType(photo: nil, petName: "12:01 PM", defaultText: .after)
        ]
        
        return [
            MapDetailVC.TableData(isCalendar: true, sectionTitle: "Date"),
            MapDetailVC.TableData(photosType: CellType.Photos(type: .servicePhotos, photos: afterBefore), sectionTitle: "Service Photos"),
            MapDetailVC.TableData(photosType: CellType.Photos(type: .multiplePhotos, selectedIndex: 2, photos: dogPhotos)),
            MapDetailVC.TableData(regulareType: regulare1),
            MapDetailVC.TableData(regulareType: regulare2),
            MapDetailVC.TableData(regulareType: regulare3),
           // MapDetailVC.TableData(regulareType: regulare4),
            MapDetailVC.TableData(regulareType: regulare5),
            MapDetailVC.TableData(tableType: CellType.Table(data: tableSection), sectionTitle:"Locations"),
            MapDetailVC.TableData(blockType: CellType.BlockCollection(itemsInRow: 2, collectionData: collectionSection), sectionTitle: "Service Updates"),
            MapDetailVC.TableData(tableType:nil, blockType: CellType.BlockCollection(itemsInRow: 3, collectionData: collectionSection2), sectionTitle: "Mood & Behavior"),
            MapDetailVC.TableData(tableType: CellType.Table(data: tableSection2), sectionTitle: "Second Locations"),
            MapDetailVC.TableData(blockType: CellType.BlockCollection(itemsInRow: 2, collectionData: collectionSection), sectionTitle: "Service Updates"),
            MapDetailVC.TableData(blockType: CellType.BlockCollection(itemsInRow: 2, collectionData: collectionSection), sectionTitle: "Service Updates2"),
        ]
    }
    
    
    
    
}

extension UIView {
    func setShadows(radius:CGFloat? = nil, shadowOpacity:Float = 0.45) {
        DispatchQueue.main.async {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = shadowOpacity
            self.layer.shadowOffset = .zero
            self.layer.shadowRadius = radius ?? Globals.Styles.cornerRadius1
            self.layer.cornerRadius = radius ?? Globals.Styles.cornerRadius1
        }
    }
}


extension String {
    
    func replacingFirstOccurrenceOfString(
                target: String, withString replaceString: String) -> String
        {
            if let range = self.range(of: target) {
                return self.replacingCharacters(in: range, with: replaceString)
            }
            return self
        }
    
    func slice(from: String, to: String) -> String? {
        var text:String?
        let _ = (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                text = String(self[substringFrom..<substringTo])
            }
        }
        
        return text
    }
    
    
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}


