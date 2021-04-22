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

    static func updateLanugaes(alreadySpoken: [String], toLearn: [String]){
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(User.current.uid)
        
        print("in db fxn")
        print(alreadySpoken)
        print(toLearn)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
                transaction.updateData(["langSpoken": alreadySpoken], forDocument: userRef)
                transaction.updateData(["langToLearn": toLearn], forDocument: userRef)
                return true
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }

}
