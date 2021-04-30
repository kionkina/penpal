//
//  CountryTableViewCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/26/21.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryNameLabel: UILabel!
    var country: LocationManager.Country!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //print("awoke from nib")
        //print("setting text to \(country.name)")
       
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for: LocationManager.Country) {
        //print("setting name")
        self.countryNameLabel.text = country.name
    }
    
}
