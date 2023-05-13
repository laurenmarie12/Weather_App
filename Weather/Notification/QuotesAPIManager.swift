//
//  QuotesAPIManager.swift
//  Weathermain
//
//  Created by Lauren Mangla on 5/10/23.
//

import Foundation

class QuotesAPIManager {
    static let shared = QuotesAPIManager()
    private let apiKey = "N0In2Z3FOOKHLCtfnAFOWc4IM0IoyPP4n2joHpnA" // Replace with your API key
    private let baseURL = "https://quotes.rest/qod"

    public init() {}
    
    
    func fetchRandomQuote(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(baseURL)?api_key=\(apiKey)") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let contents = json["contents"] as? [String: Any],
                       let quotes = contents["quotes"] as? [[String: Any]],
                       let quote = quotes.first?["quote"] as? String {
                        completion(quote)
                    } else {
                        completion(nil)
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                    completion(nil)
                }
            } else {
                print("Error fetching quote: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchrandomQuote2(completionHandler: @escaping (String?) -> Void) {
        let url = URL(string: "http://localhost:3000/quote")!
        var out:String = ""
        
        let task = URLSession.shared.dataTask(with:url, completionHandler:{(data, response, error) in
            // debugPrint("started task")
            if let error = error {
                out = "Error fetching quote: \(error)"
                // debugPrint(out)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...209).contains(httpResponse.statusCode) else {
                out = "Error fetching response"
                // debugPrint(out)
                return
            }
                
            if let data = data {
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        for jsonObject in jsonArray {
                            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                               let _ = String(data: jsonData, encoding: .utf8) {
                                if let quote = jsonObject["quote"] as? String {
                                    out = quote
                                    debugPrint(out)
                                }
                            }
                        }
                    }
                } catch {
                    out = "Error parsing JSON"
                    // debugPrint(out)
                }
            }
        })
        task.resume()
    }
    
    func fetchRandomQuote3() async throws -> String? {
        var out: String = "initialized"
        let url = URL(string: "http://localhost:3000/quote")!
        let urlRequest = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...209).contains(httpResponse.statusCode) else {
                out = "Error fetching response"
                // debugPrint(out)
                return(out)
            }
                
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    for jsonObject in jsonArray {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                           let _ = String(data: jsonData, encoding: .utf8) {
                            if let quote = jsonObject["quote"] as? String {
                                out = quote
                                // debugPrint(out)
                                return(out)
                            }
                        }
                    }
                }
                } catch {
                    out = "Error parsing JSON"
                    // debugPrint(out)
                    return(out)
            }
        } catch {
            out = "Error retrieving API response"
            // debugPrint(out)
            return(out)
        }
        return(out)
    }
}
