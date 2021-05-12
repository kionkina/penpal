//
//  MessagesViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/7/21.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var users: [String: User] = [String: User]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.users.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell")! as! MessageTableViewCell
        
        let user = self.users[Array(self.users.keys)[indexPath.row]]
        cell.configure(name: user!.firstName)
        
        
        return cell
    }
    

    func loadUsers() {
        print("calling on ", Array(User.current.conversations.keys))
        DBViewController.getUserById(uids:Array(User.current.conversations.keys)) { [self] (snap) in
            let user = User(snapshot: snap)
            self.users[user!.uid] = user
            tableView.reloadData()
        }
            print(self.users)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUsers()

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
