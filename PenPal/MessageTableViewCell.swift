//
//  MessageTableViewCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/12/21.
//

import UIKit
import FirebaseStorage

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var uid: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2
        // Initialization code
    }

    func configure(name:String, uid: String, profilePic: String){
        self.nameLabel.text = name
        self.uid = uid
        self.imgView.sd_setImage(with: Storage.storage().reference().child("profilephotos").child(profilePic))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
