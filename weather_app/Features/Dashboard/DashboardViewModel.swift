//
//  DashboardViewModel.swift
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import Foundation
import RxSwift

class DashboardViewModel {
    
    private let remoteRepository: RemoteRepository<GetActiveWeatherReportsModel>
    
    let isLoading = PublishSubject<Bool>()
    let showError = PublishSubject<AppError>()
    let reloadData = PublishSubject<Void>()
    let showDetails = PublishSubject<ExtendedReport>()
    
    var objects: [ExtendedReport] = [] {
        didSet {
            reloadData.onNext(())
        }
    }
    
    init(remoteRepository: RemoteRepository<GetActiveWeatherReportsModel>) {
        self.remoteRepository = remoteRepository
    }
    
    func viewDidLoad() {
        DispatchQueue.global().async {
            self.getReports()
        }
    }
    
    private func getReports() {
        isLoading.onNext(true)
        
        let params: [String : String] = [
            "status" : "actual",
            "message_type" : "alert"
        ]
        
        remoteRepository.executeRequest(parameters: params) { [weak self] result in
            switch result {
            case .success(let response):
                self?.objects = response.features.compactMap({ ExtendedReport(report: $0) })
            case .failure(let error):
                self?.showError.onNext(error.toAppError())
            }
            
            self?.isLoading.onNext(false)
        }
    }
    
    func viewDidDissapear() {
        remoteRepository.cancelRequest()
    }
    
    func numberOfSections() -> Int {
        return objects.count
    }
    
    func makeCellViewModel(for indexPath: IndexPath) -> DashboardCellViewModel? {
        guard indexPath.section < objects.count else {
            return nil
        }
        
        return DashboardCellViewModel(dataSource: objects[indexPath.section])
    }
    
    func showDetails(for indexPath: IndexPath) {
        guard indexPath.section < objects.count else {
            return
        }
        
        showDetails.onNext(objects[indexPath.section])
    }
}
