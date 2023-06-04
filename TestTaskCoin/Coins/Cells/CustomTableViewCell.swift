//
//  CustomTableViewCell.swift
//  TestTaskCoin
//
//  Created by 123 on 02.06.2023.
//

import UIKit
import Kingfisher

class CustomTableViewCell: UITableViewCell {
    private let imageViewOfCoin = UIImageView()
    private let nameOfCoinLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    private let shortNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white.withAlphaComponent(0.5)
        return label
    }()
    private let costCoinLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        let vertSVWithName = UIStackView(arrangedSubviews: [nameOfCoinLabel, shortNameLabel])
        vertSVWithName.axis = .vertical
        vertSVWithName.isLayoutMarginsRelativeArrangement = true
        vertSVWithName.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        vertSVWithName.distribution = .fillProportionally
        
        let vertSVWithCost = UIStackView(arrangedSubviews: [costCoinLabel, percentageLabel])
        vertSVWithCost.axis = .vertical
        costCoinLabel.textAlignment = .right
        percentageLabel.textAlignment = .right
        vertSVWithCost.isLayoutMarginsRelativeArrangement = true
        vertSVWithCost.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        vertSVWithCost.distribution = .fillProportionally
        
        let horSV = UIStackView(arrangedSubviews: [imageViewOfCoin, vertSVWithName, vertSVWithCost])
        horSV.axis = .horizontal
        horSV.translatesAutoresizingMaskIntoConstraints = false
        horSV.spacing = 10
        horSV.isLayoutMarginsRelativeArrangement = true
        horSV.layoutMargins = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        
        addSubview(horSV)
        NSLayoutConstraint.activate([
            horSV.topAnchor.constraint(equalTo: topAnchor),
            horSV.leadingAnchor.constraint(equalTo: leadingAnchor),
            horSV.trailingAnchor.constraint(equalTo: trailingAnchor),
            horSV.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageViewOfCoin.widthAnchor.constraint(equalTo: imageViewOfCoin.heightAnchor, multiplier: 1)
        ])
        
        backgroundColor = .clear
    }
    
    func setupCell(model: ResponseDataModel.CoinModel) {
        nameOfCoinLabel.text = model.name
        shortNameLabel.text = model.symbol
        costCoinLabel.text = model.priceUsd
        percentageLabel.text = model.changePercent24Hr
        setupPercentageColor(changePercent: model.changePercent24Hr ?? "")
        
        imageViewOfCoin.kf.setImage(
            with: CryptoIconURLBilder.getURL(for: model.symbol.lowercased()),
            placeholder: UIImage(named: "placeholder"),
            options: [
            .cacheOriginalImage
        ])
    }
    
    private func setupPercentageColor(changePercent: String) {
        if changePercent.first == "-" {
            percentageLabel.textColor = UIColor(named: "percentageRedColor")
        } else {
            percentageLabel.textColor = UIColor(named: "percentageGreenColor")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


