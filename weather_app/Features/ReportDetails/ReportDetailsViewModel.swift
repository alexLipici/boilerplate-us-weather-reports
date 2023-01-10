//
//  ReportDetailsViewModel.swift
//  weather_app
//
//  Created by Petru-Alexandru Lipici on 10.01.2023.
//

import Foundation
import RxSwift

class ReportDetailsViewModel: DashboardCellViewModel {
    
    let isLoading = PublishSubject<Bool>()
    let attachAffectedZone = PublishSubject<String>()
    
    var title: String {
        dataSource.properties.event ?? "Details"
    }
    
    var valability: String {
        String(format: "from: %@ to %@", startDate, endDate)
    }
    
    var severity: String {
        dataSource.properties.severity ?? Self.NONE
    }
    
    var certainty: String {
        dataSource.properties.certainty ?? Self.NONE
    }
    
    var urgency: String {
        dataSource.properties.urgency ?? Self.NONE
    }
    
    var description: String {
        dataSource.properties.propertiesDescription ?? Self.NONE
    }
    
    var instructions: String {
        dataSource.properties.instruction ?? Self.NONE
    }
        
    func viewDidLoad() {
        fetchAffectedZones()
    }
    
    private func fetchAffectedZones() {
        let dispatchGroup = DispatchGroup()
        
        var zones = [String]()
        
        isLoading.onNext(true)
        
        for zoneUrl in dataSource.properties.affectedZones ?? [] {
            dispatchGroup.enter()
            
            NetworkManager.shared.newBaseCall(url: zoneUrl) { (result: Result<AffectedZone, NetworkError>) in
                
                if case .success(let affectedZone) = result {
                    zones.append(affectedZone.name)
                }

                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            var affectedZones = ""
            
            for (index, zone) in zones.enumerated() {
                let string = String(format: "%i. %@\n", index + 1, zone)
                affectedZones.append(string)
            }
            
            self.isLoading.onNext(false)
            self.attachAffectedZone.onNext(affectedZones)
        }
    }
}
