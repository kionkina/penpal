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
        var name: String?
        var selected: Bool
        var imgUrl: String
    }

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var languages = [TranslationManager.TranslationLanguage]()
    var alreadySpoken = [TranslationLanguageCell]()
    var toLearn = [TranslationLanguageCell]()
    var pageType: String = "selectingAlreadySpokenLanguages"
    var searching: Bool = false
    // Indecies of search terms
    var searchTerms: [Int] = []
    
    // MARK: - Properties
    
    var alertCollection: GTAlertCollection!
   
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("IN PREPARE FOR SEGUE")
        if let identifier = segue.identifier {
            if identifier == "selectLanguagesSegue" {
                if let destinationVC = segue.destination as? LanguagesViewController {
                    destinationVC.pageType = "selectingLanguagesToLearn"
                    destinationVC.alreadySpoken = self.alreadySpoken
                }
            }
        }
    }
    
    // MARK: - Default Methods
    
    func loadLanguages() {
        print("in load lang")
        print(self.languages.count)
        for lang in languages {
            let imgUrl = "https://www.unknown.nu/flags/images/\(lang.code!)-100"
            if (self.pageType == "selectingAlreadySpokenLanguages") {
                self.alreadySpoken.append(TranslationLanguageCell(name: lang.name, selected: false, imgUrl: imgUrl))
            } else {
                self.toLearn.append(TranslationLanguageCell(name: lang.name, selected: false, imgUrl: imgUrl))
            }
        }
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            self.tableView.allowsMultipleSelection = true
            self.tableView.allowsMultipleSelectionDuringEditing = true
            self.languages = TranslationManager.shared.allLanguages
            self.loadLanguages()
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alertCollection = GTAlertCollection(withHostViewController: self)
        configureTableView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkForLanguagesExistence()
    }
    
    deinit {
        alertCollection = nil
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

    if (self.pageType == "selectingAlreadySpokenLanguages") {
        alertCollection.presentAlert(withTitle: "Getting to Know You", message: "Before we get started, we'd like to get to know you! Can you select the languages that you speak?", buttonTitles: ["Let's go!", "Not now"], cancelButtonIndex: 1, destructiveButtonIndices: nil) { (actionIndex) in

            // Check if user wants to fetch supported languages.
            if actionIndex == 0 {
                if (TranslationManager.shared.supportedLanguages.count == 0) {
                    self.fetchSupportedLanguages()
                }
            }
        }
    } else {
        alertCollection.presentAlert(withTitle: "Getting to Know You", message: "Which languages do you want to learn?", buttonTitles: ["Let's go!", "Not now"], cancelButtonIndex: 1, destructiveButtonIndices: nil) { (actionIndex) in

            // Check if user wants to fetch supported languages.
            if actionIndex == 0 {
                if (TranslationManager.shared.supportedLanguages.count == 0) {
                    self.fetchSupportedLanguages()
                }
            }
        }
    }

}

func fetchSupportedLanguages() {
        // Show a "Please wait..." alert.
        self.alertCollection.presentActivityAlert(withTitle: "One moment", message: "Fetching languages...") { (presented) in
     
            if presented {
                TranslationManager.shared.fetchSupportedLanguages(completion: { (success) in
                    // Dismiss the alert.
                    self.alertCollection.dismissAlert(completion: nil)
     
                    // Check if supported languages were fetched successfully or not.
                    if success {
                        print("success!")
                        // Display languages in the tableview.
                        DispatchQueue.main.async { [unowned self] in
                            self.languages = TranslationManager.shared.allLanguages
                            self.loadLanguages()
                        }
                    } else {
                        // Show an alert saying that something went wrong.
                        self.alertCollection.presentSingleButtonAlert(withTitle: "Supported Languages", message: "Oops! It seems that something went wrong and supported languages cannot be fetched.", buttonTitle: "OK", actionHandler: {
     
                        })
                    }
     
                })
            }
     
        }
    }
}


// MARK: - UITableViewDelegate
extension LanguagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if let cell = tableView.cellForRow(at: indexPath) as? LanguageCell {
            
            let index: Int = searching ? searchTerms[indexPath.row] : indexPath.row
            if (self.pageType == "selectingAlreadySpokenLanguages") {
                alreadySpoken[index].selected = !alreadySpoken[index].selected
            }
            else {
                toLearn[index].selected = !toLearn[index].selected
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? LanguageCell {
            
            let index: Int = searching ? searchTerms[indexPath.row] : indexPath.row
            
            if (self.pageType == "selectingAlreadySpokenLanguages") {
                alreadySpoken[index].selected = !alreadySpoken[index].selected
            }
            else {
                toLearn[index].selected = !toLearn[index].selected
            }
        }
    }
}




// MARK: - UITableViewDataSource
extension LanguagesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (self.pageType == "selectingAlreadySpokenLanguages") {
            return self.searching ? self.searchTerms.count : self.alreadySpoken.count
        }
        return self.searching ? self.searchTerms.count : self.toLearn.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "idLanguageCell", for: indexPath) as? LanguageCell else { return UITableViewCell() }

       
        var language = TranslationLanguageCell(name: "", selected: false, imgUrl: "")
        
        if (self.pageType == "selectingAlreadySpokenLanguages") {
            if (self.searching) {
                language = self.alreadySpoken[searchTerms[indexPath.row]]
            } else {
                language =  self.alreadySpoken[indexPath.row]
            }
        } else {
            if (self.searching) {
                language = self.toLearn[searchTerms[indexPath.row]]
            } else {
                language = self.toLearn[indexPath.row]
            }
        }
        

        cell.configure(isSelected: language.selected, name: language.name!, imgUrl: language.imgUrl)
        
        print("Setting cell to \(language.selected)")
        
        cell.setSelected(language.selected, animated: false)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    // MARK: - IBOutlets
        @IBAction func buttonOneTouched(_ sender: UIButton) {
            
            ("button pressed!")
            print(self.pageType)
            
            if (self.pageType == "selectingAlreadySpokenLanguages") {
                //Add selected to alreadySpoken
                self.performSegue(withIdentifier: "selectLanguagesSegue", sender: self)
            
            }
            else if (self.pageType == "selectingLanguagesToLearn") {
                //DB CALL
                
                print("ready for DB")
                print("already spoken: ")
                // Filter for spoken languages
                let spoken = alreadySpoken.filter({ $0.selected == true })
                // Reduce object to array of names
                let spokenLangNames: [String] = spoken.map{ $0.name! }
                print(spokenLangNames)
                
            
                
                print("toLearn: ")
                // Filter for selected languages
                let learn = toLearn.filter({ $0.selected == true })
                // Reduce to array of lang names
                let toLearnLangNames: [String] = learn.map { $0.name! }
                DBViewController.updateLanugaes(alreadySpoken: spokenLangNames, toLearn: toLearnLangNames)
                
                UserDefaults.standard.set(spokenLangNames, forKey: "langSpoken")
                
                UserDefaults.standard.setValue(toLearnLangNames, forKey: "langToLearn")
            
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()

            }
            
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
    
    if (self.pageType == "selectingAlreadySpokenLanguages") {
        for lang in self.alreadySpoken where (lang.name?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil) {
            let index = alreadySpoken.firstIndex(where: { (currLang) -> Bool in
                currLang.name == lang.name // test if this is the item you're looking for
            })
            temp.append(index!)
        }
        
        // Keeping track of selected indecies in new list
        var selectedRows: [IndexPath] = []
        for (ind, element) in temp.enumerated() {
            if (alreadySpoken[element].selected) {
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
    else {
        for lang in self.toLearn where (lang.name?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil) {
            let index = toLearn.firstIndex(where: { (currLang) -> Bool in
                currLang.name == lang.name // test if this is the item you're looking for
            })
            temp.append(index!)
        }
        self.searchTerms = temp
        self.searching = true
        tableView.reloadData()
        
    }
  }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            print("changed to empty")
            self.languages = TranslationManager.shared.allLanguages
            self.searching = false
            
            var selectedRows: [IndexPath] = []
            let cells = (self.pageType == "selectingAlreadySpokenLanguages") ? alreadySpoken : toLearn
            
           
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
