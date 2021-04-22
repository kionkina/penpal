//
//  MainViewController.swift
//  Firebase-boilerplate
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    var authHandle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var learningStackView: UIStackView!
    @IBOutlet weak var spokenStackView: UIStackView!
    
    override func viewDidAppear(_ animated: Bool) {
        loadImages()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = "\(User.current.firstName) \(User.current.lastName)"
        self.loadImages()
        //        usernameLabel.text = User.current.username
                
        authHandle = AuthService.authListener(viewController: self)
    }
    
    func loadImages(){
        learningStackView.translatesAutoresizingMaskIntoConstraints = false
        print("in load imgs")
        var xcor: Int = 0
        var ycor: Int = 0
        
        
        for langCode in User.current.langSpoken {
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
        
        xcor = 0
        ycor = 0
        for langCode in User.current.langToLearn {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        AuthService.removeAuthListener(authHandle: authHandle)
    }

    @IBAction func logOutClicked(_ sender: UIButton) {
        AuthService.presentLogOut(viewController: self)
    }
    
    @IBAction func deleteAccountClicked(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else {
            print("NO USER EXISTS???")
            return
        }
        AuthService.presentDelete(viewController: self, user : user)
    }
    
}
