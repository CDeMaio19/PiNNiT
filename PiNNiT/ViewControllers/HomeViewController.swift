//
//  HomeViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 7/27/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit
import CoreLocation

class HomeViewController: UIViewController, SlideMenuViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var TopMenu: UIStackView!
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var NavButton: UIButton!
    @IBOutlet weak var PinButton: UIButton!
    @IBOutlet weak var PinConfirmView: UIStackView!
    @IBOutlet weak var TopPinConfirmConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var BottomNav: UIStackView!
    @IBOutlet weak var MyPinsButton: UIButton!
    @IBOutlet weak var FriendsPinButton: UIButton!
    @IBOutlet weak var WorldPinsButton: UIButton!
    @IBOutlet weak var CenterPin: UIImageView!
    
    
    @IBOutlet weak var HomeView: UIView!
    @IBOutlet weak var LeadingConstraintMenu: NSLayoutConstraint!
    @IBOutlet weak var BackViewMenu: UIView!
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var MenuButton: UIButton!
    var CurUsr = User()
    var MPB = 1
    var FPB = 0
    var WPB = 0
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        
        MapView.delegate = self
        
        BottomMenuState()
        
        BackViewMenu.isHidden = true
        TopMenu.layer.cornerRadius = 30
        BottomNav.layer.cornerRadius = 25
        PinConfirmView.layer.cornerRadius = 10
        PinConfirmView.isHidden = true
        
        let db = Firestore.firestore()
        let UID = Help.getUID()
        
        db.collection("Users").document(UID).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.CurUsr.FirstName = document.get("First_Name") as? String ?? ""
                self.CurUsr.LastName = document.get("Last_Name") as? String ?? ""
                self.CurUsr.ID = document.get("ID") as? String ?? ""
                self.CurUsr.Email = document.get("Email") as? String ?? ""
                //self.Datafill()
            } else {
                print("Document does not exist")
            }
        }
        
        
        
        
        
        
    }
    
    var SlideMenuViewController:SlideMenuViewController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SlideMenuSegue")
        {
            if let controller = segue.destination as? SlideMenuViewController
            {
                self.SlideMenuViewController = controller
                self.SlideMenuViewController?.delegate = self
            }
        }
    }
    func HideMenuView() {
        self.HideMenu()
        
    }
    private func HideMenu() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.LeadingConstraintMenu.constant = 10
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.2, animations: {
                self.LeadingConstraintMenu.constant = -150
                self.view.layoutIfNeeded()
            }) {(status) in
                self.BackViewMenu.isHidden = true
            }
            
        }
        self.HomeView.alpha = 1
        
    }
    
    @IBAction func MenuButtonPushed(_ sender: Any) {
        
        self.BackViewMenu.isHidden = false
        self.HomeView.alpha = 0.5
        UIView.animate(withDuration: 0.2, animations: {
            self.LeadingConstraintMenu.constant = 10
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.2, animations: {
                self.LeadingConstraintMenu.constant = 0
                self.view.layoutIfNeeded()
            }) {(status) in
                
                
            }
            
        }
       
        
    }
    @IBAction func DismissMenuByTap(_ sender: Any) {
        self.HideMenu()
    }
    
    //Bottom Menu Functions
    @IBAction func FreindsButtonViewPressed(_ sender: Any) {
        MPB = 0
        FPB = 1
        WPB = 0
        BottomMenuState()
    }
    @IBAction func MyButtonViewPressed(_ sender: Any) {
        MPB = 1
        FPB = 0
        WPB = 0
        BottomMenuState()
    }
    @IBAction func WorldButtonViewPressed(_ sender: Any) {
        MPB = 0
        FPB = 0
        WPB = 1
        BottomMenuState()
    }
    
    func BottomMenuState(){
        if (MPB == 1){
            MyPinsButton.backgroundColor = UIColor.init(red: 0/255, green: 49/255, blue: 54/255, alpha: 1)
            MyPinsButton.layer.cornerRadius = 25.0
        } else
        {
            MyPinsButton.backgroundColor = UIColor.clear
        }
        if (FPB == 1){
            FriendsPinButton.backgroundColor = UIColor.init(red: 0/255, green: 49/255, blue: 54/255, alpha: 1)
            FriendsPinButton.layer.cornerRadius = 25.0
        } else
        {
            FriendsPinButton.backgroundColor = UIColor.clear
        }
        if (WPB == 1){
            WorldPinsButton.backgroundColor = UIColor.init(red: 0/255, green: 49/255, blue: 54/255, alpha: 1)
            WorldPinsButton.layer.cornerRadius = 25.0
        } else
        {
            WorldPinsButton.backgroundColor = UIColor.clear
        }
    }
    
    //Map Functions
    func ShowConfirmButtons(){
        self.PinConfirmView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.TopPinConfirmConstraint.constant = 71
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.2, animations: {
                self.TopPinConfirmConstraint.constant = 61
                self.view.layoutIfNeeded()
            }) {(status) in
                
                
            }
            
        }
    }
    func HideConfirmButtons(){
        UIView.animate(withDuration: 0.2, animations: {
            self.TopPinConfirmConstraint.constant = 71
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.2, animations: {
                self.TopPinConfirmConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) {(status) in
                self.PinConfirmView.isHidden = true
            }
            
        }
        
    }
    @IBAction func NavButtonClicked(_ sender: Any) {
        mapIsReady()
        CenterPin.isHidden = true
        HideConfirmButtons()
    }
    @IBAction func PinButtonClicked(_ sender: Any) {
        if (CenterPin.isHidden == true)
        {
            CenterPin.isHidden = false
        } else {
            CenterPin.isHidden = true
        }
        if (PinConfirmView.isHidden == true)
        {
         ShowConfirmButtons()
        } else {
            HideConfirmButtons()
        }
        
    }
    func centerOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            MapView.setRegion(region, animated: true)
        }
    }
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapIsReady()
            break
        case .denied:
            //Turn On Permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //Turn On Permissions
            break
        case .authorizedAlways:
            mapIsReady()
            break
        }
    }
    
    func mapIsReady(){
        MapView.showsUserLocation = true
        centerOnUserLocation()
        //locationManager.startUpdatingLocation()
    }
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Location Services Not On!!!
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        MapView.setRegion(region, animated: true)
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
