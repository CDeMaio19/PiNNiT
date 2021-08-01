//
//  LoginViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 7/27/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var ErrorTF: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Help.Hide(ErrorTF)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        
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
                    
                }
                
            }
        }
    }
    
    
    
    
    
}
    
