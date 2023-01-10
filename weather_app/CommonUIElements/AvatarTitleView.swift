//
//  AvatarTitleView.swift
//  weather_app
//
//  Created by Petru-Alexandru Lipici on 07.01.2023.
//

import UIKit
import SnapKit

class AvatarTitleView: UIView {

    struct Options {
        let name: String
    }
    
    let nameLabel = UIBuilder.makeMediumLabel(ofSize: 15)
    
    private(set) lazy var avatar = makeAvatarImageView()
    
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
    
    func addSubviews() {
        addSubview(nameLabel)
        addSubview(avatar)
    }
    
    func configureSubviewsConstraints() {
        avatar.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(48)
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatar.snp.centerY)
            make.trailing.equalToSuperview()
            make.leading.equalTo(avatar.snp.trailing).offset(16)
        }
    }
    
    func setContent(options: Options) {
        nameLabel.text = options.name
    }
}

extension AvatarTitleView {
    private func makeAvatarImageView() -> UIImageView {
        return UIImageView(block: {
            $0.layer.cornerRadius = 24
            $0.layer.masksToBounds = true
        })
    }
}
