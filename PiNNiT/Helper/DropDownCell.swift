//
//  DropDownCell.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 8/13/21.
//

import UIKit

class DropDownCell: UITableViewCell {
    
    let TitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    } ()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(TitleLabel)
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        TitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
