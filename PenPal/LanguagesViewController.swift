//
//  LanguagesViewController.swift
//  Translate
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import UIKit



class LanguagesViewController: UIViewController  {
    
    struct TranslationLanguageCell {
        var code: String
        var name: String
        var imgUrl: String
        var selected: Bool
    }

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var selectedLanguages = [TranslationLanguageCell]()

    var pageType: String = "selectingAlreadySpokenLanguages"
    var searching: Bool = false
    // Indecies of search terms
    var searchTerms: [Int] = []
   
    public var onDoneEditing: (() -> ())?
      
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("IN PREPARE FOR SEGUE")
        if let identifier = segue.identifier {
            if identifier == "selectLanguagesSegue" {
                if let destinationVC = segue.destination as? LanguagesViewController {
                    destinationVC.pageType = "selectingLanguagesToLearn"
                }
            }
        }
    }
    
    // MARK: - Default Methods
    
    func loadLanguages() {
        //print("all codes: ")
        //print(TranslationManager.shared.languagenCodes)
        for langCode in TranslationManager.shared.languagenCodes {
            let langData = TranslationManager.shared.langugaesDict[langCode]
            var selected: Bool = false
            print("in load languages")
            
            if pageType == "selectingAlreadySpokenLanguages" {
                print("selecting from: \(User.current.langSpoken)")
                selected = User.current.langSpoken.contains(langCode)
            } else {
                print("selecting from: \(User.current.langToLearn)")
                selected = User.current.langToLearn.contains(langCode)
            }
            
            selectedLanguages.append(TranslationLanguageCell(code: langCode, name: langData!.name!, imgUrl: langData!.imgUrl!, selected: selected))
        }
        print("reloading")
       
        self.tableView.reloadData()

    }
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            self.searching = false
            self.tableView.allowsMultipleSelection = true
            self.tableView.allowsMultipleSelectionDuringEditing = true
        
        if self.pageType == "selectingAlreadySpokenLanguages" {
            self.title = "Select Languages Already Spoken"
        } else {
            self.title = "Select Languages to Learn"
        }
            
            self.loadLanguages()
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTableView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkForLanguagesExistence()
    }
    
    deinit {
        
    }
    
    // MARK: - Unwind
    
    @IBAction func unwindToLang(_ segue: UIStoryboardSegue) {
        print("Returned to Login Screen!")
    }
    
    // MARK: - Custom Methods
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //tableView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "idLanguageCell")
    }
    
 

func checkForLanguagesExistence() {
    // Check if supported languages have been fetched by looking at the
    // number of items in the supported languages collection of the
    // TranslationManager shared instance.
    // If it's zero, no languages have been fetched, so ask user
    // if they want to fetch them now.
/*
    if (self.pageType == "selectingAlreadySpokenLanguages") {
        alertCollection.presentAlert(withTitle: "Getting to Know You", message: "Before we get started, we'd like to get to know you! Can you select the languages that you speak?", buttonTitles: ["Let's go!", "Not now"], cancelButtonIndex: 1, destructiveButtonIndices: nil) { (actionIndex) in

            // Check if user wants to fetch supported languages.
            if actionIndex == 0 {
                if (TranslationManager.shared.supportedLanguages.count == 0) {
                    //self.fetchSupportedLanguages()
                }
            }
        }
    } else {
        alertCollection.presentAlert(withTitle: "Getting to Know You", message: "Which languages do you want to learn?", buttonTitles: ["Let's go!", "Not now"], cancelButtonIndex: 1, destructiveButtonIndices: nil) { (actionIndex) in

            // Check if user wants to fetch supported languages.
            if actionIndex == 0 {
                if (TranslationManager.shared.supportedLanguages.count == 0) {
                    //self.fetchSupportedLanguages()
                }
            }
        }
    }*/
 }
}



// MARK: - UITableViewDelegate
extension LanguagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if (tableView.cellForRow(at: indexPath) as? LanguageCell) != nil {
            
            let index: Int = searching ? searchTerms[indexPath.row] : indexPath.row
            
            selectedLanguages[index].selected = !selectedLanguages[index].selected

        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if (tableView.cellForRow(at: indexPath) as? LanguageCell) != nil {
            
            let index: Int = searching ? searchTerms[indexPath.row] : indexPath.row
            
            selectedLanguages[index].selected = !selectedLanguages[index].selected
            
        }
    }
}




// MARK: - UITableViewDataSource
extension LanguagesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        return self.searching ? self.searchTerms.count : self.selectedLanguages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "idLanguageCell", for: indexPath) as? LanguageCell else { return UITableViewCell() }

       
        var language = TranslationLanguageCell(code:"", name: "", imgUrl: "", selected: false)

        if (self.searching) {
            language = self.selectedLanguages[searchTerms[indexPath.row]]
        } else {
            language =  self.selectedLanguages[indexPath.row]
        }
      
        
        cell.configure(name: language.name, imgUrl: language.imgUrl)
        
        print("Setting cell to \(language.selected)")

        cell.setSelected(language.selected, animated: false)
        if (language.selected) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition:  .none)
            //cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    // MARK: - IBAction
        @IBAction func buttonOneTouched(_ sender: UIButton) {
            
           
            
            if (self.pageType == "selectingAlreadySpokenLanguages") {
                print("pagetype is already spoken")
                
                //DB CALL on callback perform segueue
                let spoken = self.selectedLanguages.filter({ $0.selected == true })
                // Reduce object to array of names
                let spokenLangCodes: [String] = spoken.map{ $0.code }
                
                if (spokenLangCodes.count == 0){
                    displayNoChoiceAlert(message: "Please choose at least one language")
                }
                else if (spokenLangCodes.count > 10){
                    displayNoChoiceAlert(message: "Impressive! But please choose no more than 10 languages")
                }
                else {
                
               
                
                //case 1: we are setting initial fields and moving to next VC
                    if (self.onDoneEditing == nil) {
                        User.current.langSpoken = spokenLangCodes
                        self.performSegue(withIdentifier: "selectLanguagesSegue", sender: self)
                    }
                    else {
                        //case 2: we are editing and call the closure from parent
                        print("done editing! about to set spoken!")
                        print("updating DB... ")
                        if (User.current.langSpoken != spokenLangCodes){
                            User.current.langSpoken = spokenLangCodes
                            DBViewController.setSpoken {
                                print("updating userDefs 1")
                                User.setCurrent(User.current, writeToUserDefaults: true)
                                self.onDoneEditing!()
                        }
                    }
                        else {
                            print("no change")
                            self.onDoneEditing!()
                        }
                    }
                }
            }
            else if (self.pageType == "selectingLanguagesToLearn") {
                //DB CALL
                print("pagetype is to learn")
                let learn = selectedLanguages.filter({ $0.selected == true })
                // Reduce to array of lang names

                let toLearnLangCodes: [String] = learn.map { $0.code }
                
                print("toLearnCodes: ", toLearnLangCodes)
                
                if (toLearnLangCodes.count == 0) {
                    displayNoChoiceAlert(message: "Please choose at least one language")
                }
                else if (toLearnLangCodes.count > 10){
                    displayNoChoiceAlert(message: "We love the ambition, but please choose no more than 10 languages")
                }
                

                if (self.onDoneEditing == nil) {
                    User.current.langToLearn = toLearnLangCodes
                    self.performSegue(withIdentifier: "selectLocationSegue", sender: self)
                }
                else {
                    if (User.current.langToLearn != toLearnLangCodes){
                        User.current.langToLearn = toLearnLangCodes
                        DBViewController.setLearning {
                            print("updating userDefs 2")
                            //UserDefaults.standard.setValue(User.current.langToLearn, forKey: "langToLearn")
                            
                            User.setCurrent(User.current, writeToUserDefaults: true)
                            self.onDoneEditing!()
                        }
                    }
                    else {
                        //no changes
                        print("no change")
                        self.onDoneEditing!()
                    }
                }
            }
            
        }
    
    func displayNoChoiceAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}



// MARK: - Search Bar Delegate
extension LanguagesViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    print("The search text is: '\(searchBar.text!)'")
    var temp: [Int] = []
    if (searchBar.text!.count == 0) {
        self.searching = false
        self.tableView.reloadData()
        return
    }
    
    for lang in self.selectedLanguages where (lang.name.lowercased().range(of: (searchBar.text?.lowercased())!) != nil) {
        let index = selectedLanguages.firstIndex(where: { (currLang) -> Bool in
            currLang.name == lang.name // test if this is the item you're looking for
        })
        temp.append(index!)
    }
    
    // Keeping track of selected indecies in new list
    var selectedRows: [IndexPath] = []
    for (ind, element) in temp.enumerated() {
        if (selectedLanguages[element].selected) {
            let indexPath = IndexPath(row: ind, section: 0)
            selectedRows.append(indexPath)
        }
    }
    
    self.searchTerms = temp
    self.searching = true
    tableView.reloadData()

    DispatchQueue.main.async {
        selectedRows.forEach { selectedRow in
            self.tableView.selectRow(at: selectedRow, animated: false, scrollPosition: .none)
        }
    }
  }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            print("changed to empty")
            self.searching = false
            
            var selectedRows: [IndexPath] = []
            let cells = self.selectedLanguages
            
           
            for (ind, cell) in cells.enumerated() {
                if (cell.selected) {
                    let indexPath = IndexPath(row: ind, section: 0)
                    selectedRows.append(indexPath)
                }
            }
            tableView.reloadData()
            DispatchQueue.main.async {
                selectedRows.forEach { selectedRow in
                    self.tableView.selectRow(at: selectedRow, animated: false, scrollPosition: .none)
                }
            }
            print("updating selection")
        }
    }
    
}
