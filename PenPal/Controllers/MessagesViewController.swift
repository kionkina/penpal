//
//  MessagesViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/7/21.
//

import UIKit
import FirebaseFirestore

struct convoStruct {
    var convoId: String
    var receiver: String
    var created: Timestamp?
}


class ViewMessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var users: [String: User] = [String: User]()
    var convos = [String: Conversation]()
    var myConvos = [convoStruct]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.myConvos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell")! as! MessageTableViewCell

        let user = self.users[self.myConvos[indexPath.row].receiver]
        
        
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
            destination.setId(id: User.current.conversations[penPalUid]!)
            
         }
    }
    
    func loadConversations() {
        DBViewController.getConvosById(convoIds: Array(User.current.conversations.values)) { (conversations) in
                self.convos = conversations
            
            var tempConvos = [convoStruct]()
            for user in Array(self.users.keys) {
                let convoId = User.current.conversations[self.users[user]!.uid]
                var convo = convoStruct(convoId: "", receiver: "", created: nil)
                convo.convoId = convoId!
                convo.receiver = user
                convo.created = self.convos[convoId!]?.created
                tempConvos.append(convo)
            }
            self.myConvos = tempConvos
            self.myConvos = self.myConvos.sorted(by: {$0.created!.dateValue() > $1.created!.dateValue() })
            self.tableView.reloadData()
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
        if (User.current.conversations.keys.count > 0) {
            self.loadUsers( success: {
                self.loadConversations()
            })
        }
                       
        self.tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshUserData(_:)), for: .valueChanged)
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    @objc private func refreshUserData(_ sender: Any) {
        if (User.current.conversations.keys.count > 0) {
           // self.users.removeAll()
            //self.myConvos.removeAll()
            //self.convos.removeAll()
            print("calling load users//")
            self.loadUsers(success:  {
                self.loadConversations()
                self.refreshControl.endRefreshing()
        })
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
