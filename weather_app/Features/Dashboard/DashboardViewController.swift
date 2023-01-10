//
//  DashboardViewController.swift
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit
import RxSwift
import PKHUD

class DashboardViewController: UIViewController {

    private let viewModel: DashboardViewModel
    private lazy var cellProvider = DashboardCellPovider(tableView: _view.tableView)
        
    private let disposeBag = DisposeBag()
    
    private var _view: DashboardView {
        return view as! DashboardView
    }
    
    override func loadView() {
        view = DashboardView(frame: .zero)
    }
    
    required init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingDismissed {
            viewModel.viewDidDissapear()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
        addSubscribers()
        viewModel.viewDidLoad()
    }

    private func customizeUI() {
        title = "Active alerts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        _view.tableView.register(DashboardCell.self, forCellReuseIdentifier: "DashboardCell")
        _view.tableView.delegate = self
        _view.tableView.dataSource = self
    }
    
    private func addSubscribers() {
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                DispatchQueue.main.async {
                    self?.showLoading(isLoading)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadData
            .subscribe(onNext: { [weak self] in
                self?._view.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.showError
            .subscribe(onNext: { [weak self] in
                self?.showError($0)
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

    private func showError(_ error: AppError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(cancel)
            
            self.present(alert, animated: true)
        }
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return .init()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return .init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel.makeCellViewModel(for: indexPath) else {
            return UITableViewCell()
        }
        
        return cellProvider.cellForRow(cellViewModel: cellViewModel)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetails(for: indexPath)
    }
}
