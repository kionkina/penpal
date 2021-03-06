//
//  LocationCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/26/21.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    
    static let identifier = "LocationCell"
    @IBOutlet weak var editButton: UIButton!
    var user: User?
    
    var onEditLocationClicked : (()->())?

    @IBAction func didTapImageView(_ sender: UIButton) {
        print("did tap image view", sender)
        self.onEditLocationClicked!()
    }
    
    @IBAction func editLocation(_ sender: UITapGestureRecognizer){
        self.onEditLocationClicked!()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "LocationCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.editButton.isHidden = true

        // Initialization code
    }
    
    func configure(user: User){
        self.user = user
        self.locationLabel.text = user.location
        if user == User.current {
            self.editButton.isHidden = false
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
