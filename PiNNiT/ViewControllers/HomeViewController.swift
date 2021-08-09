//
//  HomeViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 7/27/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController, SlideMenuViewControllerDelegate {

    @IBOutlet weak var HomeView: UIView!
    @IBOutlet weak var LeadingConstraintMenu: NSLayoutConstraint!
    @IBOutlet weak var BackViewMenu: UIView!
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var MenuButton: UIButton!
    var CurUsr = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BackViewMenu.isHidden = true
        
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
                self.HomeView.alpha = 1
            }
            
        }
        
    }
    
    @IBAction func MenuButtonPushed(_ sender: Any) {
        
        self.BackViewMenu.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.LeadingConstraintMenu.constant = 10
            self.view.layoutIfNeeded()
            self.HomeView.alpha = 0.4
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
