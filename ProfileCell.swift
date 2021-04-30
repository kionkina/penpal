//
//  ProfileCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/26/21.
//

import UIKit
import FirebaseStorage
import FirebaseUI

class ProfileCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    var user:User?

    
    static let identifier = "ProfileCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(user: User){
        self.user = user
        self.imageView!.sd_setImage(with: Storage.storage().reference().child("profilephotos").child("default.png"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
