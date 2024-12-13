//
//  APIService.swift
//  VoiceChef3
//
//  Created by Annamaria Fidanza on 12/11/24.
//

import Foundation

func callAPI<T: Decodable>(_ urlString: String) async -> T? {
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    do {
        print("Request for \(urlString)")
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        
        guard httpResponse.statusCode == 200 else {
            print("HTTP Error \(httpResponse.statusCode)")
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(T.self, from: data) else {
            print("Error parsing JSON")
            return nil
        }
        
        return result
    } catch {
        return nil
    }
}
