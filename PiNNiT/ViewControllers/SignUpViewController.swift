//
//  SignUpViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 7/27/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var FirstNameTF: UITextField!
    @IBOutlet weak var LastNameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var ErrorTF: UILabel!
    @IBOutlet weak var Exit: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Help.Hide(ErrorTF)
        Utilities.styleTextField(FirstNameTF)
        Utilities.styleTextField(LastNameTF)
        Utilities.styleTextField(EmailTF)
        Utilities.styleTextField(PasswordTF)
        Utilities.styleFilledButton(SignUpButton)
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
    
    
    @IBAction func ExitButtonTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        /*let MainVC = storyboard?.instantiateViewController(identifier: "MainVC") as? ViewController
        
        view.window?.rootViewController = MainVC
        view.window?.makeKeyAndVisible()*/
    }
    
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        
        //Validate Info
        let error = validateFields()
        if error != nil {
            Help.Show(ErrorTF, error!)
        } else {
            
            let FirstName = FirstNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let LastName = LastNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Email = EmailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Password = PasswordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create User
            Auth.auth().createUser(withEmail: Email, password: Password) { result, err in
                if err != nil {
                    Help.Show(self.ErrorTF, "Error creating user!!!")
                } else {
                    let db = Firestore.firestore()
                    
                    //Add Data
                    db.collection("Users").document(result!.user.uid).setData(["First_Name":FirstName, "Last_Name":LastName, "ID":result!.user.uid, "Email": Email] ) { error in
                        
                        if error != nil
                        {
                            Help.Show(self.ErrorTF, "Error saving user!!!")
                        }
                    }
                    self.Transition()
                }
            }
        }
    }
    
    
    func Transition(){
        
        Help.Hide(ErrorTF)
        
        let LoginVC = storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginViewController
        
        view.window?.rootViewController = LoginVC
        view.window?.makeKeyAndVisible()
    }
    

}
