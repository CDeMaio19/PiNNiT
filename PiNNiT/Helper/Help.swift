//
//  Help.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 7/27/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class Help {
    
    static func Hide(_ label:UILabel) {
        label.alpha = 0
    }
    
    static func Show(_ label:UILabel, _ text:String) {
        label.text = text
        label.alpha = 1
    }
    
    static func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isValidEmail(_ testStr : String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    /*static func GetData() -> String
    {
        let db = Firestore.firestore()
        let UID = getUID()
        
        let docRef = db.collection("Users").document(UID).getDocument { Doc, error in
            
            if error == nil
            {
                if Doc != nil && Doc!.exists
                {
                    let DocData = Doc!.data()
                    let FN = DocData?["FirstName"] as? String ?? ""
                    
                    //return FN
                    
                }
            }
        }
        return ""
    }*/
    
    /*static func Transition(_ GoingVC : String, _ VCC : UIViewController){
        
        let GoingVC = storyboard?.instantiateViewController(identifier: GoingVC) as? VCC
        
        view.window?.rootViewController = HomeVC
        view.window?.makeKeyAndVisible()
    }*/
    
    /*func SetData(){
        let db = Firestore.firestore()
        let UID = getUID()
        
        let docRef = db.collection("Users").document(UID).getDocument { Doc, error in
            
            if error == nil
            {
                if Doc != nil && Doc!.exists
                {
                    let DocData = Doc!.data()
                    DocData["FirstName"] as
                }
            }
        }
    }*/
    
    static func getUID() -> String {
        let user = Auth.auth().currentUser
        if let user = user {
          return user.uid
        }
        return "Can't fetch user data."
    }
    
    /*static func getData(_ AUser : User) -> User{
        let db = Firestore.firestore()
        let UID = getUID()
        
        db.collection("Users").document(UID).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                AUser.FirstName = document.get("First_Name") as? String ?? ""
                print(AUser.FirstName)
            } else {
                print("Document does not exist")

            }
        }
       
        print("AUser:", AUser.FirstName)
        return AUser
        
        }
        
    } */


}
