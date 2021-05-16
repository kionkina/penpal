//
//  TranslationManager.swift
//  Translate
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Foundation

class TranslationManager: NSObject {
 
    static let shared = TranslationManager()
 
    private let apiKey = "AIzaSyBzqtM8K-mVsxaV1gK7RnR8KiEawAJMGqQ"
 
    var sourceLanguageCode: String?
    var languagenCodes: [String] = [String]()
    var langugaesDict = [String:TranslationLanguage]()
 
    struct TranslationLanguage {
        var name: String?
        var imgUrl: String?
    }
    
    // supported language codes (includes dialects)
    var supportedLanguages: [String] = []
    var allLanguages = [TranslationLanguage]()
    
    private func makeRequest(usingTranslationAPI api: TranslationAPI, urlParams: [String: String], completion: @escaping (_ results: [String: Any]?) -> Void) {
        print("making request")
        if var components = URLComponents(string: api.getURL()) {
            components.queryItems = [URLQueryItem]()
     
            for (key, value) in urlParams {
                components.queryItems?.append(URLQueryItem(name: key, value: value))
            }
     
            if let url = components.url {
                var request = URLRequest(url: url)

                let method = api.getHTTPMethod()
                print(method)
                request.httpMethod = method
     
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: request) { (results, response, error) in
                    if let error = error {
                        print(error)
                        completion(nil)
                    } else {
                        print("waiting for response")
                        if let response = response as? HTTPURLResponse, let results = results {
                            if response.statusCode == 200 || response.statusCode == 201 {
                                do {
                                    if let resultsDict = try JSONSerialization.jsonObject(with: results, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] {
                                        completion(resultsDict)
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        } else {
                            completion(nil)
                        }
                    }
                }
     
                task.resume()
            }
     
        }
    }
    
    func fetchSupportedLanguages(completion: @escaping (_ success: Bool) -> Void) {
        print("getting languages")
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["target"] = Locale.current.languageCode ?? "en"
        
        makeRequest(usingTranslationAPI: .supportedLanguages, urlParams: urlParams) { (results) in
            guard let results = results else { completion(false); return }
         
            if let data = results["data"] as? [String: Any], let languages = data["languages"] as? [[String: Any]] {
         
                for lang in languages {
                    var languageCode: String?
                    var languageName: String?
         
                    if let code = lang["language"] as? String {
                        languageCode = code
                    }
                    if let name = lang["name"] as? String {
                        languageName = name
                    }
         
                    // Housekeeping
                    
                    // First append code to supported languages and add to dict
                    // this includes dialects for translation
                    self.supportedLanguages.append(languageCode!)

                    // Add images to all languages except from dialects
                    if (languageCode != "zh-TW" && languageCode != "zh" && languageCode != "zh-CN"){
                        self.languagenCodes.append(languageCode!)
                        let imgUrl = "https://www.unknown.nu/flags/images/\(languageCode!)-100"
                        self.langugaesDict[languageCode!] = TranslationLanguage(name: languageName!, imgUrl: imgUrl)
                    }
                    else if (languageCode == "zh-CN") {
                        self.languagenCodes.append("zh")
                        let imgUrl = "https://www.unknown.nu/flags/images/zh-100"
                        self.langugaesDict["zh"] = TranslationLanguage(name: "Chinese", imgUrl: imgUrl)
                        self.langugaesDict[languageCode!] = TranslationLanguage(name: languageName!)
                    }
                    else if (languageCode == "zh") {
                        // Add name for zh-tw, zh, zh-CN
                        self.langugaesDict["zh-CN"] = TranslationLanguage(name: languageName!)
                    } else {
                        // Traditional
                        self.langugaesDict[languageCode!] = TranslationLanguage(name: languageName!)
                    }
                }
         
                completion(true)
         
            } else {
                completion(false)
            }
         
        }
    }
    
    func translate( textToTranslate: String, sourceLanugage: String, targetLanguage: String, completion: @escaping (_ translations: String?) -> Void) {
           
           var urlParams = [String: String]()
           urlParams["key"] = apiKey
           urlParams["q"] = textToTranslate
           urlParams["target"] = targetLanguage
           urlParams["format"] = "text"
           
           
           makeRequest(usingTranslationAPI: .translate, urlParams: urlParams) { (results) in
               guard let results = results else { completion(nil); return }
               
               if let data = results["data"] as? [String: Any], let translations = data["translations"] as? [[String: Any]] {
                   var allTranslations = [String]()
                   print("got results! ")
                   print(translations)
                   for translation in translations {
                       if let translatedText = translation["translatedText"] as? String {
                           allTranslations.append(translatedText)
                       }
                   }
                   
                   if allTranslations.count > 0 {
                       completion(allTranslations[0])
                   } else {
                       completion(nil)
                   }
                   
                   
               } else {
                   completion(nil)
               }
           }
       }
    
    
    override init() {
        super.init()
    }
}
