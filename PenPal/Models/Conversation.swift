//
//  Conversation.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/15/21.
//

import UIKit
import FirebaseFirestore
import MessageKit
import MessageUI

class Conversation: NSObject {
    
    var created: Timestamp
    var id: String
    
    
    //Standard Message init()
    init(id: String) {
        self.created = Timestamp(date: Date())
        self.id = id
        
        super.init()
    }
    
    //User init using Firebase snapshots
    init?(snapshot: DocumentSnapshot, id:String) {
        guard let dict = snapshot.data(),
            let created = dict["created"] != nil ? dict["created"] as? Timestamp : Timestamp(seconds: 0, nanoseconds: 0)
        else { return nil }
        self.created = created
        self.id = id
    }
    
    
}
