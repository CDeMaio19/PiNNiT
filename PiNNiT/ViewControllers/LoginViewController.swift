//
//  LoginViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 7/27/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var ErrorTF: UILabel!
    @IBOutlet weak var Back: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Help.Hide(ErrorTF)
        Utilities.styleTextField(EmailTF)
        Utilities.styleTextField(PasswordTF)
        Utilities.styleFilledButton(LoginButton)
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
        /*let error = ValidateFields()
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
        }*/
        
        //Skip Login
        let HomeVC = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
        
        view.window?.rootViewController = HomeVC
        view.window?.makeKeyAndVisible()
        //
    }
    
    
    
    
    
}
    
