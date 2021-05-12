//
//  TranslateViewController.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/6/21.
//

import UIKit

class TranslateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct TranslationLanguageCell {
        var code: String
        var name: String
    }
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var toSearchBar: UISearchBar!
    var toSearch: Bool = false
    @IBOutlet weak var fromSearchBar: UISearchBar!
    var fromSearch: Bool = false
    
    var allLanguages = [TranslationLanguageCell]()
    var toSearchIndices: [Int] = []
    var fromSearchIndices: [Int] = []
    
    @IBOutlet weak var fromTableView: UITableView!
    @IBOutlet weak var toTableView: UITableView!

    var fromCode: String = ""
    var toCode: String = ""
    
    var fromCodeRow: Int = -1
    var toCodeRow: Int = -1
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toTranslate" {
                print("in segue")
                if let destinationVC = segue.destination as?ShowTranslationViewController {
                    destinationVC.fromCode = self.fromCode
                    destinationVC.toCode = self.toCode
                    destinationVC.translationText = self.textField.text
                    
                }
            }
        }
    }
    
    func loadLanguages() {
        for code in TranslationManager.shared.supportedLanguages {
            let name = TranslationManager.shared.langugaesDict[code]!.name
            self.allLanguages.append(TranslationLanguageCell(code: code, name: name!))
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLanguages()
        
        // Do any additional setup after loading the viekloi.lw.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choiceCell" , for: indexPath) as! TranslateChoiceTableViewCell
        
        var language = TranslationLanguageCell(code:"", name: "")
        if (tableView == self.toTableView) {
            if toSearch {
                language = self.allLanguages[toSearchIndices[indexPath.row]]
            } else {
                language = self.allLanguages[indexPath.row]
            }
            
            if (language.code == self.toCode) {
                cell.setSelected(true, animated: false)
                cell.accessoryType = .checkmark
            } else {
                cell.setSelected(false, animated: false)
                cell.accessoryType = .none
            }
        } else {
            if fromSearch {
                language = self.allLanguages[fromSearchIndices[indexPath.row]]
            } else {
                language = self.allLanguages[indexPath.row]
            }
            if (language.code == self.fromCode) {
                cell.setSelected(true, animated: false)
                cell.accessoryType = .checkmark
            } else {
                cell.setSelected(false, animated: false)
                cell.accessoryType = .none
            }
        }
        
        cell.configure(name: language.name, code: language.code)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if (tableView == self.toTableView) {
            
            deselectPrev(tableView: tableView)
            
            let cell = tableView.cellForRow(at: indexPath) as! TranslateChoiceTableViewCell
            cell.accessoryType = .checkmark
            let index: Int = self.toSearch ? self.toSearchIndices[indexPath.row] : indexPath.row
            self.toCode = allLanguages[index].code
            self.toCodeRow = indexPath.row
            //print("set selectedRow to \(self.selectedRow)")
        } else {
            
            deselectPrev(tableView: tableView)
            
            let cell = tableView.cellForRow(at: indexPath) as! TranslateChoiceTableViewCell
            cell.accessoryType = .checkmark
            let index: Int = self.fromSearch ? self.fromSearchIndices[indexPath.row] : indexPath.row
            self.fromCode = allLanguages[index].code
            self.fromCodeRow = indexPath.row
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let to: Bool = (tableView == self.toTableView)
            
        if (to && self.toSearch) {
            return toSearchIndices.count
        } else if (!to && self.fromSearch) {
            return fromSearchIndices.count
        }
        
        return TranslationManager.shared.supportedLanguages.count
    }

    func deselectPrev(tableView: UITableView) {

        if (tableView == self.toTableView) {
            if self.toCodeRow != -1 {
                let index: Int = self.toCodeRow
                print("trying to deselect at \(index)")
                let prevPath = IndexPath(row: index, section: 0)
                if (self.toTableView.indexPathsForVisibleRows!.contains(prevPath)) {
                    let prevcell = tableView.cellForRow(at: prevPath) as? TranslateChoiceTableViewCell
                    prevcell!.accessoryType = .none
                    prevcell!.setSelected(false, animated: false)
                }
            }
        } else {
            if self.fromCodeRow != -1 {
                let index: Int = self.fromCodeRow
                print("trying to deselect at \(index)")
                let prevPath = IndexPath(row: index, section: 0)
                if (self.fromTableView.indexPathsForVisibleRows!.contains(prevPath)) {
                    let prevcell = tableView.cellForRow(at: prevPath) as? TranslateChoiceTableViewCell

                    prevcell!.accessoryType = .none
                    prevcell!.setSelected(false, animated: false)
                }

            }
        }
    }
    
    func displayNoChoiceAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Handler
    @IBAction func onTranslate(_ sender: UIBarButtonItem ) {
        if (self.fromCode == "" || self.toCode == "" ){
            displayNoChoiceAlert(message: "Please select two languages.")
        } else if (self.textField.text.trimmingCharacters(in: .whitespaces) == "") {
            displayNoChoiceAlert(message: "Please type something into the text field.")
        } else {
            self.performSegue(withIdentifier: "toTranslate", sender: self)
        }
        
    }
    
    
    
}

extension TranslateViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if (searchBar.text == "") {
        return
    }

    // store indecies of search-related languages
    var temp: [Int] = []
    let to: Bool = (searchBar == self.toSearchBar)
    if (to) {
        self.toCodeRow = -1
    } else {
        self.fromCodeRow = -1
    }
    
    var ctr = 0
    for lang in self.allLanguages where (lang.name.lowercased().range(of: (searchBar.text?.lowercased())!) != nil) {
        let index = allLanguages.firstIndex(where: { (currLang) -> Bool in
            currLang.name == lang.name // test if this is the item you're looking for
        })
        if to && lang.code == toCode {
            self.toCodeRow = ctr
        } else if (!to && lang.code == fromCode) {
            self.fromCodeRow = ctr
        }
        temp.append(index!)
        ctr += 1
    }
    
    if (to) {
        self.toSearchIndices = temp
        self.toSearch = true
 
        self.toTableView.reloadData()
        if (self.toCodeRow != -1) {
            print("setting selected to ",  self.toCodeRow)
            self.toTableView.selectRow(at: IndexPath(row: self.toCodeRow, section: 1), animated: false, scrollPosition: .none)
        }
    } else {
        self.fromSearchIndices = temp
        self.fromSearch = true
        self.fromTableView.reloadData()
        if (self.fromCodeRow != -1) {
            self.fromTableView.selectRow(at: IndexPath(row: self.fromCodeRow, section: 1), animated: false, scrollPosition: .none)
        }
    }
    
  }
    
    func selectRow(tableView: UITableView) {
        if (tableView == self.fromTableView) {
            if (fromCode != "") {
                let index = allLanguages.firstIndex(where: { (currLang) -> Bool in
                    currLang.code == fromCode // test if this is the item you're looking for
                })
                self.fromCodeRow = index!
                    tableView.selectRow(at: IndexPath(row: index!, section: 0), animated: false, scrollPosition: .none)
                    let cell = tableView.cellForRow(at: IndexPath(row: index!, section: 0))
                    cell?.accessoryType = .checkmark
                }
        } else {
            if (toCode != "") {
                let index = allLanguages.firstIndex(where: { (currLang) -> Bool in
                    currLang.code == toCode // test if this is the item you're looking for
                })
                print("setting tocode to \(index!)")
                self.toCodeRow = index!
                tableView.selectRow(at: IndexPath(row: index!, section: 0), animated: false, scrollPosition: .none)
                let cell = tableView.cellForRow(at: IndexPath(row: index!, section: 0))
                cell?.accessoryType = .checkmark

            }
        }
    }
    
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let to: Bool = (searchBar == self.toSearchBar)
    
    if searchText == "" {
        if (to) {
            self.toSearch = false
            self.toTableView.reloadData()
            self.selectRow(tableView: self.toTableView)
        } else {
            self.fromSearch = false
            self.fromTableView.reloadData()
            self.selectRow(tableView: self.fromTableView)
        }
    }
}

}


