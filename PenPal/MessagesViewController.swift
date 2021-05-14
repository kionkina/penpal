//
//  MessagesViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/7/21.
//

import UIKit

class ViewMessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var users: [String: User] = [String: User]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.users.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell")! as! MessageTableViewCell
        
        let user = self.users[Array(self.users.keys)[indexPath.row]]
        cell.configure(name: "\(user!.firstName) \(user!.lastName)", uid: user!.uid, profilePic: user!.profilePic)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

           performSegue(withIdentifier: "toConversations", sender: self)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let destination = segue.destination as? ConversationViewController {
            let penPalUid = (self.tableView.cellForRow(at:  tableView.indexPathForSelectedRow!) as! MessageTableViewCell).uid!
            destination.receiver = self.users[penPalUid]
            destination.convoId = User.current.conversations[penPalUid]
            
         }
    }
    
    func loadUsers(success: @escaping ()->Void ) {
        DBViewController.getUsersByIds(uids:Array(User.current.conversations.keys)) { (users) in
            for user in users {
                self.users[user.uid] = user
            }
        success()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUsers( success: {
            self.tableView.reloadData()
        })
        self.tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshUserData(_:)), for: .valueChanged)

        
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshUserData(_ sender: Any) {
        self.users.removeAll()
        self.loadUsers {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }
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
