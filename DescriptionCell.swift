//
//  DescriptionCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/26/21.
//

import UIKit

class DescriptionCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIImageView!
    var user: User?
    
    static let identifier = "DescriptionCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DescriptionCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.editButton.isHidden = true
        self.descriptionLabel.text = "Until recently, the prevailing view assumed lorem ipsum was born as a nonsense text. It's not Latin, though it looks like it, and it actually says nothing,Before & After magazine answered a curious reader, Its ‘words’ loosely approximate the frequency with which letters occur in English, which is why at a glance it looks pretty real. As Cicero would put it, Um, not so fast. The placeholder text, beginning with the line “Lorem ipsum dolor sit amet, consectetur adipiscing elit”, looks like Latin because in its youth, centuries ago, it was Latin. Richard McClintock, a Latin scholar from Hampden-Sydney College, is credited with discovering the source behind the ubiquitous filler text. In seeing a sample of lorem ipsum, his interest was piqued by consectetur—a genuine, albeit rare, Latin word. Consulting a Latin dictionary led McClintock to a passage from De Finibus Bonorum et Malorum (“On the Extremes of Good and Evil”), a first-century B.C. text from the Roman philosopher Cicero."
        // Initialization code
    }

    func configure(user: User) {
        self.user = user
        if self.user == User.current {
            self.editButton.isHidden = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
