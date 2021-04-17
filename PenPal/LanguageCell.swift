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
    
    var selectedLang: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //let imgUrl = "https://www.unknown.nu/flags/images/\(codeLabel.text)-100"
        //print(imgUrl)
        //setImage(from: imgUrl)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        updateDisplaySelected()
    }

    func toggleSelected() {
        self.selectedLang = !self.selectedLang
        self.updateDisplaySelected()
    }
    
    func updateDisplaySelected() {
        if self.selectedLang {
            self.accessoryType = .checkmark
        }
        else {
            self.accessoryType = .none
        }
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                print("img: ")
                print(image)
                self.imgView.image = image!
            }
        }
    }
    
}
