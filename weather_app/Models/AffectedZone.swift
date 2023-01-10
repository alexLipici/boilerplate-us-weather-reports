//
//  AffectedZone.swift
//  weather_app
//
//  Created by Petru-Alexandru Lipici on 10.01.2023.
//

import Foundation

struct AffectedZone: Decodable {
    let id: String
    let name: String
    
    enum CodingKeys: CodingKey {
        case id
        case properties
        case name
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let propertiesContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .properties)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try propertiesContainer.decode(String.self, forKey: .name)
        
    }
}
