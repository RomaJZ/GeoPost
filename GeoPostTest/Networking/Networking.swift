//
//  Networking.swift
//  GeoPostTest
//
//  Created by Roma Filipenko on 03.07.2020.
//  Copyright © 2020 Roma&Co. All rights reserved.
//

import Foundation

enum APIError: Error {
    
    case badResponce, jsonEncoder, badData
}

class GeoAPI {
    
    private let urlString = "https://team24.biz/api/geo"
    
    func postGeo(geoData: GeoModel) {
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONEncoder().encode(geoData)
        } catch let error {
            print(error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                print(APIError.badResponce)
                return
            }
            
            print(response)
        }.resume()
    }
}
