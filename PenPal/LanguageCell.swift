//
//  LanguageCell.swift
//  Translate
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if self.isSelected {
            self.accessoryType = .checkmark
        } else {
            self.accessoryType = .none
        }
       
    }

    
    
    func configure(name: String, imgUrl: String) {
        //self.accessoryType = isSelected ? .checkmark : .none
        self.languageLabel.text = name
        self.setImage(from: imgUrl)
        self.codeLabel.text = ""
        self.selectionStyle = .none
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imgView.image = image!
            }
        }
    }
    
}
