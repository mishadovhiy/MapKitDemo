//
//  ViewController.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 19.01.2022.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet weak var panView: UIView!
    @IBOutlet weak var ovarlayStack: UIStackView!
    @IBOutlet weak var detaiHelperView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailContainerView: UIView!
    static var shared:MapVC?
    var sbvsLoaded = false
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !sbvsLoaded {
            let tabbar = self.tabBarController?.tabBar.frame.height ?? 0
            let nav = self.navigationController?.navigationBar.frame.height ?? 0
            safeAreas = self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom + tabbar + nav + (Globals.Styles.cornerRadius1 * 2)
            print(safeAreas, "overlayVisiblePartoverlayVisiblePartoverlayVisiblePart")
            overlayY = self.ovarlayStack.frame.minY
            messageOvalView.layer.masksToBounds = true
            messageOvalView.layer.cornerRadius = messageOvalView.layer.frame.width / 2
            sbvsLoaded = true
            messageView.layer.cornerRadius = Globals.Styles.cornerRadius1
            messageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            messageView.layer.masksToBounds = true
            detailContainerView.setShadows()
        }
    }
    @objc func messagePressed(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vccc = storyboard.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
            vccc.modalPresentationStyle = .formSheet
            vccc.navigationController?.setNavigationBarHidden(true, animated: false)
            self.present(vccc, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        MapVC.shared = self
        addAnnotations()
        messageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.messagePressed(_:))))
        checkMessage()
        
        panView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.detailContainerViewPinched(_:))))

    }
    var overlayY:CGFloat = 0
    var safeAreas:CGFloat = 0
    
    @IBOutlet weak var panImage: UIImageView!
    @objc func detailContainerViewPinched(_ sender: UIPanGestureRecognizer) {
        let finger = sender.location(in: self.view)
        
        if sender.state == .began || sender.state == .changed {
            let newPosition = finger.y - self.overlayY
            print(newPosition, "newPositionnewPosition")
            self.ovarlayStack.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, newPosition < 0 ? 0 : newPosition, 0)
            self.panView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, newPosition < 0 ? 0 : newPosition, 0)
        } else {
            if sender.state == .ended {
                let toHide = self.view.frame.height / 2 > finger.y //wasShowingSideBar ? 200 : 80
                toggleDetailView(toHide, animated: true)
            }
        }
        if sender.state == .began || sender.state == .ended {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    //self.detaiHelperView.backgroundColor = sender.state == .began ? UIColor(red: 0, green: 0, blue: 0, alpha: 0.3) : .clear
                    self.panImage.alpha = sender.state == .began ? 0.3 : 0
                } completion: { _ in
                    
                }
            }
        }
        
        
    }

    var wasShowingSideBar = false
    var beginScrollPosition:CGFloat = 0
    
    func toggleDetailView(_ show:Bool, animated:Bool) {
        let marginToShow:CGFloat = safeAreas + 200//safe area top/btn
        sideBarShowing = show
        DispatchQueue.main.async {
            let hiddenHeight = self.view.frame.height - marginToShow
            UIView.animate(withDuration: animated ? 0.3 : 0.0) {
                self.ovarlayStack.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, show ? 0 : hiddenHeight, 0)
                self.panView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, show ? 0 : hiddenHeight, 0)
            } completion: { _ in
                MapDetailVC.shared?.tableView.isUserInteractionEnabled = show
            }

        }
    }
    var sideBarShowing = true
    
    

    func checkMessage() {
        DispatchQueue.main.async {
            self.messageLabel.text = "\(Globals.messsages.count)"
            let hideMessageView = Globals.messsages.count == 0 ? true : false
            if self.messageView.isHidden != hideMessageView {
                UIView.animate(withDuration: 0.3) {
                    self.messageView.isHidden = hideMessageView
                } completion: { _ in
                    
                }
            }
        }
    }
    
    
    
    
    func addAnnotations() {
        let annotationAppearence = Artwork.Appearence(iconNamed: "Symbols/home", number: nil,color: Globals.Colors.green)//draw icons in SF Symbols
        let artwork = Artwork(title: "King David Kalakaua", locationName: "Waikiki Gateway Park", discipline: "Sculpture", coordinate: CLLocationCoordinate2D(latitude: 50.476955184265265, longitude: 30.499129294476067), identifier: "annotationIdentifier", appearence: annotationAppearence)
        mapView.addAnnotation(artwork)
        let annotationAppearence2 = Artwork.Appearence(iconNamed: nil, number: 2)
        let artwork2 = Artwork(title: "Kalakaua", locationName: "Waikiki Gateway Park", discipline: "Sculpture", coordinate: CLLocationCoordinate2D(latitude: 50.47511156693275, longitude: 30.514316298880274), identifier: "annotationIdentifier", appearence: annotationAppearence2)
        mapView.addAnnotation(artwork2)
        let center = CLLocationCoordinate2D(latitude: artwork2.coordinate.latitude, longitude: artwork2.coordinate.longitude)
        mapView.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)

        //draw lines
        let sourceLocation = CLLocationCoordinate2D(latitude: artwork.coordinate.latitude, longitude: artwork.coordinate.longitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: artwork2.coordinate.latitude, longitude: artwork2.coordinate.longitude)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
               
        let directions = MKDirections(request: directionRequest)
        directions.calculate { responsee, error in
            guard let response = responsee else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
                       
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                       
           // let rect = route.polyline.boundingMapRect
         //   self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }

    }
    
    
    @IBAction func toggleMessageView(_ sender: UIButton) {
        let messages = Globals.messsages//TabBar.shared?.messsages ?? []
        Globals.messsages = messages.count == 0 ? ["", "", ""] : []
        DispatchQueue.main.async {
            TabBar.shared?.sizeToFit()
        }
    }

    @IBOutlet weak var messageOvalView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
}


extension MapVC:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Artwork else {
            return nil
        }
        let annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: annotation.identifier)
        //annotationView.image = UIImage(named: annotation.appearence.backgroundImage)
        annotationView.image = nil//UIImage(named: "Annotation/annotationLineBackgroundHelper")
        
        
        
        let supFrame = annotationView.frame
        let annotationBackgroundHelper = UIImageView(frame: CGRect(x: -15, y: -20, width: 25, height: 25))
        
        let actualAnnotationIcon = UIImageView(frame: CGRect(x: -1, y: -2, width: annotationBackgroundHelper.frame.width + 1, height: annotationBackgroundHelper.frame.height + 1))
        actualAnnotationIcon.image = UIImage(named: "Annotation/annotationLine")
        actualAnnotationIcon.contentMode = .scaleAspectFit
        actualAnnotationIcon.tintColor = annotation.appearence.color
        
        
        
        annotationBackgroundHelper.image = UIImage(named: "Annotation/annotationLineBackgroundHelper")
        annotationBackgroundHelper.contentMode = .scaleAspectFit
        annotationView.addSubview(annotationBackgroundHelper)
        annotationBackgroundHelper.addSubview(actualAnnotationIcon)
        
        let objWidth = annotationBackgroundHelper.frame.width - 15
        //let objectFrame = CGRect(x: (supFrame.width / 2) - (objWidth / 2), y: objWidth / 2, width: objWidth, height: objWidth)
        let objectFrame = CGRect(x: (actualAnnotationIcon.frame.width / 2) - (objWidth / 2), y: (((actualAnnotationIcon.frame.height / 2) - (objWidth / 2)) - 1), width: objWidth, height: objWidth)
        if let anNumber = annotation.appearence.number {
            let label = UILabel(frame: objectFrame)
            label.text = "\(anNumber)"
            label.font = .systemFont(ofSize: 11, weight: .semibold)
            label.textAlignment = .center
            label.textColor = annotation.appearence.color
            //annotationView.addSubview(label)
            actualAnnotationIcon.addSubview(label)
        } else {
            if let icon = annotation.appearence.iconNamed {
                let img = UIImageView(frame: objectFrame)
                img.contentMode = .scaleAspectFit
                img.image = UIImage(named: icon)
                img.tintColor = annotation.appearence.color // for when sf symbols would be ready
              //  annotationView.addSubview(img)
                actualAnnotationIcon.addSubview(img)
            }
        }
        
        return annotationView
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = Globals.Colors.purpure1
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }
    
}
class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    let identifier:String
    let appearence:Appearence
    
    struct Appearence {
        let iconNamed:String?
        let number:Int?
        var color:UIColor = Globals.Colors.purpure1
    }

    init(title: String?,locationName: String?, discipline: String?, coordinate: CLLocationCoordinate2D, identifier:String, appearence:Appearence) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.identifier = identifier
        self.appearence = appearence
        super.init()
    }

 
    var subtitle: String? {
        return locationName
    }
    
    
}


