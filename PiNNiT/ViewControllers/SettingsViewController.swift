//
//  SettingsViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 11/9/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import MapKit
import CoreLocation
import BLTNBoard
import CoreData

class SettingsViewController: UIViewController, SlideMenuViewControllerDelegate{
    
    @IBOutlet var BlurView: UIVisualEffectView!
    
    var CurUsr = User()
    var MyPins = [Pin()]
    
    @IBOutlet weak var HomeView: UIView!
    @IBOutlet weak var LeadingConstraintMenu: NSLayoutConstraint!
    @IBOutlet weak var BackViewMenu: UIView!
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var MenuButton: UIButton!

    //Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var CoreDataPins:[Pins]?
    var CoreDataUser:[Users]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BlurView.bounds = self.view.bounds
        
        BackViewMenu.isHidden = true

        In(desiredView: BlurView)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
            self.animateOut(desiredView: self.BlurView)
            }
        // Do any additional setup after loading the view.
    }
    func HideMenuView() {
        self.HideMenu()
    }
    
    var SlideMenuViewController:SlideMenuViewController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SlideMenuSegue4")
        {
            if let controller = segue.destination as? SlideMenuViewController
            {
                self.SlideMenuViewController = controller
                self.SlideMenuViewController?.delegate = self
            }
        }
    }
    func setUser(){
        do{
            let req = Users.fetchRequest() as NSFetchRequest<Users>
            let pred = NSPredicate(format: "isActive == YES")
            req.predicate = pred
            let ActiveUser = try context.fetch(req)
            CurUsr.FirstName = ActiveUser[0].firstName!
            CurUsr.LastName = ActiveUser[0].lastName!
            CurUsr.ID = ActiveUser[0].creator!
            CurUsr.Email = ActiveUser[0].email!
            print("ActiveUser:")
            dump(ActiveUser)
            }catch{
            }
            
        }
    func signOutUser(){
        do{
            let req = Users.fetchRequest() as NSFetchRequest<Users>
            let pred = NSPredicate(format: "isActive == YES")
            req.predicate = pred
            let ActiveUser = try context.fetch(req)
            ActiveUser[0].isActive = false
            }catch{
            }
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
    @IBAction func MenuButtonTapped(_ sender: Any) {
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
    func animateOut(desiredView: UIView){
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: {_ in
            desiredView.removeFromSuperview()
        })
    }
    
    func In(desiredView: UIView){
        let backroundView = self.view!
        backroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0.9
        desiredView.center = backroundView.center
        desiredView.layer.cornerRadius = 50
        
    }
    @IBAction func SignOutButtonTapped(_ sender: Any) {
        signOutUser()
        Transition()
        
    }
    func Transition(){
        
        //self.navigationController?.popViewController(animated: true)In(desiredView: BlurView)
        In(desiredView: BlurView)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            self.animateOut(desiredView: self.BlurView)
            let NavVC = self.storyboard?.instantiateViewController(identifier: "NavID") as? UINavigationController
            
            self.view.window?.rootViewController = NavVC
            self.view.window?.makeKeyAndVisible()
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
