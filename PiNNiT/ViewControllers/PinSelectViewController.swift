//
//  PinSelectViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 11/16/21.
//

import UIKit
import CoreData

protocol PinSelectViewDelegate {
    func HidePinSelect()
    func MakePinInabbled()
    func MakePinEnabbled()
}

class PinSelectViewController: UIViewController {
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var OwnerEditText: UITextField!
    @IBOutlet weak var AddressEditText: UITextField!
    @IBOutlet weak var NameEditText: UITextField!
    @IBOutlet weak var TagButton: UIButton!
    @IBOutlet weak var PublicButton: UIButton!
    
    var delegate : PinSelectViewDelegate?
    var CoreDataPins:[Pins]?
    var CoreDataUser:[Users]?
    var CurUsr = User()
    var FriendUser = User()
    var MePin = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchCoreData()
        self.setData()
        self.setUser()
        
        
    }

    @IBAction func TagButtonTapped(_ sender: Any) {
    }
    @IBAction func PublicButtonTapped(_ sender: Any) {
        //Make Private
    }
    @IBAction func SaveButtonTapped(_ sender: Any) {
        
    }
    @IBAction func ExitButonTapped(_ sender: Any) {
        self.delegate?.HidePinSelect()
        print("Exit: ", self.delegate ?? "")
    }
    func fetchCoreData() {
        do{
            self.CoreDataPins = try context.fetch(Pins.fetchRequest())
            self.CoreDataUser = try context.fetch(Users.fetchRequest())
            //self.loadUserPins()
        } catch {
            
        }
        
    }
    func saveCoreData() {
        do {
            try self.context.save()
        } catch{
            
        }
    }
    func makePinInfoEdditable(){
        NameEditText.isUserInteractionEnabled = true
        AddressEditText.isUserInteractionEnabled = false
        TagButton.isUserInteractionEnabled = true
        PublicButton.isUserInteractionEnabled = true
        OwnerEditText.isUserInteractionEnabled = false
    }
    func PinInfoNotEdittable(){
        NameEditText.isUserInteractionEnabled = false
        AddressEditText.isUserInteractionEnabled = false
        TagButton.isUserInteractionEnabled = false
        PublicButton.isUserInteractionEnabled = false
        OwnerEditText.isUserInteractionEnabled = false
    }
    func GetNameOfOwner(ID: String){
        do{
        let req = Users.fetchRequest() as NSFetchRequest<Users>
        let pred = NSPredicate(format: "creator == %@", ID)
        req.predicate = pred
        let Owner = try context.fetch(req)
        FriendUser.FirstName = Owner[0].firstName!
        FriendUser.LastName = Owner[0].lastName!
        
            OwnerEditText.text = FriendUser.FirstName + " " + FriendUser.LastName
            
            SaveButton.setTitle("Save "+FriendUser.FirstName+"'s Pin", for: .normal)
        
        }catch{
        }
    }
    func setData(){
        for element in CoreDataPins! {
            if (element.view == true){
                NameEditText.text = element.name
                AddressEditText.text = element.address
                TagButton.setTitle(element.tag?.description, for: .normal)
                PublicButton.setTitle("No", for: .normal)
                if (CurUsr.ID == element.creator){
                    OwnerEditText.text = "Me"
                    makePinInfoEdditable()
                    self.delegate?.MakePinEnabbled()
                    MePin = true
                }else{
                    PinInfoNotEdittable()
                    GetNameOfOwner(ID: element.creator!)
                    self.delegate?.MakePinInabbled()
                    MePin = false
                }
                
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
