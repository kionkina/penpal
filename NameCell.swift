//
//  NameCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/26/21.
//

import UIKit

class NameCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifier = "NameCell"
    var user: User?
    
    static func nib() -> UINib {
        return UINib(nibName: "NameCell", bundle: nil)
    }
    
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(user: User) {
        self.user = user
        self.nameLabel.text = "\(self.user!.firstName) \(self.user!.lastName)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
