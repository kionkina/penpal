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
    @IBOutlet weak var editButton: UIImageView!
    var onEditPfpClicked : (()->())?
    
    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        print("did tap image view", sender)
        self.onEditPfpClicked!()
    }
    
    static let identifier = "ProfileCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        super.awakeFromNib()
        self.editButton.isHidden = true
        self.imgView!.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        tapGesture.delegate = self
        editButton.addGestureRecognizer(tapGesture)
        
        self.imgView.clipsToBounds = true
        //self.imgView.contentMode = .scaleAspectFit
        self.imgView.contentMode = .scaleToFill
        
        // Initialization code
    }
    
    func configure(user: User){
        self.user = user
        
        self.imgView.sd_setImage(with: Storage.storage().reference().child("profilephotos").child("default.png"))
        
        if user == User.current {
            print("show img edit button")
            self.editButton.isHidden = false
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
