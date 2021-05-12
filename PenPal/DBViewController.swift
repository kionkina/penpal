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
    
    static func getUserById(uids: [String], success: @escaping ((DocumentSnapshot) -> Void)) {
        let db = Firestore.firestore()
        let userRef = db.collection("users")
        var ret = [User]()
        userRef.whereField("uid", in: uids).getDocuments { (qs: QuerySnapshot?, _: Error?) in
            print("RET LENGTH SHUD BE 3: ", qs?.documents.count)
            for doc in qs!.documents {
                //ret.append(User(snapshot: doc)!)
                success(doc)
            }
            //success(ret)
        }
        
    }
    
    static func addMessage(convoId: String, message: Message, success: @escaping(() -> Void)) {
        let db = Firestore.firestore()
        var data = [String: String]()
        data["sender"] = message.sender
        data["receiver"] = message.receiver
        data["message"] = message.message
        
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

        var data = [String: String]()
        data["sender"] = message.sender
        data["receiver"] = message.receiver
        data["message"] = message.message
        var convoRef: DocumentReference? = nil
        convoRef = db.collection("conversations").addDocument(data: data ) { err in
               if let err = err {
                   print("Error adding conversation document: \(err)")
               } else {
                let docId = convoRef!.documentID
                userRef.updateData(["conversations.\(message.receiver)" : docId]);
                // Added thread.
                User.current.conversations[message.receiver] = docId
                addMessage(convoId: docId, message: message, success: success)
               }
           }
    }

}
