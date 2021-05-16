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
                User.setCurrent(User.current, writeToUserDefaults: true)
                print("set default!")
            })
        }
        
        self.onDoneEditing!()
        
    }
    
    // MARK: - Keyboard
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= (keyboardSize.height / 2 )
                }
        }
    }

    @objc override func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.text = currentDescription!
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

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
