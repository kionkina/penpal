//
//  DBViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/20/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class DBViewController: UIViewController {

    static func setLangAndLocation(success: @escaping () -> Void){
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(User.current.uid)
        
        let alreadySpoken = User.current.langSpoken
        let toLearn = User.current.langToLearn
        let location = User.current.location
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
                transaction.updateData(["langSpoken": alreadySpoken], forDocument: userRef)
                transaction.updateData(["langToLearn": toLearn], forDocument: userRef)
            transaction.updateData(["location": location], forDocument: userRef)
                return true
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
                success()
            }
        }
    }
    
    static func setSpoken(success: @escaping () -> Void){
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(User.current.uid)
        let alreadySpoken = User.current.langSpoken
        
        print("in db fxn")
        
        userRef.setData(["langSpoken": alreadySpoken], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Langspoken succesfully updated!")
                success()
            }
        }
    }
    
    static func setLocation(success: @escaping () -> Void){
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(User.current.uid)
        let selectedCountry = User.current.location
        
        print("in db fxn")
        
        userRef.setData(["location": selectedCountry], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Langspoken succesfully updated!")
                success()
            }
        }
    }
    
    static func setLearning(success: @escaping () -> Void){
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(User.current.uid)
        let toLearn = User.current.langToLearn
        
        print("in db fxn")
        
        userRef.setData(["langToLearn": toLearn], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("LangToLearn succesfully updated!")
                success()
            }
        }
    }
    
    static func setDescription( newDesc:String, success: @escaping () -> Void){
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(User.current.uid)
        
        print("in db fxn")
        
        userRef.setData(["desc": newDesc], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("LangToLearn succesfully updated!")
                success()
            }
        }
    }
    
    static func getUsers(success: @escaping ([User]) -> ()) {
        let db = Firestore.firestore()
        let userRef = db.collection("users")
        
       
        var ret: [User] = []
        print("looking for users who's langSpoken has \(User.current.langToLearn)")
        print("and their toLearn is in \(User.current.langSpoken)")
        
        userRef.whereField("langSpoken", arrayContainsAny: User.current.langToLearn).getDocuments { (snapshot, _: Error?) in
 
            var docs: [QueryDocumentSnapshot] = []
            for doc in snapshot!.documents {
                docs.append(doc)
            }
        
            
            for doc in docs {
                if (User(snapshot: doc)!.langToLearn.contains(where: User.current.langSpoken.contains)) {
                    ret.append(User(snapshot: doc)!)
                }
            }
            print("ret length: \(ret.count)")
            success(ret)
        }
        
  
    }
    
    static func getUsersByIds(uids: [String], success: @escaping (([User]) -> Void)) {
        let db = Firestore.firestore()
        let userRef = db.collection("users")
        var ret = [User]()
        
        userRef.whereField(FieldPath.documentID(), in: uids).getDocuments { (qs: QuerySnapshot?, _: Error?) in
            for doc in qs!.documents {
                ret.append(User(snapshot: doc)!)
            }
            success(ret)
        }
        
    }
    
    static func addMessage(convoId: String, message: Message, success: @escaping(() -> Void)) {
        let db = Firestore.firestore()
        var data = [String: Any]()
        data["sender"] = message.msgSender
        data["receiver"] = message.receiver
        data["message"] = message.message
        data["timestamp"] = message.timestamp
        
        let convoRef = db.collection("conversations").document(convoId)
        
        convoRef.collection("messages").addDocument(data: data ) { err in
               if let err = err {
                   print("Error adding conversation document: \(err)")
               } else {
                    //added to sub collection
                    success()
               }
           }
    }
    
    static func sendFirstMessage(message: Message, success: @escaping(() -> Void)) {
        print("in db method")
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(User.current.uid)
        let receiverRef = db.collection("users").document(message.receiver)

        var data = [String: Any]()
        data["created"] = Timestamp(date: Date())
        var convoRef: DocumentReference? = nil
        convoRef = db.collection("conversations").addDocument(data: data ) { err in
               if let err = err {
                   print("Error adding conversation document: \(err)")
               } else {
                let docId = convoRef!.documentID
                db.runTransaction { (Transaction, NSErrorPointer) -> Any? in
                    Transaction.updateData(["conversations.\(message.receiver)" : docId], forDocument: userRef)
                    
                    Transaction.updateData(["conversations.\(User.current.uid)" : docId], forDocument: receiverRef)
                    
                    return true
                } completion: { (_: Any?, error: Error?) in
                    if let error = error {
                        print("Transaction failed: \(error)")
                    } else {
                        print("Transaction successfully committed!")
                        User.current.conversations[message.receiver] = docId
                        User.setCurrent(User.current)
                        return addMessage(convoId: docId, message: message, success: success)
                    }
               }
           }
        }
    }
    
    static func getMessagesById(convoId: String, success: @escaping ([Message])->Void) {
        let db = Firestore.firestore()
        var ret = [Message]()
        db.collection("conversations").document(convoId).collection("messages").order(by: "timestamp", descending: false).getDocuments{ (qs: QuerySnapshot?, err) in
            for doc in qs!.documents {
                ret.append(Message(snapshot: doc)!)
            }
        success(ret)
        }
    }
}
