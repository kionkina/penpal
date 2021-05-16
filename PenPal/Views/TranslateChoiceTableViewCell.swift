//
//  TranslateChoiceTableViewCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/6/21.
//

import UIKit

class TranslateChoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    var name: String?
    var code: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    
    func configure(name: String, code: String) {
        self.name = name
        self.code = code
        self.nameLabel.text = name
        self.codeLabel.text = "(\(code))"
    }

}
