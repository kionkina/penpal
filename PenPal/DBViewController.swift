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
    
    static func getUsers(success: @escaping ([User]) -> ()) {
        let db = Firestore.firestore()
        let userRef = db.collection("users")
        
       
        var ret: [User] = []
        print("looking for users who's langSpoken has \(User.current.langToLearn)")
        print("and their toLearn is in \(User.current.langSpoken)")
        
        let spokenList = userRef.whereField("langSpoken", arrayContainsAny: User.current.langToLearn).getDocuments { (snapshot, _: Error?) in
 
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

}
