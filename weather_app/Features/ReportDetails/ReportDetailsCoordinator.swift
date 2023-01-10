//
//  ReportDetailsCoordinator.swift
//  weather_app
//
//  Created by Petru-Alexandru Lipici on 10.01.2023.
//

import Foundation

import UIKit
import RxSwift

enum ReportDetailsCoordinationResult: Equatable {
    case dismissed
}

class ReportDetailsCoordinator: BaseCoordinator<ReportDetailsCoordinationResult> {
        
    private var navigationController: UINavigationController
    private let viewModel: ReportDetailsViewModel
    
    required init(navigationController: UINavigationController, dataSource: ExtendedReport) {
        self.navigationController = navigationController
        self.viewModel = ReportDetailsViewModel(dataSource: dataSource)
    }
    
    override func start() -> Observable<CoordinateResultType<CoordinationResult>> {
        let vc = ReportDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
        
        let dismissObserver = vc.rx.didPop
            .map { CoordinateResultType.executeAndFreeUpTheCoordinator(
                CoordinationResult.dismissed) }
        
        return Observable.merge(dismissObserver)
            .take(1)
    }
}
