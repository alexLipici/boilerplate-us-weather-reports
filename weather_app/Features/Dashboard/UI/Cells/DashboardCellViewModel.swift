//
//  DashboardCellViewModel.swift
//  weather_app
//
//  Created by Petru-Alexandru Lipici on 06.01.2023.
//

import Foundation
import UIKit

class DashboardCellViewModel {
    static let NONE = "n/a"
    
    let dataSource: ExtendedReport
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy - HH:mm"
        return formatter
    }
    
    var name: String {
        return dataSource.properties.event ?? Self.NONE
    }
    
    var avatar: String {
        return dataSource.avatarURL
    }
    
    var startDate: String {
        guard let date = dataSource.properties.startDate else { return Self.NONE }
        
        return dateFormatter.string(from: date)
    }
    
    var endDate: String {
        guard let date = dataSource.properties.endDate else { return Self.NONE }
        
        return dateFormatter.string(from: date)
    }
    
    var source: String {
        return dataSource.properties.senderName ?? Self.NONE
    }
    
    init(dataSource: ExtendedReport) {
        self.dataSource = dataSource
    }
    
    func loadThumbnail(imageChanged: @escaping (UIImage) -> Void) {
        let placeholder = UIImage(systemName: "circles.hexagonpath.fill")!
        
        imageChanged(placeholder)
        
        ImageDownloader.shared.downloadImage(url: dataSource.avatarURL, includeCache: dataSource.avatarFetchedOnce) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let successResult):
                DispatchQueue.main.async {
                    imageChanged(successResult.image)
                    self.dataSource.setNewAvatarURL(successResult.redirectedUrl)
                }
            default: break
            }
        }
    }
}
