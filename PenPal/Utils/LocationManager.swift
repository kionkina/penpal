//
//  LocationController.swift
//  PenPal
//
//  Created by Karina Ionkina on 4/26/21.
//

import UIKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class LocationManager: NSObject {

    struct Initial: Decodable {
        var error: Bool
        var msg: String
        var data: [Country]
    }
    
    struct Country: Decodable {
        var name: String
        var iso3: String
        var states: [State]
    }

    struct State: Decodable {
        var name: String
        var state_code: String?
    }
    
    static let shared = LocationManager()
    
    var allCountries: [Country] = [Country]()
    
    
    func getCountriesandStates() {
    
        let semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: "https://countriesnow.space/api/v0.1/countries/states")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            //print(String(data: data, encoding: .utf8)!)
            let decoded = try! JSONDecoder().decode(Initial.self, from: data)
            //let decoded2 = try! JSONDecoder().decode([String: Any?], from: decoded["data"])
            for country in decoded.data {
                var states: [State] = [State]()
                for state in country.states {
                    states.append(State(name: state.name, state_code: state.state_code))
                }
                self.allCountries.append(Country(name: country.name, iso3: country.iso3, states: states))
            }
          semaphore.signal()
            print("All countries and states fetched")
        }

        task.resume()
        semaphore.wait()
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
