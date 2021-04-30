//
//  LanguageLabelCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/26/21.
//

import UIKit

class LanguageLabelCell: UITableViewCell {

    static let identifier = "LanguageLabelCell"
    
    @IBOutlet weak var editSpeaksButton: UIButton!
    @IBOutlet weak var editLearningButton: UIButton!
    var user: User?
    
    var onEditSpeaksClicked : (()->())?
    var onEditLearningClicked : (()->())?

    @IBAction func editSpeaks(){
        self.onEditSpeaksClicked!()
    }
    
    @IBAction func editLearns(){
        self.onEditLearningClicked!()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "LanguageLabelCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.editLearningButton.isHidden = true
        self.editSpeaksButton.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(user: User) {
        self.user = user
        if (self.user == User.current) {
            self.editLearningButton.isHidden = false
            self.editSpeaksButton.isHidden = false
        }
    }
    
}
