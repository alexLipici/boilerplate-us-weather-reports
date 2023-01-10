//
//  ReportDetailsViewController.swift
//  weather_app
//
//  Created by Petru-Alexandru Lipici on 10.01.2023.
//

import UIKit
import RxSwift
import PKHUD

class ReportDetailsViewController: UIViewController {
    
    private let viewModel: ReportDetailsViewModel
    
    private let disposeBag = DisposeBag()
    
    private var _view: ReportDetailsView {
        return view as! ReportDetailsView
    }
    
    override func loadView() {
        view = ReportDetailsView(frame: .zero)
    }
    
    required init(viewModel: ReportDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
        addSubscribers()
        
        viewModel.viewDidLoad()
    }
    
    private func customizeUI() {
        title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        viewModel.loadThumbnail { [weak self] image in
            self?._view.avatar.image = image
        }
        
        _view.setContent(viewModel: viewModel)
    }
    
    private func addSubscribers() {
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                DispatchQueue.main.async {
                    self?.showLoading(isLoading)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.attachAffectedZone
            .subscribe(onNext: { [weak self] in
                self?._view.attachPlaceholderDescriptionCard(options: .init(
                    placeholder: "Affected zones:",
                    description: $0
                ))
            })
            .disposed(by: disposeBag)
    }
     
    private func showLoading(_ show: Bool) {
        if show {
            HUD.show(.progress)
        } else {
            HUD.hide(animated: true)
        }
    }
}
