//
//  SlideMenuViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 8/8/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol SlideMenuViewControllerDelegate {
    func HideMenuView()
}

class SlideMenuViewController: UIViewController {
    
    var delegate : SlideMenuViewControllerDelegate?
    
    @IBOutlet weak var TopView: UIStackView!
    @IBOutlet weak var MenuView: UIStackView!
    
    @IBOutlet weak var ExitButton: UIButton!
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var HomeButton: UIButton!
    @IBOutlet weak var PlacesButton: UIButton!
    @IBOutlet weak var FreindsButton: UIButton!
    @IBOutlet weak var SettingButton: UIButton!
    
    var CurUsr = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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
                self.setupSlideMenu()
            } else {
                print("Document does not exist")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    private func setupSlideMenu()
    {
        
        self.TopView.layer.cornerRadius = 10
        self.TopView.clipsToBounds = true
        
        
        
        self.NameLabel.text = "     "+CurUsr.FirstName+" "+CurUsr.LastName+"   "
        
    }
    @IBAction func ExitButtonTapped(_ sender: Any) {
        self.delegate?.HideMenuView()
        print("Exit: ", self.delegate ?? "")
    }
    
    @IBAction func HomeButtonTapped(_ sender: Any) {
        if String(self.delegate.debugDescription).contains("PiNNiT.HomeViewController")
        {
            self.delegate?.HideMenuView()
        } else {
            self.delegate?.HideMenuView()
            let HomeVC = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
            
            view.window?.rootViewController = HomeVC
            view.window?.makeKeyAndVisible()
        }
    }
    @IBAction func PlacesButtonTapped(_ sender: Any) {
        if String(self.delegate.debugDescription).contains("PiNNiT.MyPinsViewController")
        {
            self.delegate?.HideMenuView()
        } else {
        self.delegate?.HideMenuView()
        let PinsVC = storyboard?.instantiateViewController(identifier: "MyPinsVC") as? MyPinsViewController
        
        view.window?.rootViewController = PinsVC
        view.window?.makeKeyAndVisible()
        }
    }
    @IBAction func FreindsButtonTapped(_ sender: Any) {
        if String(self.delegate.debugDescription).contains("PiNNiT.MyFriendsViewController")
        {
            self.delegate?.HideMenuView()
        } else {
        self.delegate?.HideMenuView()
        let FriendsVC = storyboard?.instantiateViewController(identifier: "MyFriendsVC") as? MyFriendsViewController
        
        view.window?.rootViewController = FriendsVC
        view.window?.makeKeyAndVisible()
        }
    }
    @IBAction func settingButtonTapped(_ sender: Any) {
        if String(self.delegate.debugDescription).contains("PiNNiT.SettingsViewController")
        {
            self.delegate?.HideMenuView()
        } else {
        self.delegate?.HideMenuView()
        let SettingsVC = storyboard?.instantiateViewController(identifier: "SettingsVC") as? SettingsViewController
        
        view.window?.rootViewController = SettingsVC
        view.window?.makeKeyAndVisible()
        }
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
