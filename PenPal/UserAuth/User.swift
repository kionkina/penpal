//
//  User.swift
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class User : NSObject {
    
    //User variables
    let uid : String
    let firstName : String
    let lastName : String
    let username : String
    var langSpoken: [String]
    var langToLearn: [String]
    var location: String
    var desc: String
    var conversations: [String: String]
    var dictValue: [String : Any] {
        return ["firstName" : firstName,
                "lastName" : lastName,
                "username" : username,
                "langSpoken": langSpoken,
                "langToLearn": langToLearn,
                "description": desc,
                "location": location,
                "conversations": conversations]
    }
    
    //Standard User init()
    init(uid: String, username: String, firstName: String, lastName: String) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.langSpoken = []
        self.langToLearn = []
        self.location = ""
        self.desc = "Polyglot in the making! "
        self.conversations = [String: String]()
        super.init()
    }
    
    //User init using Firebase snapshots
    init?(snapshot: DocumentSnapshot) {
        guard let dict = snapshot.data(),
            let firstName = dict["firstName"] as? String,
            let lastName = dict["lastName"] as? String,
            let username = dict["username"] as? String,
            let langSpoken = dict["langSpoken"] as? [String],
            let langToLearn = dict["langToLearn"] as? [String],
            let desc = dict["desc"] != nil ? dict["desc"] as? String : "Polyglot in the making!",
            let location = dict["location"] != nil ? dict["location"] as? String : "",
            let conversations = dict["conversations"] != nil ? dict["conversations"] as? [String: String] : [String: String]()
            else { return nil }
        self.uid = snapshot.documentID
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.langSpoken = langSpoken
        self.langToLearn = langToLearn
        self.location = location
        self.desc = desc
        self.conversations = conversations
    }
    
    //UserDefaults
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: "uid") as? String,
            let firstName = aDecoder.decodeObject(forKey: "firstName") as? String,
            let lastName = aDecoder.decodeObject(forKey: "lastName") as? String,
            let username = aDecoder.decodeObject(forKey: "username") as? String,
            let langSpoken = aDecoder.decodeObject(forKey: "langSpoken") as? [String],
            let langToLearn = aDecoder.decodeObject(forKey: "langToLearn") as? [String],
            let location = aDecoder.decodeObject(forKey: "location") as? String,
            let desc = aDecoder.decodeObject(forKey: "desc") as? String,
            let conversations = aDecoder.decodeObject(forKey: "conversations") as? [String: String]
            else { return nil }
        
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.langSpoken = langSpoken
        self.langToLearn = langToLearn
        self.location = location
        self.desc = desc
        self.conversations = conversations
    }
    
    
    //User singleton for currently logged user
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
    
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        print("in set current")
        if writeToUserDefaults {

            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
                UserDefaults.standard.set(data, forKey: "currentUser")
                print("set default!")

            } catch {
                print("couldn't set")
            }
        }
        _current = user
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(langSpoken, forKey: "langSpoken")
        aCoder.encode(langToLearn, forKey: "langToLearn")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(conversations, forKey: "conversations")
        
    }
}
