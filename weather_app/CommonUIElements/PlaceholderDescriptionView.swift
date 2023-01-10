//
//  PlaceholderDescriptionView.swift
//
//  Created by Petru-Alexandru Lipici on 07.01.2023.
//

import UIKit
import SnapKit

class PlaceholderDescriptionView: UIView {
    
    struct Options {
        let placeholder: String
        let description: String
    }
    
    private let placeholderLabel = UIBuilder.makeRegularLabel(ofSize: 12)
    private let descriptionLabel = UIBuilder.makeMediumLabel(ofSize: 15, numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        configureSubviewsConstraints()
        configureSubviewsLayout()
    }
    
    private func configureSubviewsLayout() {
        backgroundColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(placeholderLabel)
        addSubview(descriptionLabel)
    }
    
    private func configureSubviewsConstraints() {
        placeholderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(placeholderLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func setContent(options: Options) {
        placeholderLabel.text = options.placeholder
        descriptionLabel.text = options.description
    }
}
