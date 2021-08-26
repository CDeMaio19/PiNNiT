//
//  MyPinsViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 8/25/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import MapKit
import CoreLocation

class MyPinsViewController: UIViewController, SlideMenuViewControllerDelegate{
    
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet var BlurView: UIVisualEffectView!
    
    var CurUsr = User()
    var MyPins = [Pin()]
    var PinCount = 0
    
    @IBOutlet weak var HomeView: UIView!
    @IBOutlet weak var LeadingConstraintMenu: NSLayoutConstraint!
    @IBOutlet weak var BackViewMenu: UIView!
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var MenuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView.delegate = self
        //TableView.dataSource = self
        BlurView.bounds = self.view.bounds
        
        BackViewMenu.isHidden = true

        let db = Firestore.firestore()
        let UID = Help.getUID()
        
        db.collection("Users").document(UID).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //print("Document data: \(dataDescription)")
                self.CurUsr.FirstName = document.get("First_Name") as? String ?? ""
                self.CurUsr.LastName = document.get("Last_Name") as? String ?? ""
                self.CurUsr.ID = document.get("ID") as? String ?? ""
                self.CurUsr.Email = document.get("Email") as? String ?? ""
                //self.Datafill()
            } else {
                print("Document does not exist")
            }
        }
        In(desiredView: BlurView)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
            self.animateOut(desiredView: self.BlurView)
            self.GetDataFromFirebase()
            print("Pincount:" ,self.PinCount)
        }
    }
    
    func animateOut(desiredView: UIView){
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: {_ in
            desiredView.removeFromSuperview()
        })
    }
    func GetDataFromFirebase(){
        let db = Firestore.firestore()
        let docref = db.collection("Users").document(CurUsr.ID).collection("MyPins")
            docref.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let geopoint = document.get("Location") as! GeoPoint
                        let location = CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)
                        //print(location)
                        
                        self.MyPins.append(Pin(name: document.get("Name") as? String ?? "", address: document.get("Address") as? String ?? "", location: location, tag: document.get("Tag") as? String ?? "", privacy: document.get("Public") as? Bool ?? true, Id: document.get("Creator") as? String ?? ""))
                        self.PinCount = Int(document.documentID)!
                        
                        print("pulled data")
                        dump(self.MyPins)
                        print("Array size: ",self.MyPins.count)
                        print("Amount of Pins: ", self.MyPins.count - 1)
                        let pin = MKPointAnnotation()
                        pin.coordinate = location
                        pin.title = document.get("Name") as? String ?? ""
                        pin.subtitle = document.get("Address") as? String ?? ""
                    }
                }
            }
            PinCount = PinCount-1
        }
    func DeleteDataFirebase(){
        let db = Firestore.firestore()
        let docref = db.collection("Users").document(CurUsr.ID).collection("MyPins")
            
            docref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print(document.documentID)
                    docref.document(document.documentID).delete()
                }
            }
        }
    }
    func AddDataToFirebase(){
        let db = Firestore.firestore()
        var Pins = 0
        var I = 0
        //DeleteDataFirebase()
        while Pins != PinCount
        {
            //Add Data
            I = Pins+1
            db.collection("Users").document(CurUsr.ID).collection("MyPins").document(I.description).setData(["Name":MyPins[I].Name, "Address":MyPins[I].Address, "Location":MyPins[I].Location, "Tag":MyPins[I].Tag, "Public":MyPins[I].Public, "Creator":CurUsr.ID] ) { error in
                
                if error != nil
                {
                    print("Error saving users Pins!!!")
                }
                
                
            }
            
            Pins=Pins+1
        }
    }
    func In(desiredView: UIView){
        let backroundView = self.view!
        backroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0.9
        desiredView.center = backroundView.center
        desiredView.layer.cornerRadius = 50
        
    }
    //Side Menu
    var SlideMenuViewController:SlideMenuViewController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SlideMenuSegue2")
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
            self.HomeView.alpha = 1
        }
       
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
