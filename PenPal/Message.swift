//
//  Message.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/12/21.
//

import UIKit
import FirebaseFirestore

class Message: NSObject {
    
    var sender: String
    var receiver: String
    var message: String
    var timestamp: Timestamp
    
    
    //Standard Message init()
    init(sender: String, receiver: String, message: String) {
        self.sender = sender
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
        self.sender = sender
        self.receiver = receiver
        self.message = message
        self.timestamp = timestamp
    }
    
    
}

