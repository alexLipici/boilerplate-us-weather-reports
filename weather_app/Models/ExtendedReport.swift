//
//  DashboardDataSource.swift
//  weather_app
//
//  Created by Petru-Alexandru Lipici on 10.01.2023.
//

import Foundation

class ExtendedReport {
    private(set) var avatarURL: String
    let properties: Properties
    
    var avatarFetchedOnce: Bool {
        avatarURL != Paths.RAW_AVATAR
    }
    
    init?(report: Report) {
        guard report.properties != nil else { return nil }
        
        self.properties = report.properties!
        avatarURL = Paths.RAW_AVATAR
    }
}

extension ExtendedReport {
    func setNewAvatarURL(_ url: String) {
        avatarURL = url
    }
}
