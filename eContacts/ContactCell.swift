//
//  ContactCell.swift
//  eContacts
//
//  Created by Miltan on 5/26/18.
//  Copyright © 2018 Milton. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    var VC: ViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let starButton = UIButton()
        let image = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate)
        starButton.setImage(image, for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        starButton.addTarget(self, action: #selector(handleStarButton), for: .touchUpInside)
        
        accessoryView = starButton
    }
    
    func handleStarButton(){
        VC?.callLikeOrDislikeFor(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
