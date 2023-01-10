//
//  SplashView.swift
//
//  Created by Petru-Alexandru Lipici on 08.11.2022.
//

import UIKit
import SnapKit

class SplashView: UIView {
    
    private lazy var imageView: UIImageView = {
        makeImageView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubviews()
        configSubviewsConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addSubviews() {
        addSubview(imageView)
    }
    
    private func configSubviewsConstraints() {
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension SplashView {
    private func makeImageView() -> UIImageView {
        let config = UIImage.SymbolConfiguration(pointSize: 55, weight: .black)
        let image = UIImage(systemName: "cloud.moon.rain.fill", withConfiguration: config)
        
        return UIImageView(image: image)
    }
}
