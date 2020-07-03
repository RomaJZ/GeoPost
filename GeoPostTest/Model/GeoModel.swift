//
//  GeoModel.swift
//  GeoPostTest
//
//  Created by Roma Filipenko on 03.07.2020.
//  Copyright © 2020 Roma&Co. All rights reserved.
//

import Foundation

struct GeoModel: Codable {
    let time: Double
    let lat: Double
    let lon: Double
    
    enum codingKeys: String, CodingKey {
        case time = "time"
        case lat = "lat"
        case lon = "lon"
    }
}
