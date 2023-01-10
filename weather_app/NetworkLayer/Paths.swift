//
//  Paths.swift
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import Foundation

struct Paths {
    
    private struct BASE_API {
        private static let basePath: String =
            "https://api.weather.gov"
        
        static var unversioned: String {
            return String(format: "%@/", basePath)
        }
    }
    
    /**
     PATHS
     */
    
    static let GET_ACTIVE_ALERTS = "\(BASE_API.unversioned)alerts/active"
    static let RAW_AVATAR = "https://picsum.photos/1000"
}
