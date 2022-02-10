//
//  LoginVC.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 25.01.2022.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTF.text = Globals.User.username
        passwordTF.text = Globals.User.password
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        let net = NetworkModel()
        //error user:
        //johnsmith@gmail.com
        //23sdfdsf@#$
        //ok user:
        //misha@code-room.com
        //1@qqqqqq
        DispatchQueue.main.async {
            let username = self.loginTF.text ?? ""
            let password = self.passwordTF.text ?? ""
            
            net.loadUser(email: username, password: password) { loadedData, errorString in
                if loadedData["success"] as? Int ?? 0 == 1 {
                    if let data = loadedData["data"] as? [String: Any] {
                        Globals.User.dict = data
                        Globals.User.password = password
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vccc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                            vccc.modalPresentationStyle = .fullScreen
                            vccc.navigationController?.setNavigationBarHidden(true, animated: false)
                            self.present(vccc, animated: true)
                        }
                    }
                }
            }
            
        }
        
        
    }
    
}
