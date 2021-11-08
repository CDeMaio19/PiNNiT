//
//  LoginViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 7/27/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var ErrorTF: UILabel!
    @IBOutlet weak var Back: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Help.Hide(ErrorTF)
        Utilities.styleTextField(EmailTF)
        Utilities.styleTextField(PasswordTF)
        Utilities.styleFilledButton(LoginButton)
        setUserAndPass()
        // Do any additional setup after loading the view.
    }
    
    func saveCoreData() {
        do {
            try self.context.save()
        } catch{
            
        }
    }
    
    func setUserAndPass(){
        do{
            let req = Users.fetchRequest() as NSFetchRequest<Users>
            let pred = NSPredicate(format: "isActive == YES")
            req.predicate = pred
            let ActiveUser = try context.fetch(req)
            print("ActiveUser:")
            dump(ActiveUser)
            if ActiveUser.count >= 1 {
            if ActiveUser[0].isActive == true {
                EmailTF.text = ActiveUser[0].email
                PasswordTF.text = ActiveUser[0].password
            }
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
    @IBAction func BackButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func ValidateFields() -> String? {
        
        //Check if Blank
        if  EmailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill all fields!!!"
        }
        return nil
        
    }
    
    func TransitionHome(){
        
        let HomeVC = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
        
        view.window?.rootViewController = HomeVC
        view.window?.makeKeyAndVisible()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func LoginButtonTapped(_ sender: Any) {
        
        //Login Need!!!!
        let error = ValidateFields()
        if error != nil {
            Help.Show(ErrorTF, error!)
        } else {
            
            let Email = EmailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Password = PasswordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: Email, password: Password) { result, error in
                
                if error != nil{
                    Help.Show(self.ErrorTF, "Invalid Email or Password")
                } else {
                    self.TransitionHome()
                    do{
                        let req = Users.fetchRequest() as NSFetchRequest<Users>
                        let pred = NSPredicate(format: "email CONTAINS %@", Email)
                        req.predicate = pred
                        let UserA = try self.context.fetch(req)
                        UserA[0].isActive = true
                        self.saveCoreData()
                        
                        do{
                            let req = Users.fetchRequest() as NSFetchRequest<Users>
                            let pred = NSPredicate(format: "isActive == YES")
                            req.predicate = pred
                            let ActiveUser = try self.context.fetch(req)
                            print("ActiveUser:")
                            dump(ActiveUser)
                            if ActiveUser.count > 1 {
                            if ActiveUser[0].isActive == true {
                                ActiveUser[0].isActive = false
                                self.saveCoreData()
                            }
                            }
                            }catch{
                            }
                        
                    }
                    catch {
                    }
                    }
                
            }
        }
        
        //Skip Login
        /*let HomeVC = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
        
        view.window?.rootViewController = HomeVC
        view.window?.makeKeyAndVisible()*/
        //
    }
    
    
    
    
    
}
    
