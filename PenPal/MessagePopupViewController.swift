//
//  messagePopupViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/12/21.
//

import UIKit

class MessagePopupViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    public var onSend: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closePopUp(sender: Any) {
        self.view.removeFromSuperview();
    }
    
    @IBAction func send(sender: UIButton) {
        if (self.textField.text!.trimmingCharacters(in: .whitespaces) == "") {
            displayNoChoiceAlert(message: "Empty messages aren't great conversation starters... Try again?")
        } else {
            self.onSend!()
        }
    }
    
    func configure(name: String) {
        self.label.text = "Send message to \(name)"
    }
    
    // TODO: make shared
    func displayNoChoiceAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
