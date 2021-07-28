//
//  SignUpViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 7/27/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var FirstNameTF: UITextField!
    @IBOutlet weak var LastNameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var ErrorTF: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Help.Hide(ErrorTF)
        // Do any additional setup after loading the view.
    }
    

    func validateFields() -> String? {
        
        //Check if Blank
        if FirstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || LastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill all fields!!!"
        }
        //Check Password
        let Password = PasswordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Help.isPasswordValid(Password) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number!!!"
        }
        //Check Email
        let Email = EmailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Help.isValidEmail(Email) == false {
            return "Invalid email!!!"
        }
        return nil
    }
    
    
    
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        
        //Validate Info
        let error = validateFields()
        if error != nil {
            Help.Show(ErrorTF, error!)
        } else {
            
            //Create User
            Auth.auth().createUser(withEmail: <#T##String#>, password: <#T##String#>) { result, err in
                if err != nil {
                    Help.Show(self.ErrorTF, "Error creating user!!!")
                } else {
                    
                }
            }
            
            // Transition
            
            
        }
    }
    

}
