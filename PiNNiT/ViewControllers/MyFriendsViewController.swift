//
//  MyFriendsViewController.swift
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
import CoreData

class MyFriendsViewController: UIViewController, SlideMenuViewControllerDelegate{
    
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet var BlurView: UIVisualEffectView!
    
    var CurUsr = User()
    var MyPins = [Pin()]
    
    @IBOutlet weak var HomeView: UIView!
    @IBOutlet weak var LeadingConstraintMenu: NSLayoutConstraint!
    @IBOutlet weak var BackViewMenu: UIView!
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var MenuButton: UIButton!
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }*/
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var CoreDataPins:[Pins]?
    var CoreDataUser:[Users]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BlurView.bounds = self.view.bounds
        
        BackViewMenu.isHidden = true

        In(desiredView: BlurView)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
            self.fetchCoreData()
            self.setUser()
            self.animateOut(desiredView: self.BlurView)
            }
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(FriendsPop), name: NSNotification.Name(rawValue: "Friends"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        printFriends()
    }
    func printFriends(){
        do{
        let req = Users.fetchRequest() as NSFetchRequest<Users>
        let pred = NSPredicate(format: "isActive == YES")
        req.predicate = pred
        let ActiveUser = try context.fetch(req)
        print("Friends: ")
            dump(ActiveUser[0].freinds?.count)
        }catch{
            
        }
        
    }
    @objc func loadList(notification: NSNotification){
        In(desiredView: BlurView)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            self.fetchCoreData()
            self.TableView.reloadData()
            self.animateOut(desiredView: self.BlurView)
            }
    }
    func loadUserPins(){
        dump(CoreDataPins)
        var i = 0
        for element in CoreDataPins! {
            if element.creator != CurUsr.ID {
                CoreDataPins!.remove(at: i)
                i=i-1
            }else{
            }
            i=i+1
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
            }catch{
            }
            
        }
    func refresh(){
            self.fetchCoreData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    func saveCoreData() {
        do {
            try self.context.save()
        } catch{
            
        }
    }
    func fetchCoreData() {
        do{
            self.CoreDataPins = try context.fetch(Pins.fetchRequest())
            self.CoreDataUser = try context.fetch(Users.fetchRequest())
        } catch {
            
        }
        
    }
    func HideMenuView() {
        self.HideMenu()
        print("exit")
    }
    
    var SlideMenuViewController:SlideMenuViewController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SlideMenuSegue3")
        {
            if let controller = segue.destination as? SlideMenuViewController
            {
                self.SlideMenuViewController = controller
                self.SlideMenuViewController?.delegate = self
            }
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
    @IBAction func AddFriendButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Friends"), object: nil)
    }
    @objc func FriendsPop(_notification : Notification) {
        let alert = UIAlertController(title: "Add Friend?", message: "Enter email.", preferredStyle: .alert)
        alert.addTextField()
        let textfield = alert.textFields![0]
        textfield.placeholder = "someone@company.com"
        let DoneButton = UIAlertAction(title: "Add", style: .default) {(action) in
            let friendEmail = textfield.text
            do{
            let req = Users.fetchRequest() as NSFetchRequest<Users>
                let pred = NSPredicate(format: "email LIKE[cd] %@", friendEmail!)
            req.predicate = pred
                let PotentalUser = try self.context.fetch(req)
                if (PotentalUser.count > 0){
                    if (PotentalUser[0].email != self.CurUsr.Email){
                print("Name: ", PotentalUser[0].firstName)
                self.saveCoreData()
                    let alert = UIAlertController(title: PotentalUser[0].firstName! + " Found.", message: "Added to friends.", preferredStyle: .alert)
                    let OkayButton = UIAlertAction(title: "Okay", style: .default)
                    alert.addAction(OkayButton)
                    self.present(alert, animated: true, completion: nil)
                        self.addFriend(FirstName: PotentalUser[0].firstName!, LastName: PotentalUser[0].lastName!, Email: PotentalUser[0].email!, ID: PotentalUser[0].creator!)
                    } else {
                        let alert = UIAlertController(title: "User Not Found.", message: "Try again.", preferredStyle: .alert)
                        let OkayButton = UIAlertAction(title: "Okay", style: .default)
                        alert.addAction(OkayButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else{
                    let alert = UIAlertController(title: "User Not Found.", message: "Try again.", preferredStyle: .alert)
                    let OkayButton = UIAlertAction(title: "Okay", style: .default)
                    alert.addAction(OkayButton)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            catch {
                
        }
            self.refresh()
        }
        alert.addAction(DoneButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func addFriend(FirstName: String, LastName: String, Email: String, ID: String){
        do{
        let Friend = Friends(context: context)
            Friend.name = FirstName + " " + LastName
            Friend.email = Email
            Friend.friendID = ID
        let req = Users.fetchRequest() as NSFetchRequest<Users>
        let pred = NSPredicate(format: "isActive == YES")
        req.predicate = pred
        let ActiveUser = try context.fetch(req)
            if (ActiveUser[0].freinds!.count > 0){
                print("More than 1")
                if((ActiveUser[0].freinds?.contains(Friend.email)) != nil){
                    print("Found")
                    self.dismiss(animated: true, completion: {
                        let alert = UIAlertController(title: "Friend Already Added!", message: "Cannot add friend.", preferredStyle: .alert)
                        let OkayButton = UIAlertAction(title: "Okay", style: .default)
                        alert.addAction(OkayButton)
                         self.present(alert, animated: true, completion: nil)
                    })
                    
                } else {
                    ActiveUser[0].addToFreinds(Friend)
                    print("Friends: ")
                    dump(ActiveUser[0].freinds?.count)
                    saveCoreData()
                }
            }else{
            ActiveUser[0].addToFreinds(Friend)
            print("Friends: ")
            dump(ActiveUser[0].freinds?.count)
            saveCoreData()
            }
        }catch{
            
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
