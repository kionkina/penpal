//
//  DescriptionCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/26/21.
//

import UIKit

class DescriptionCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    var user: User?
    
    static let identifier = "DescriptionCell"
    
    var onEditDescriptionClicked : (()->())?
    
    @IBAction func didTapImageView1(_ sender: Any) {
        print("did tap image view", sender)
        onEditDescriptionClicked!()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "DescriptionCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.editButton.isHidden = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView1(_:)))
        gesture.delegate = self
        self.editButton.addGestureRecognizer(gesture)
        
        // Initialization code
    }

    func configure(user: User) {
        self.user = user
        if self.user == User.current {
            self.editButton.isHidden = false
        }
        self.descriptionLabel.text = user.desc
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
