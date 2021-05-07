//
//  FlagsCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/26/21.
//

import UIKit

class FlagsCell: UITableViewCell {
    
    @IBOutlet weak var spokenStackView: UIStackView!
   // @IBOutlet weak var spokenStackView: UIStackView?
    @IBOutlet weak var learningStackView: UIStackView!

    static let identifier = "FlagsCell"
    var user: User?
    
    static func nib() -> UINib {
        return UINib(nibName: "FlagsCell", bundle: nil)
    }
    
    func loadImages(){
        self.spokenStackView.sizeToFit()
        self.spokenStackView.layoutIfNeeded()
        self.learningStackView.sizeToFit()
        self.learningStackView.layoutIfNeeded()
        
        learningStackView.translatesAutoresizingMaskIntoConstraints = false
        print("in load imgs")
        var xcor: Int = self.user!.langSpoken.count == 1 ? 20 : 0
        var ycor: Int = 0
        
        
        for langCode in self.user!.langSpoken {
            let imgView = UIImageView()
            let langData = TranslationManager.shared.langugaesDict[langCode]
            
             
            if (xcor > 90 ) {
                xcor = 0
                ycor += 30
            }
            
            imgView.frame = CGRect(x: xcor, y: ycor, width: 40, height: 20)
            print("CODE", langCode)
            self.setImage(imgView: imgView, from: langData!.imgUrl!)
            spokenStackView.addSubview(imgView)
            
            xcor += 50
            }
        
        xcor = self.user!.langToLearn.count == 1 ? 20 : 0
        ycor = 0
        for langCode in self.user!.langToLearn {
            let imgView = UIImageView()
            let langData = TranslationManager.shared.langugaesDict[langCode]


             
            if (xcor > 90 ) {
                xcor = 0
                ycor += 30
            }
            
            imgView.frame = CGRect(x: xcor, y: ycor, width: 40, height: 20)

            self.setImage(imgView: imgView, from: langData!.imgUrl!)
            learningStackView.addSubview(imgView)
            
            xcor += 50
            }
    
}
        
    
    func setImage(imgView: UIImageView, from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                imgView.image = image!
            }
        }
    }

    func clearViews() {
        
        while (self.learningStackView.subviews.count > 0) {
            self.learningStackView.subviews[self.learningStackView.subviews.count - 1].removeFromSuperview()
        }
        
        while (self.spokenStackView.subviews.count > 0) {
            self.spokenStackView.subviews[self.spokenStackView.subviews.count - 1].removeFromSuperview()
        }
        
    }
    
    func configure(user: User) {
        self.user = user
        self.loadImages()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
