//
//  ConversationViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/12/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseStorage

import AVFoundation
import AudioToolbox

struct Member {
  let name: String
  let color: UIColor
}

class ConversationViewController: MessagesViewController {

    
    var receiver: User?
    var convoId: String?
    var allMessages = [Message]()
    var member: Member!
    var soundID: SystemSoundID = 0
    
    let sendPath = Bundle.main.path(forResource: "send.caf", ofType:nil)
//    let sendPath = Bundle.main.path(forResource: "send", ofType: "caf")

    
    func loadMessages(success: @escaping ()->Void) {
        DBViewController.getMessagesById(convoId: convoId!) { (messages) in
            for msg in messages {
                self.allMessages.append(msg)

            }
            success()
        }
    }
    
    // MARK: - Sound effects
    func loadSoundEffect() {
        if let path = sendPath {
            print("path: \(path)")
        let fileURL = URL(fileURLWithPath: path, isDirectory: false)
        let error = AudioServicesCreateSystemSoundID(fileURL as CFURL, &soundID)
        if error != kAudioServicesNoError {
          print("Error code \(error) loading sound: \(path)")
        }
      }
    }

    func unloadSoundEffect() {
      AudioServicesDisposeSystemSoundID(soundID)
      soundID = 0
    }

    func playSoundEffect() {
      AudioServicesPlaySystemSound(soundID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.receiver!.firstName) \(self.receiver!.lastName)"
        self.loadSoundEffect()

        member = Member(name: User.current.username, color: .blue)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        self.loadMessages {
            self.messagesCollectionView.reloadData()
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

extension ConversationViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    
    func currentSender() -> SenderType {
        return Sender(id: User.current.uid, displayName: member.name) as SenderType
    }
    
  func numberOfSections(
    in messagesCollectionView: MessagesCollectionView) -> Int {
    print("Returning count: ", allMessages.count)
    return allMessages.count
  }

  
  func messageForItem(
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> MessageType {

    return allMessages[indexPath.section]
  }
  
  func messageTopLabelHeight(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
    return 12
  }
  
  func messageTopLabelAttributedText(
    for message: MessageType,
    at indexPath: IndexPath) -> NSAttributedString? {
    
    return NSAttributedString(
        string: message.sender.senderId == User.current.uid ? User.current.firstName : receiver?.firstName as! String,
      attributes: [.font: UIFont.systemFont(ofSize: 12)])
  }
    
    func heightForLocation(message: MessageType,
        at indexPath: IndexPath,
        with maxWidth: CGFloat,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
      }
    
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        
        let message = allMessages[indexPath.section]
        let color = member.color
    
        
        avatarView.sd_setImage(with: Storage.storage().reference().child("profilephotos").child(message.sender.senderId == User.current.uid ? User.current.profilePic : receiver?.profilePic as! String ))
      }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    
        //logic for adding message to db, reload page
        let currentMessage = Message(sender: User.current.uid, receiver: self.receiver!.uid, message: text)
        DBViewController.addMessage(convoId: self.convoId!, message: currentMessage) {
            self.allMessages.append(currentMessage)
            // add sound?
            inputBar.inputTextView.text = ""
            self.playSoundEffect()
            self.messagesCollectionView.reloadData()
        }
        
        
        /*
    //When use press send button this method is called.
    let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.uid, senderName: currentUser.displayName!)
    //calling function to insert and save message
    insertNewMessage(message)
    save(message)
    //clearing input field
    inputBar.inputTextView.text = ""
    messagesCollectionView.reloadData()
    messagesCollectionView.scrollToBottom(animated: true)*/
    }
    
    
}
