//
//  ConversationViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/12/21.
//

import UIKit

class ConversationViewController: UIViewController {

    var receiver: User?
    var convoId: String?
    var allMessages = [Message]()
    
    func loadMessages(success: @escaping ()->Void) {
        DBViewController.getMessagesById(convoId: convoId!) { (messages) in
            for msg in messages {
                self.allMessages.append(msg)
            }
            success()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("home sweet home")
        print("convo with ", receiver?.firstName)
        print("id: ", convoId)
        
        self.loadMessages {
            print("all done")
            for message in self.allMessages {
                print(message.message)
            }
        }
        
        
        
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
