//
//  PinsViewCell.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 8/26/21.
//

import UIKit

protocol PinsViewCellDelegate {
    func delete(Pin: Int, PinName: String, PinAddress: String)
}

class PinsViewCell: UITableViewCell{
    var delegate : PinsViewCellDelegate?
    @IBOutlet weak var NameET: UITextField!
    @IBOutlet weak var AddressET: UITextField!
    @IBOutlet weak var TagButton: UIButton!
    @IBOutlet weak var PublicButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var PinIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = MyPinsViewController()
        // Initialization code
    }
    @IBAction func TagButtonTapped(_ sender: Any) {
        
    }
    @IBAction func PublicButtonTapped(_ sender: Any) {
        if (PublicButton.title(for: .normal)! == "Make Public"){
            PublicButton.setTitle("Make Private", for: .normal)
        } else {
        PublicButton.setTitle("Make Public", for: .normal)
        }
    }
    @IBAction func DeleteButtonTapped(_ sender: Any) {
        let PinNumber:Int? = Int(PinIDLabel.text!)
        self.delegate?.delete(Pin: 0, PinName: NameET.text!, PinAddress: AddressET.text!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func DidEndNameEdit(_ sender: Any) {
        print("Editing Done......")
        self.delegate?.delete(Pin: 1, PinName: NameET.text!, PinAddress: AddressET.text!)
    }
    
}
