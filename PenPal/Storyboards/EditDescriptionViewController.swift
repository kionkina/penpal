//
//  EditDescriptionViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/4/21.
//

import UIKit

class EditDescriptionViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    
    var currentDescription: String?
    public var onDoneEditing: (() -> ())?
    
    @IBAction func buttonOneTouched(_ sender: UIButton) {
        if (self.textField.text != User.current.desc) {
            DBViewController.setDescription(newDesc: self.textField.text, success: {
                User.current.desc = self.textField.text
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: User.current, requiringSecureCoding: false)
                    UserDefaults.standard.set(data, forKey: "currentUser")
                    print("set default!")

                } catch {
                    print("couldn't set")
                }
            })
        }
        
        self.onDoneEditing!()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.text = currentDescription!

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
