//
//  MessageCell.swift
//  10-ChatApp
//
//  Created by Juan Gabriel Gomila Salas on 06/08/2018.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nessageBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.nessageBackground.layer.cornerRadius = 8.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
