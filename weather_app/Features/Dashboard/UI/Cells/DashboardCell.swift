//
//  DashboardCell.swift
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit
import SnapKit

class DashboardCell: UITableViewCell {
    
    private lazy var contentStackView = UIBuilder.makeContentStackView(spacing: 1)
    private lazy var avatarTitleView = AvatarTitleView()
    private lazy var startDateView = PlaceholderDescriptionView()
    private lazy var endDateView = PlaceholderDescriptionView()
    private lazy var sourceView = PlaceholderDescriptionView()
    
    var viewModel: DashboardCellViewModel? {
        didSet { configureCell() }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        
        addSubviews()
        configureSubviewsLayout()
    }
    
    private func configureCell() {
        guard let viewModel = viewModel else { return }
        
        avatarTitleView.setContent(options: .init(name: viewModel.name))
        viewModel.loadThumbnail { [weak self] image in
            self?.avatarTitleView.avatar.image = image
        }
        
        startDateView.setContent(options: .init(placeholder: "Starting with:", description: viewModel.startDate))
        endDateView.setContent(options: .init(placeholder: "Until:", description: viewModel.endDate))
        sourceView.setContent(options: .init(placeholder: "Emitted by:", description: viewModel.source))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(avatarTitleView)
        contentStackView.addArrangedSubview(startDateView)
        contentStackView.addArrangedSubview(endDateView)
        contentStackView.addArrangedSubview(sourceView)
    }
    
    private func configureSubviewsLayout() {
        contentStackView.backgroundColor = .separator
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
    }
}

struct DashboardCellPovider {
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func cellForRow(cellViewModel: DashboardCellViewModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell") as! DashboardCell
        cell.viewModel = cellViewModel
        
        return cell
    }
}
