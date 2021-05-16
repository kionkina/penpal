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
        
        //  (all the content above stack views) + spacing between cell border and stackview
        let height = 125 + 40 + ( Int(numFlags/2) * 30 )
        
        return CGSize(width: Int(self.view.frame.size.width) - 100, height: height)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(
            withReuseIdentifier: "UserCell",
            for: indexPath) as! UserCell

        cell.clearViews()
        cell.configure(user: self.users[indexPath.row])
        cell.onNameClicked = {
            self.performSegue(withIdentifier: "toUserProfile", sender: cell)
        }
        
        cell.alpha = 0

        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
        
        return cell
    }
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()



    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did loading")
        loadUsers { [self] in
            self.collectionView.reloadData()
            self.collectionView.refreshControl = self.refreshControl
            // Configure Refresh Control
            refreshControl.addTarget(self, action: #selector(self.refreshUserData(_:)), for: .valueChanged)
        }

        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshUserData(_ sender: Any) {
        print("in refresh user data")
        
        loadUsers {
            print("reloading!")
            
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
            
        }
    }
    
    func viewDidAppear() {
        super.viewDidLoad()
    }
    
    func loadUsers(success: @escaping ()->Void) {
        DBViewController.getUsers { (users) in


            self.users = users.filter { (user) -> Bool in
                return user.uid != User.current.uid
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
