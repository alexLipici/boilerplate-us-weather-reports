//
//  DashboardCoordinator.swift
//
//  Created by Petru-Alexandru Lipici on 08.11.2022.
//

import UIKit
import RxSwift

enum DashboardCoordinationResult: Equatable { }

class DashboardCoordinator: BaseCoordinator<DashboardCoordinationResult> {
    
    private let window: UIWindow!
    
    private var navigationController: UINavigationController!
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<CoordinateResultType<CoordinationResult>> {
        let remoteRepository = GetActiveWeatherReportsRepository()
        let viewModel = DashboardViewModel(remoteRepository: remoteRepository)
        let vc = DashboardViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        viewModel.showDetails
            .subscribe(onNext: { [weak self] in
                self?.showDetails(report: $0)
            })
            .disposed(by: disposeBag)
        
        return .never()
    }
    
    private func showDetails(report: ExtendedReport) {
        let coordinator = ReportDetailsCoordinator(
            navigationController: navigationController,
            dataSource: report
        )
        
        coordinate(to: coordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }
}


