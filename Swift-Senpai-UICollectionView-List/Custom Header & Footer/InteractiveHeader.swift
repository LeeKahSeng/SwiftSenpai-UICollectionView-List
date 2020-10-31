//
//  InteractiveHeader.swift
//  Swift-Senpai-UICollectionView-List
//
//  Created by Lee Kah Seng on 29/10/2020.
//

import UIKit

class InteractiveHeader: UICollectionReusableView {
    
    let titleLabel = UILabel()
    let infoButton = UIButton(type: .infoLight)
    
    var buttonDidTappedCallback: ((UIButton) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
}

extension InteractiveHeader {
    func configure() {
        
        let stackView1 = UIStackView()
        stackView1.axis = .horizontal
        stackView1.alignment = .fill
        stackView1.distribution = .fill
        stackView1.spacing = 20
        addSubview(stackView1)
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView1.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView1.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView1.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView1.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        stackView1.addArrangedSubview(titleLabel)


        infoButton.addAction(UIAction(handler: { [unowned self] (action) in
            let button = action.sender as! UIButton
            self.buttonDidTappedCallback?(button)
        }), for: .touchUpInside)
        
        stackView1.addArrangedSubview(infoButton)
        
        
//        let stackView2 = UIStackView()
//        stackView2.axis = .horizontal
//        stackView2.alignment = .fill
//        stackView2.distribution = .fillEqually
//        stackView2.spacing = 10
//
//        button1.backgroundColor = .systemRed
//        button1.layer.cornerRadius = 5
//
//        button1.addAction(UIAction(handler: { [unowned self] (action) in
//            let button = action.sender as! UIButton
//            self.buttonDidTappedCallback?(button)
//        }), for: .touchUpInside)
//
//
//
//        stackView2.addArrangedSubview(button1)
//
//        button2.backgroundColor = .systemGreen
//        button2.layer.cornerRadius = 5
//        stackView2.addArrangedSubview(button2)
//
//        button3.backgroundColor = .systemBlue
//        button3.layer.cornerRadius = 5
//        stackView2.addArrangedSubview(button3)
//
//
//        stackView1.addArrangedSubview(stackView2)
        
        
        
//        let config = SFSymbolNameContentConfiguration(name: "LKS")
//        let containerView = SFSymbolNameContentView(configuration: config)
//
//        addSubview(containerView)
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
//            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
//            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
//            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
//        ])
        
    }
}
