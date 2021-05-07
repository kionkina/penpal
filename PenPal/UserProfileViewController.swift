//
//  MainViewController.swift
//  Firebase-boilerplate
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      if indexPath.row == 5 {
        let val = max(User.current.langToLearn.count, User.current.langSpoken.count)
        print("val times thirty: ")
        print(val*30)
        return CGFloat(val * 30)
      }
      else {
        return 50
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
                //do stuff
                
                cell.configure(user: self.user!)
                cell.selectionStyle = .none
                return cell

                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
                cell.configure(user: self.user!)
                cell.selectionStyle = .none
                return cell

            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
                cell.configure(user: self.user!)
                cell.selectionStyle = .none
                return cell

            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCell
                cell.configure(user: self.user!)
                cell.selectionStyle = .none
                return cell

            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageLabelCell", for: indexPath) as! LanguageLabelCell
                cell.configure(user: self.user!)
                cell.selectionStyle = .none
                return cell

            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "FlagsCell", for: indexPath) as! FlagsCell
                cell.configure(user: self.user!)
                cell.selectionStyle = .none
                return cell
            

    
            default:
                let cell = UITableViewCell()
                return cell

        }
    }

    var authHandle: AuthStateDidChangeListenerHandle?
    

 
    var user:User?
    @IBOutlet weak var tableView: UITableView!
    var toProfileUser: User?
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.isScrollEnabled = false

        //nameLabel.text = "\(User.current.firstName) \(User.current.lastName)"


        tableView.register(LocationCell.nib(), forCellReuseIdentifier: LocationCell.identifier)
        tableView.register(DescriptionCell.nib(), forCellReuseIdentifier: DescriptionCell.identifier)
        tableView.register(NameCell.nib(), forCellReuseIdentifier: NameCell.identifier)
        tableView.register(LanguageLabelCell.nib(), forCellReuseIdentifier: LanguageLabelCell.identifier)
        tableView.register(FlagsCell.nib(), forCellReuseIdentifier: FlagsCell.identifier)
        //        usernameLabel.text = User.current.username
                
        authHandle = AuthService.authListener(viewController: self)
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        AuthService.removeAuthListener(authHandle: authHandle)
    }

    @IBAction func logOutClicked(_ sender: UIButton) {
        AuthService.presentLogOut(viewController: self)
    }
    
    @IBAction func deleteAccountClicked(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else {
            print("NO USER EXISTS???")
            return
        }
        AuthService.presentDelete(viewController: self, user : user)
    }
    
}
