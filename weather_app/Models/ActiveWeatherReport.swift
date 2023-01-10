//
//  ActiveWeatherReport.swift
//
//  Created by Petru-Alexandru Lipici on 06.01.2023.
//

import Foundation

class GetActiveWeatherReportsModel: Codable {
    let features: [Report]
}

    // MARK: - Report
class Report: Codable {
    let id: String?
    let properties: Properties?
}

    // MARK: - Properties
class Properties: Codable {
    let id, areaDesc: String?
    let affectedZones: [String]?
    private let _startDate, _endDate: String?
    let status, messageType, severity, certainty: String?
    let urgency, event, sender, senderName: String?
    let headline, propertiesDescription, instruction: String?
    
    var startDate: Date? {
        guard let date = _startDate else { return nil }
        
        let utcISODateFormatter = ISO8601DateFormatter()
        
        return utcISODateFormatter.date(from: date)
    }
    
    var endDate: Date? {
        guard let date = _endDate else { return nil }
        
        let utcISODateFormatter = ISO8601DateFormatter()
        
        return utcISODateFormatter.date(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, areaDesc, affectedZones, status, messageType, severity, certainty, urgency, event, sender, senderName, headline
        case propertiesDescription = "description"
        case instruction
        case _startDate = "effective"
        case _endDate = "ends"
    }
}
