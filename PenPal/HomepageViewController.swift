//
//  HomepageViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/26/21.
//

import UIKit

class HomepageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
 {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toUserProfile" {
                print("in segue")
                if let destinationVC = segue.destination as? UserProfileViewController {
                    let cell = sender as! UserCell
                    destinationVC.user = cell.user
                }
            }
        }
    }
    
    var users: [User] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        let numFlags = max(self.users[indexPath.row].langToLearn.count, self.users[indexPath.row].langSpoken.count)
        
        //  (numFlags * 30) + 43 (all the content above stack views) + 24 (spacing between cell border and stackview)
        let height = 125 + 24 + ( Int(numFlags/2) * 30)
        print("height: \(height)")
        
        
            
            return CGSize(width: 200, height: height)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(
            withReuseIdentifier: "UserCell",
            for: indexPath) as! UserCell
        print("returning cell")
        
        cell.configure(user: self.users[indexPath.row])
        cell.onNameClicked = {
            self.performSegue(withIdentifier: "toUserProfile", sender: cell)
        }
        
        return cell
    }
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers {
            self.collectionView.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    
    func viewDidAppear() {
        super.viewDidLoad()
            loadUsers {
                print("reloading!")
                self.collectionView.reloadData()
            }
    }
    
    func loadUsers(success: @escaping ()->Void) {
        DBViewController.getUsers { (users) in
            print("got users!")
            print(users)
            for user in users {
                self.users.append(user)
            }
            success()
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
