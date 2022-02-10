//
//  NetworkModel.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 20.01.2022.
//

import UIKit

class NetworkModel {
    
    private let requestTimeout:Double = 300
    
    private let serverUrl:String = "https://devapi.mybarel.com/api/"
    
    //get pets inActive - YL8GE67AP-C-3
    
    func loadPet(completion: @escaping ([String:Any]) -> ()) {
        let head:[String:Any] = [
            "inActive":"12"
        ]
        loadWith(dictionary: head, service: "v1/pet", httpMethod: .get) { loadedData, error in
            print("pet start:\n", loadedData, "\npet end")
            completion(loadedData)
        }
    }
    
    
    
    func loadImage(url:String, completion: @escaping (UIImage?) -> ()) {

        if let url: URL = URL(string: url) {
            if let data = try? Data(contentsOf: url) {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
        

    }
    
    func loadBlogs(completion: @escaping ([[String:Any]]?) -> ()) {
        loadWith(dictionary: [:], service: "v1/blogs", httpMethod: .get) { loadedData, errorReq in
            let errorAction = {
                print("error loading data")
                completion(Globals.Offline.blogs)
            }
            if errorReq ?? NetworkModel.RequestError.none == .none {
                if let data = loadedData["data"] as? [String:Any] {
                    if let blogs = data["blogs"] as? [[String:Any]] {
                        Globals.Offline.blogs = blogs
                        completion(blogs)
                    } else {
                        errorAction()
                    }
                    
                } else {
                    errorAction()
                }
                
            } else {
                errorAction()
            }
        }
    }
    
    func loadUser(email:String, password:String, completion: @escaping ([String:Any], String) -> ()) {
        let dict:[String:Any] = [
            "email":email,
            "password":password
        ]
        loadWith(dictionary: dict, service: "v1/customer/sign-in") { loadedData, requestError in
            //unpars error message, succsess
            //"msg"
            //"success"
            if let data = loadedData["data"] as? [String:Any] {
                let name = data["firstName"] as? String ?? "-"
                let id = data["id"] as? Int
                print(id, " ", name, "bhjkl")
            }
            completion(loadedData, "")
        }
    }
    

}




extension NetworkModel {
    private func loadWith(dictionary:[String:Any],service:String = "v1/customer/sign-in", httpMethod:httpMethod = .post ,completion: @escaping ([String:Any],RequestError?) -> ()){
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])else{
            completion([:], .other)
            return
        }
        
        guard let requestString = String(data: jsonData, encoding: String.Encoding.utf8) else{
            completion([:], .other)
            return
        }
        let urlStr = serverUrl + service
        load(urlPath: urlStr, data: requestString, httpMethod:httpMethod) { (values, error) in
            completion(values,error)
            return
        }
    }
    
    enum httpMethod: String {
        case post = "POST"
        case get = "GET"
    }
    
    private func load(urlPath: String,data:String, usingHeaders:Bool = true, httpMethod:httpMethod = .post, completion: @escaping ([String:Any],RequestError?) -> ()) {
        guard let url: URL = URL(string: urlPath) else{
            completion([:], .other);
            return
        };
        let config = URLSessionConfiguration.default
        if usingHeaders {
            config.httpAdditionalHeaders = ["Content-Type":"application/json","Accept": "application/json"]
        }
        
        config.timeoutIntervalForRequest = requestTimeout
        var request:URLRequest = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = requestTimeout
        let str = data;
        print(str, "strstrstrstr")
        if httpMethod == .post {
            request.httpBody = data.data(using: String.Encoding.utf8);
        }
        
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completion([:], .server)//string/or dict error indeed
                print("load error", error ?? "-")
                return
            }
            guard let data = data else{
                completion([:], .zeroData);
                return
            }
            guard let jsonString = String(data: data, encoding: String.Encoding.utf8)else{
                completion([:], .other);
                return;
            }
            print("load: url: ", url)
            print("load: str: ", str)
            print("load: jsonString: ", jsonString)
            
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] else{
                completion([:], .other);
                return
            }
            print("load: jsonResult:", jsonResult)
            completion(jsonResult,nil)
            
        }

        DispatchQueue.main.async {
            task.resume()
        }
        
    }
    
    enum RequestError {
        case none
        case internet
        case zeroData
        case server
        case other
    }//
    private func errorText(error:RequestError) -> String {
        switch error {
        case .none:
            return "-"
        case .internet:
            return "Internet Error"
        case .zeroData:
            return "No data"
        case .server:
            return "Server error"
        case .other:
            return "Some error"
        }
    }
}
