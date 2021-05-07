//
//  ShowTranslationViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/7/21.
//

import UIKit

class ShowTranslationViewController: UIViewController {

    var fromCode: String?
    var toCode: String?
    var translationText: String?
    @IBOutlet weak var textView: UITextView!
    
    func getTranslation() {
        
        TranslationManager.shared.translate(textToTranslate: self.translationText!, sourceLanugage: self.fromCode!, targetLanguage: self.toCode!, completion: { (translation) in
            if let translation = translation {
               DispatchQueue.main.async { [unowned self] in
                print("seeting textview to \(translation)")
                self.textView.text = translation
               }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = "translation"
        getTranslation()
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
