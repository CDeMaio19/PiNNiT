//
//  ViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 7/25/21.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Utilities.styleHollowButton(LoginButton)
        Utilities.styleFilledButton(SignUpButton)
    }
    
   
    
    


}

