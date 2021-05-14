//
//  Message.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/12/21.
//

import UIKit
import FirebaseFirestore
import MessageKit
import MessageUI

class Message: NSObject {
    
    var msgSender: String
    var receiver: String
    var message: String
    var timestamp: Timestamp
    
    
    //Standard Message init()
    init(sender: String, receiver: String, message: String) {
        self.msgSender = sender
        self.receiver = receiver
        self.message = message
        self.timestamp = Timestamp(date: Date())
        
        super.init()
    }
    
    //User init using Firebase snapshots
    init?(snapshot: DocumentSnapshot) {
        guard let dict = snapshot.data(),
            let sender = dict["sender"] as? String,
            let receiver = dict["receiver"] as? String,
            let message = dict["message"] as? String,
            let timestamp = dict["timestamp"] != nil ? dict["timestamp"] as? Timestamp : Timestamp(seconds: 0, nanoseconds: 0)
        else { return nil }
        self.msgSender = sender
        self.receiver = receiver
        self.message = message
        self.timestamp = timestamp
    }
    
    
}

extension Message: MessageType {
    var messageId: String {
        return "0"
    }
    
  var sender: SenderType {
    return Sender(id: msgSender, displayName: "") as SenderType
  }
  
  var sentDate: Date {
    return Date()
  }
  
  var kind: MessageKind {
    return MessageKind.text(message)
  }
}

