//
//  BlogsVC.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 25.01.2022.
//

import UIKit

class BlogsVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var screenAI: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var _tableData:[BlogsStruct] = []
    var tableData:[BlogsStruct] {
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
        let network = NetworkModel()
        network.loadBlogs { loadedData in
            print("loadBlogs start", loadedData, "loadBlogsloadBlogs")
            var blogsData:[BlogsStruct] = []
            for i in 0..<(loadedData?.count ?? 0) {
                if let blog = loadedData?[i] {
                    
                    let cats = blog["categories"] as? [[String:Any]] ?? []
                    var resultCategories:[BlogsStruct.Categories] = []
                    for i in 0..<cats.count {
                        let cat = BlogsStruct.Categories(id: cats[i]["id"] as? Int ?? 0, link: cats[i]["link"] as? String ?? "", name: cats[i]["name"] as? String ?? "")
                        resultCategories.append(cat)
                    }
                    
                    let imgSizes = ((blog["all_media"] as? [String:Any] ?? [:])["media_details"] as? [String:Any] ?? [:])["sizes"] as? [String:Any] ?? [:]
                    print(imgSizes)
                    let imgUrl = (imgSizes["medium"] as? [String:Any] ?? [:])["source_url"] as? String ?? ""
                    print(imgUrl, "imgUrlimgUrlimgUrl")
                    let previewText = self.getPTag(blog["excerpt"] as? String ?? "").removingSpecialCharacters()
                    let title = (blog["title"] as? String ?? "").removingSpecialCharacters()
                    
                    network.loadImage(url: imgUrl) { image in
                        let new = BlogsStruct(title: title, link: blog["link"] as? String ?? "", date: blog["date"] as? String ?? "", excerpt: previewText, content: (blog["content"] as? [String:Any] ?? [:])["rendered"] as? String ?? "", categories: resultCategories, photo: image)
                        self.tableData.append(new)
                    }
                    
                    
                }
            }
        }
    }
    
    func getPTag(_ string:String) -> String {
        if string.contains("<p") {
            return string.slice(from: ">", to: "<") ?? string
        } else {
            return string
        }
    }
    
    
    var _selectedBlog:BlogsStruct?
    var selectedBlog:BlogsStruct? {
        get { return _selectedBlog}
        set {
            _selectedBlog = newValue
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toSelectedBlog", sender: self)
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toSelectedBlog":
            if let vc = segue.destination as? htmlContentVC {
                vc.blog = selectedBlog
            }
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogPreviewCell", for: indexPath) as! BlogPreviewCell
        let data = tableData[indexPath.row]
        cell.blogImage.isHidden = data.photo == nil ? true : false
        cell.blogImage.image = data.photo
        cell.blogTitleLabel.text = data.title
        cell.dateLabel.text = data.date
        cell.descriptionLabel.text = data.excerpt
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBlog = tableData[indexPath.row]
    }
    
}
struct BlogsStruct {
    let title:String
    let link:String
    let date:String
    let excerpt:String
    var content:String//html
    let categories:[Categories]
    let photo:UIImage?
    
    struct Categories {
        let id:Int
        let link:String
        let name:String
    }
    
    
}



class BlogPreviewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var blogImage: UIImageView!
    @IBOutlet weak var blogTitleLabel: UILabel!
    
}
