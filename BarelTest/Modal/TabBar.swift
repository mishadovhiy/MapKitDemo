//
//  TabBar.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 19.01.2022.
//

import UIKit
import Foundation

class TabBarController: UITabBarController {
    
    static var shared:TabBarController?

    override func viewDidLoad() {
        super.viewDidLoad()
        TabBarController.shared = self
        
        self.tabBar.items?[0].badgeValue = Globals.messsages.count == 0 ? nil : "\(Globals.messsages.count)"
    }

    
}


class TabBar: UITabBar {

    static var shared:TabBar?
    
    let cornerRadius:CGFloat = Globals.Styles.cornerRadius1
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
    }

    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let selfFrame = self.frame
        let blockHeight = (selfFrame.height) + (cornerRadius * 2)
        let cornerViewFrame = CGRect(x: 0, y: -cornerRadius, width: selfFrame.width, height: blockHeight * 2)

        self.tintColor = Globals.Colors.purpure1
        if !viewDrawed {
            viewDrawed = true
            
       //     addMessageView()
            
            cornerView = UIView(frame: cornerViewFrame)
            cornerView?.backgroundColor = .white
            cornerView?.layer.cornerRadius = cornerRadius
            cornerView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cornerView?.layer.masksToBounds = true
            
            shadowView = UIView(frame: cornerViewFrame)
            shadowView?.backgroundColor = self.backgroundColor
            shadowView?.setShadows()
            shadowView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            cornerView?.layer.zPosition = -1
            shadowView?.layer.zPosition = -1
            shadowView?.isUserInteractionEnabled = false
            cornerView?.isUserInteractionEnabled = false
            self.addSubview(shadowView ?? UIView(frame: .zero))
            
            self.addSubview(cornerView ?? UIView(frame: .zero))
        } else {
            UIView.animate(withDuration: 0.3) {
                self.cornerView?.frame = cornerViewFrame
                self.shadowView?.frame = cornerViewFrame
             //   self.messageStack?.frame = self.messageStackFrame
             //   self.stackBackgroundView?.frame = self.messageBackgroundFrame
            } completion: { _ in
                
            }

        }
    }
    
    
    
    

    override func didMoveToWindow() {
        super.didMoveToWindow()
        TabBar.shared = self
    }

    
    
    private var cornerView:UIView?
    private var shadowView:UIView?
    
    private var viewDrawed = false
    

    
}





extension TabBar {
    /*   ///!!! message should be only in MapVC
     private var messageHeight:CGFloat {
         return !(TabBarController.shared?.showingMessage ?? false) ? 0 : 75
     }
     
     
      var stackBackgroundView:UIView?
     private var messageStack:UIStackView?
     
     private var messageBackgroundFrame: CGRect {
         return CGRect(x: 0, y: -cornerRadius, width: self.frame.width, height: messageHeight)
     }
     private var messageStackFrame:CGRect {
         return CGRect(x: 16, y: 0, width: self.frame.width - 32, height: messageHeight - cornerRadius)
     }
     
     func addMessageView() {
         stackBackgroundView = UIView(frame: messageBackgroundFrame)
         stackBackgroundView?.layer.zPosition = -1
         stackBackgroundView?.backgroundColor = .systemPink
         stackBackgroundView?.layer.cornerRadius = cornerRadius
         stackBackgroundView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
         
         messageStack = UIStackView(frame: messageStackFrame)
         messageStack?.spacing = 10
         messageStack?.alignment = .fill
         messageStack?.distribution = .fill
         messageStack?.axis = .horizontal
         
         let messageIcon = UIImageView(image: UIImage(named: "asset10"))
         messageIcon.translatesAutoresizingMaskIntoConstraints = false
         let widthConstraint = NSLayoutConstraint(item: messageIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
         messageIcon.addConstraint(widthConstraint)
         messageIcon.contentMode = .scaleAspectFit
         messageIcon.translatesAutoresizingMaskIntoConstraints = false
         messageStack?.addArrangedSubview(messageIcon)
         
         let label = UILabel()
         label.text = "Messages"
         label.translatesAutoresizingMaskIntoConstraints = false
         messageStack?.addArrangedSubview(label)
         
         let goIcon = UIImageView(image: UIImage(named: "caretRight"))
         goIcon.contentMode = .scaleAspectFit
         goIcon.translatesAutoresizingMaskIntoConstraints = false
         messageStack?.addArrangedSubview(goIcon)
         
         messageStack?.isUserInteractionEnabled = true
         
         messageStack?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(messagePressed(_:))))
         
         stackBackgroundView?.addSubview(messageStack ?? UIStackView(frame: .zero))
         
         self.addSubview(stackBackgroundView ?? UIView(frame: .zero))


     }
     

     @objc func messagePressed(_ sender:UITapGestureRecognizer) {
         //view - top with frames
         //animation comletion  show message vc,animated: false
         //messageVC - same view
         DispatchQueue.main.async {
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let vccc = storyboard.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
             vccc.modalPresentationStyle = .formSheet
             vccc.navigationController?.setNavigationBarHidden(true, animated: false)
             TabBarController.shared?.present(vccc, animated: true)
         }
     }
     
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        let safeAr = AppDelegate.shared?.safeArea?.bottom ?? 0
       // print(safeAr, "safeArsafeArsafeAr")
        let tabHeight:CGFloat = safeAr < 5 ? 25 : 45
        return CGSize(width: self.layer.frame.width, height: !(TabBarController.shared?.showingMessage ?? false) ? tabHeight : tabHeight + messageHeight)
        //return CGSize(width: self.layer.frame.width, height: tabHeight)
    }*/
    /*override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        return CGSize(width: size.width, height: 70)
    }*/
}
/*extension UITabBarItem {
    static var shared:UITabBarItem?
    open override func awakeFromNib() {
        UITabBarItem.shared = self
      //  refreshInsets()
    }
    func refreshInsets() {
        let top:CGFloat = (TabBarController.shared?.showingMessage ?? false) ? 20 : 0
        self.imageInsets = UIEdgeInsets(top: top, left: 0, bottom: -top, right: 0)
    }
}*/



