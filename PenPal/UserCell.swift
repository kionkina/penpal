//
//  UserCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/28/21.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var name: UIButton!
    @IBOutlet weak var learningStackView: UIView!
    @IBOutlet weak var spokenStackView: UIStackView!
    
    var user: User?
    var onNameClicked : (()->())?
    
    @IBAction func nameClicked() {
        self.onNameClicked!()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("i've awoken")
        
        self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2
        self.imgView.clipsToBounds = true
        
    }
    
    func configure(user: User) {
        self.user = user
        self.name.setTitle("\(user.firstName) \(user.lastName)", for: .normal) 
        self.location.text = "\(user.location)"
        
        let numFlags = max(self.user!.langToLearn.count, self.user!.langSpoken.count)
        print("numFlags: \(numFlags)")
        let height = ( (numFlags/2) * 30)
        
        self.spokenStackView.layoutIfNeeded()
        self.learningStackView.layoutIfNeeded()
        
        //self.spokenStackView.heightAnchor.constraint(equalToConstant: CGFloat(height))
        //self.learningStackView.heightAnchor.constraint(equalToConstant: CGFloat(height))
        
        
        print("height: \(height)")
        
        loadImages()
    }
    
    func loadImages(){
        self.spokenStackView.sizeToFit()
        self.spokenStackView.layoutIfNeeded()
        self.learningStackView.sizeToFit()
        self.learningStackView.layoutIfNeeded()
        
        learningStackView.translatesAutoresizingMaskIntoConstraints = false
        print("in load imgs")
        var xcor: Int = self.user?.langSpoken.count == 1 ? 20 : 0
        var ycor: Int = 0
        
        
        for langCode in self.user!.langSpoken {
            let imgView = UIImageView()
            let langData = TranslationManager.shared.langugaesDict[langCode]
            
             
            if (xcor > 90 ) {
                xcor = 0
                ycor += 30
            }
            
            imgView.frame = CGRect(x: xcor, y: ycor, width: 40, height: 20)

            self.setImage(imgView: imgView, from: langData!.imgUrl!)
            spokenStackView.addSubview(imgView)
            
            xcor += 50
            }
        
        xcor = self.user?.langToLearn.count == 1 ? 20 : 0
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
    
    func clearViews() {
        
        while (self.learningStackView.subviews.count > 0) {
            self.learningStackView.subviews[self.learningStackView.subviews.count - 1].removeFromSuperview()
        }
        
        while (self.spokenStackView.subviews.count > 0) {
            self.spokenStackView.subviews[self.spokenStackView.subviews.count - 1].removeFromSuperview()
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
    
}
