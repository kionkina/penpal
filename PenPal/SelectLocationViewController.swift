//
//  SelectLocationViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/26/21.
//

import UIKit

class SelectLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    
    
    var selectedCountry: String = ""
    var searching: Bool = false
    var searchTerms: [Int] = []
    var selectedRow: Int = -1
    
    public var onDoneEditing: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if (User.current.location != "") {
            let index = LocationManager.shared.allCountries.firstIndex(where: { (currCountry) -> Bool in
                currCountry.name == User.current.location // test if this is the item you're looking for
            })
            self.selectedRow = index!
        }
        self.title = "Select Country of Residence"
        
        if User.current.location != "" {
            self.selectedCountry = User.current.location
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? searchTerms.count : LocationManager.shared.allCountries.count
    }

    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        //print("setting country to \(LocationManager.shared.allCountries[indexPath.row])")
        if searching {
            let row = searchTerms[indexPath.row]
            cell.country = LocationManager.shared.allCountries[row]
            cell.configure(for: LocationManager.shared.allCountries[row])
        } else {
            cell.country = LocationManager.shared.allCountries[indexPath.row]
            cell.configure(for: LocationManager.shared.allCountries[indexPath.row])
        }
        
        if cell.country.name == self.selectedCountry {
            cell.accessoryType = .checkmark
            cell.setSelected(true, animated: false)
        } else {
            cell.setSelected(false, animated: false)
            cell.accessoryType = .none
        }
        
        cell.selectionStyle = .none

        
       return cell
    }
    
    func deselectPrev() {
        print("in deselect, prevepath ", self.selectedRow)
        if self.selectedRow != -1 {
            let index: Int = self.selectedRow
            print("index = \(index)")
            let prevPath = IndexPath(row: index, section: 0)
            if (tableView.indexPathsForVisibleRows!.contains(prevPath)) {
                let prevcell = tableView.cellForRow(at: prevPath) as? CountryTableViewCell
                prevcell!.accessoryType = .none
                prevcell!.setSelected(false, animated: false)
            }
        }
    }
    

    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if (tableView.cellForRow(at: indexPath) as? CountryTableViewCell) != nil {
            
            deselectPrev()
            
            
            let cell = tableView.cellForRow(at: indexPath) as? CountryTableViewCell
            cell?.accessoryType = .checkmark
            print("selecting row \(indexPath.row)")
            self.selectedRow = indexPath.row
            
            let index: Int = searching ? self.searchTerms[indexPath.row] : indexPath.row
            
            self.selectedCountry = LocationManager.shared.allCountries[index].name
            print("set selected country to \(self.selectedCountry)")
            print("setting selected to: \(indexPath.row)")
            self.selectedRow = indexPath.row
            //print("set selectedRow to \(self.selectedRow)")
            
            

        }
    }
    
    // MARK: - IBAction
    @IBAction func buttonOneTouched(_ sender: UIButton) {

        if (self.selectedCountry == "") {
            let alert = UIAlertController(title: "Alert", message: "Please select a country of residence.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        } else {
            print("in else clause")
            if (self.onDoneEditing != nil) {
                if (self.selectedCountry != User.current.location) {
                    User.current.location = self.selectedCountry
                    DBViewController.setLocation {
                        UserDefaults.standard.setValue(User.current.location, forKey: "location")
                        self.onDoneEditing!()
                    }
                }
                else {
                    // Didn't change location
                    self.onDoneEditing!()
                }
            }
            else {
                User.current.location = self.selectedCountry
                DBViewController.setLangAndLocation {
                    //segue
                    User.setCurrent(User.current)
                   
                    let initialViewController = UIStoryboard.initialViewController(for: .main)
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
      
    
}


extension SelectLocationViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    print("The search text is: '\(searchBar.text!)'")
    
    var currSelectedRow: IndexPath?
    
    var temp: [Int] = []
    if (searchBar.text!.count == 0) {
        self.searching = false
        self.tableView.reloadData()
        return
    }
    
    var ctr = 0
    self.selectedRow = -1
    for country in LocationManager.shared.allCountries where (country.name.lowercased().range(of: (searchBar.text?.lowercased())!) != nil) {
        let index = LocationManager.shared.allCountries.firstIndex(where: { (currCountry) -> Bool in
            currCountry.name == country.name // test if this is the item you're looking for
        })
        
        if (country.name == self.selectedCountry) {
            print("selection row will be \(ctr)")
            currSelectedRow = IndexPath(row: ctr, section: 0)
            self.selectedRow = ctr
        }
        
        temp.append(index!)
        ctr += 1
    }
    

    self.searchTerms = temp
    self.searching = true
    tableView.reloadData()

    if (currSelectedRow != nil) {
        self.tableView.selectRow(at: currSelectedRow, animated: false, scrollPosition: .none)
    }

  }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            print("changed to empty")
            self.searching = false
            tableView.reloadData()
            if (self.selectedCountry != ""){
                let row = getSelectionIndex()
                self.selectedRow = row.row
                self.tableView.selectRow(at: row, animated: false, scrollPosition: .none)
                print("updating selection, selected is \(row.row)")
            }
          
            }

    }
    
    func getSelectionIndex() -> IndexPath {
        let index = LocationManager.shared.allCountries.firstIndex(where: { (currCountry) -> Bool in
            currCountry.name == self.selectedCountry // test if this is the item you're
        })
        if (index != nil) {
            print("selection index is \(String(describing: index))")
            print("country is \(LocationManager.shared.allCountries[index!].name)")
        }
        return IndexPath(row: index!, section: 0)
    }
}

  
