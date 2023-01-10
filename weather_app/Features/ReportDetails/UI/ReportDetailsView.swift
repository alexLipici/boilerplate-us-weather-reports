//
//  ReportDetailsView.swift
//  weather_app
//
//  Created by Petru-Alexandru Lipici on 10.01.2023.
//

import UIKit
import SnapKit

class ReportDetailsView: UIView {
    
    private let scrollView = UIBuilder.makeScrollView()
    private let contentStackView = UIBuilder.makeContentStackView(spacing: 8)
    lazy var avatar = makeAvatar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        configSubviewsConstraints()
        configSubviewsLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addSubviews() {
        scrollView.addSubview(contentStackView)
        
        addSubview(avatar)
        addSubview(scrollView)
    }
    
    private func configSubviewsConstraints() {
        avatar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(8)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configSubviewsLayout() {
        backgroundColor = .systemGroupedBackground
    }
    
    func setContent(viewModel: ReportDetailsViewModel) {
        attachPlaceholderDescriptionCard(options: .init(
            placeholder: "Valability:",
            description: viewModel.valability
        ))
        
        attachPlaceholderDescriptionCard(options: .init(
            placeholder: "Severity:",
            description: viewModel.severity
        ))
        
        attachPlaceholderDescriptionCard(options: .init(
            placeholder: "Certainty:",
            description: viewModel.certainty
        ))
        
        attachPlaceholderDescriptionCard(options: .init(
            placeholder: "Urgency:",
            description: viewModel.urgency
        ))
        
        attachPlaceholderDescriptionCard(options: .init(
            placeholder: "Source:",
            description: viewModel.source
        ))
        
        attachPlaceholderDescriptionCard(options: .init(
            placeholder: "Description:",
            description: viewModel.description
        ))
        
        let instructionsView = CollapsablePlaceholderDescriptionView()
        instructionsView.setContent(options: .init(
            placeholder: "Instructions:",
            description: viewModel.instructions
        ))
        
        contentStackView.addArrangedSubview(makeCardLayoutFor(instructionsView))
        
        contentStackView.addArrangedSubview(UIView())
    }
    
    func attachPlaceholderDescriptionCard(options: PlaceholderDescriptionView.Options) {
        let view = PlaceholderDescriptionView()
        view.setContent(options: options)
        
        contentStackView.addArrangedSubview(makeCardLayoutFor(view))
    }
}

extension ReportDetailsView {
    private func makeCardLayoutFor(_ view: UIView) -> UIView {
        let card = UIBuilder.makeCardView(cornerRadius: 7)
        card.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(
                top: 8,
                left: 16,
                bottom: 8,
                right: 16
            ))
        }
        
        return card
    }
    
    private func makeAvatar() -> UIImageView {
        let imageView = LongPressDraggableImage(frame: .zero)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }
}

