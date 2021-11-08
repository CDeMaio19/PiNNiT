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
import CoreData

class MyPinsViewController: UIViewController, SlideMenuViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, PinsViewCellDelegate{
    
    
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
    
    //Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var CoreDataPins:[Pins]?
    var CoreDataUser:[Users]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PinsViewCell", bundle: nil)
        TableView.register(nib, forCellReuseIdentifier: "PinsViewCell")
        TableView.delegate = self
        TableView.dataSource = self
        
        BlurView.bounds = self.view.bounds
        
        BackViewMenu.isHidden = true
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deletePop), name: NSNotification.Name(rawValue: "delete"), object: nil)
        
        In(desiredView: BlurView)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
            self.fetchCoreData()
            self.setUser()
            self.TableView.reloadData()
            self.animateOut(desiredView: self.BlurView)
            }
        
    }
    
    @objc func deletePop() {
        let alert = UIAlertController(title: "Delete Pin", message: "Are you sure?", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Yes", style: .default) {(action) in
            
        }
        let noButton = UIAlertAction(title: "No", style: .default) {(action) in
            return
        }
        alert.addAction(yesButton)
        alert.addAction(noButton)
        self.present(alert, animated: true, completion: nil)
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
        
    @objc func loadList(notification: NSNotification){
        In(desiredView: BlurView)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            self.fetchCoreData()
            self.TableView.reloadData()
            self.animateOut(desiredView: self.BlurView)
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
    func deletePin(PinNumber: Int, PinName: String, PinAddress: String){
        print("Delete: ",PinNumber, " ", PinName, " ", PinAddress)
        
        //Find Item
        do{
        let req = Pins.fetchRequest() as NSFetchRequest<Pins>
        let pred = NSPredicate(format: "(name CONTAINS %@) AND (address CONTAINS %@)", PinName, PinAddress)
        req.predicate = pred
            
        let delPin = try context.fetch(req)
        dump(delPin[0])
        self.context.delete(delPin[0])
        saveCoreData()
            
        }
        catch {
            
    }
        refresh()
    }
    func delete(Pin: Int, PinName: String, PinAddress: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "delete"), object: nil)
        self.deletePin(PinNumber: Pin, PinName: PinName, PinAddress: PinAddress)
    }
    
    func refresh(){
            self.fetchCoreData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    //CoreData
    func fetchCoreData() {
        do{
            self.CoreDataPins = try context.fetch(Pins.fetchRequest())
            self.CoreDataUser = try context.fetch(Users.fetchRequest())
        } catch {
            
        }
        
    }
    
    func saveCoreData() {
        do {
            try self.context.save()
        } catch{
            
        }
    }
    
    func AddCoreData(name: String, address: String, lat: Double, long: Double, tag: String,view: Bool,Id: String){
        let NewCorePin = Pins(context: self.context)
        NewCorePin.name = name
        NewCorePin.address = address
        NewCorePin.lat = lat
        NewCorePin.lon = long
        NewCorePin.tag = tag
        NewCorePin.view = view
        NewCorePin.creator = Id
        
        self.saveCoreData()
        
        self.fetchCoreData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.fetchCoreData()
        self.loadUserPins()
        return (CoreDataPins!.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinsViewCell", for: indexPath) as! PinsViewCell
        cell.NameET.text = CoreDataPins![(indexPath.row)].name
        cell.AddressET.text = CoreDataPins![(indexPath.row)].address
        cell.TagButton.setTitle(CoreDataPins![(indexPath.row)].tag, for: .normal)
        if (CoreDataPins![(indexPath.row)].view == true){
            cell.PublicButton.setTitle("Make Private", for: .normal)
        } else {
        cell.PublicButton.setTitle("Make Public", for: .normal)
        }
        cell.PinIDLabel.text = String(indexPath.row)
        //dump(cell)
        return cell
        
        
    }
}
