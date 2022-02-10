//
//  htmlContentVC.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 21.01.2022.
//

import UIKit
import Foundation

class htmlContentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var screenAI: UIActivityIndicatorView!
    var blog:BlogsStruct?
    
    var _tableData:[TableData] = []
    var tableData:[TableData] {
        get {
            return _tableData
        }
        set {
            _tableData = newValue
            DispatchQueue.main.async {
                self.screenAI.isHidden = newValue.count == 0 ? false : true
                if self.tableView.delegate == nil && newValue.count != 0 {
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                }
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // let testCont = "<div class=\"about-content\"><h2>Hello, I’m Misha. Nice to meet you</h2><p class=\"about-content\">I've <strong>sd</strong> started my journey as a web designer <img scr=\"\"> in 2017. I've done remote work for agencies and collaborated with talented people to create products for both business and consumer use. I'm always working on improving my apps.</p></div>"
        if let content = blog?.content {
            DispatchQueue.init(label: "dbLoad", qos: .userInteractive).async {
                self.unparseHTML(string: content)
            }
        }
        
    }
    
    
    func checkContainsImages() {
        var new:[TableData] = tableData
        var contains = false
        for i in 0..<new.count {
            if new[i].type == .image {
                if new[i].image == nil && !new[i].errorLoadingImage {
                    contains = true
                    let net = NetworkModel()
                    net.loadImage(url: new[i].name) { image in
                        if let img = image {
                            new[i].image = img
                        } else {
                            new[i].errorLoadingImage = true
                        }
                        
                    }
                }
            } else {
                if new[i].name.contains("<") {
                    new[i].name = removeTags(new[i].name)
                }
            }
            
        }
        if contains {
            self.tableData = new
        }
    }
    

    
    func unparseHTML(string:String) {
        var htmlHolder = string
       // htmlHolder = htmlHolder.replacingOccurrences(of: "/n", with: "")

        for i in 0..<htmlHolder.count {
            if i < htmlHolder.count {
                let index = htmlHolder.index(htmlHolder.startIndex, offsetBy: i)
                let word = htmlHolder[..<index]
                if word.contains("<li>") {
                    htmlHolder = slicee(tag: .list, data: htmlHolder)
                } else {
                    if word.contains("<p") {
                        htmlHolder = slicee(tag: .text, data: htmlHolder)
                    } else {
                        if word.contains("<h2") {
                            htmlHolder = slicee(tag: .h2, data: htmlHolder)
                        } else {
                            if word.contains("<h3") {
                                htmlHolder = slicee(tag: .h3, data: htmlHolder)
                            } else {
                                
                                if word.contains("<img") {
                                    let oneQ = "\""
                                    print(oneQ, "oneQoneQoneQoneQ")
                                    if htmlHolder.contains("src=\"") {
                                        if let url = htmlHolder.slice(from: "src=\"", to: oneQ) {
                                            print("urlStart:", url, ":urlEnd")
                                            htmlHolder = htmlHolder.replacingFirstOccurrenceOfString(target:  "src=\"" + url, withString: "")
                                            self.tableData.append(TableData(name: url, image:nil, type: .image))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        print("htmlHolderhtmlHolderhtmlHolderhtmlHolder start", htmlHolder, "htmlHolderhtmlHolderhtmlHolderhtmlHolder")
        if let blog = blog {
            tableData.insert(TableData(name: "", image: blog.photo, type: .image), at: 0)
            tableData.insert(TableData(name: blog.title, type: .h1), at: 0)
            tableData.append(TableData(name: "", type: .footer))
        }
        
        checkContainsImages()
        
        
    }
    
    
    func removeTags(_ string: String) -> String {
        var result = string
        while result.contains("<") && result.contains(">") {
            if let tee = result.slice(from: "<", to: ">") {
                result = result.replacingOccurrences(of: "<" + tee + ">", with: "")
            }
        }

        return result
    }
    
    func sliceeOpened(tag:ContentType, data:String) -> String {
        var result = data
        //slice opened tag from <p to > - content - </ - get content only + remove
        if let fullTagData = result.slice(from: "<\(tag.rawValue)", to: "</\(tag.rawValue)>") {
        
            print("opened:: full", fullTagData)
            let full = (fullTagData ?? "") + "</"
            if full.contains("\">") && full.contains("</") {
                let content = full.slice(from: ">", to: "</")
                
                result = result.replacingFirstOccurrenceOfString(target: full, withString: "") ?? ""
                print("openeddddt:::", content, "openeddddt\n")

                tableData.append(TableData(name: content ?? "", type: tag))
            }
            
            
        }
        return result
    }
    
    
    func slicee(tag:ContentType, data:String) -> String {
        var result = data
        //slice opened tag from <p to > - content - </ - get content only + remove
        if let text = result.slice(from: "<\(tag.rawValue)", to: "</\(tag.rawValue)>") {
            
            result = result.replacingFirstOccurrenceOfString(target: "<\(tag.rawValue)" + (text) + "</\(tag.rawValue)>", withString: "")
            result = result.removingSpecialCharacters()
            print("resultresultresultresult starttt:::", result, "resultresultresultresult\n")

            var textResult = text
            //slice text from first to >
            
            let inx = text.index(text.startIndex, offsetBy: 0)
            let first = String(text[inx])
            print(first, "firstfirstfirst")
            if let textToRemove = text.slice(from: first, to: ">") {
                result = result.replacingFirstOccurrenceOfString(target: first + textToRemove + ">", withString: "")
                textResult = textResult.replacingFirstOccurrenceOfString(target: first + textToRemove + ">", withString: "")
            } else {
                textResult.removeFirst()
            }
            
            textResult = removeTags(textResult)
            
            tableData.append(TableData(name: textResult, type: tag))
            
            
        }
        return result
    }

    func sliceSubtags(string:String) -> String {
        if let result = string.slice(from: ">", to: "</") {
            return result
        } else {
            return string
        }
        
    }
    
    

    //.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataType = tableData[indexPath.row].type
        switch dataType {
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlogDetailCell", for: indexPath) as! BlogDetailCell
            if let blog = blog {
                cell.link = blog.link
                cell.dateLabel.text = "Published: " + blog.date
                var categories:String {
                    var result = ""
                    for i in 0..<blog.categories.count {
                        result.append(blog.categories[i].name.uppercased() + "; ")
                    }
                    return result
                }
                cell.categoriesLabel.text = "Categories: \(categories)"
                cell.categoriesLabel.isHidden = categories == "" ? true : false
            }
            return cell
        case .text, .h1, .h2, .h3, .h4, .h5, .h6, .list, .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellhtmlText", for: indexPath) as! CellhtmlText
            let hideList = dataType == .list ? false : true
            if cell.listIIndicatorImage.isHidden != hideList {
                cell.listIIndicatorImage.isHidden = hideList
            }
            let showImage = tableData[indexPath.row].type == .image ? true : false
            let hideAI = tableData[indexPath.row].type == .image ? ((tableData[indexPath.row].image == nil && !tableData[indexPath.row].errorLoadingImage) ? false : true) : true
            cell.imageActivityIndicator.isHidden = hideAI
            if !hideAI {
                cell.imageActivityIndicator.startAnimating()
            } else {
                cell.imageActivityIndicator.stopAnimating()
            }
            
            
            cell.htmlImage.image = tableData[indexPath.row].image ?? UIImage.init(named: "camera.metering.unknown")
            cell.htmlImage.isHidden = !showImage
            cell.titleLabel.isHidden = showImage
            var fontSize:CGFloat {
                switch dataType {
                case .h1: return 32
                case .h2: return 28
                case .h3: return 21
                case .h4: return 18
                case .image: return 10
                default:
                    return 15
                }
            }
            cell.titleLabel.font = .systemFont(ofSize: fontSize, weight: dataType == .image || dataType == .list || dataType == .text ? .regular : .medium)
            cell.titleLabel.text = (tableData[indexPath.row].type.rawValue.contains("h") ? "\n" : "") + tableData[indexPath.row].name
            return cell

        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            self.title = ""
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if blog?.title ?? "" != "" {
            if indexPath.row == 0 && indexPath.section == 0 {
                self.title = blog?.title
            }
        }
        
    }
    
    struct TableData {
        var name:String
        var image:UIImage? = nil
        var errorLoadingImage = false
        var link:Link? = nil
        let type:ContentType
        
    }
    
    struct Link {
        let text:String
        let url:String
    }
    
    
    enum ContentType:String {
        case image = "img"
        case text = "p"
        case list = "li"
        case h1 = "h1"
        case h2 = "h2"
        case h3 = "h3"
        case h4 = "h4"
        case h5 = "h5"
        case h6 = "h6"
        case footer = ""
    }
}


class CellhtmlText: UITableViewCell {
    
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var htmlImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var listIIndicatorImage: UIImageView!
    
}





class BlogDetailCell: UITableViewCell {
    
    @IBOutlet private weak var dislikeIcon: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var authoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var link:String?
    @IBAction private func linkPressed(_ sender: CornerButton) {
        if let link = link {
            if let url = URL(string: link) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    @IBOutlet private weak var linkButton: CornerButton!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        dislikeIcon.transform = dislikeIcon.transform.rotated(by: .pi)
    }
}
