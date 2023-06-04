//
//  StatisticView.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//

import Foundation
import UIKit

extension UIStackView {
    convenience init(partName: String, statisticText: String) {
        self.init()
        let labelPart = UILabel()
        labelPart.text = partName
        labelPart.textColor = .white.withAlphaComponent(0.5)
        labelPart.font = .systemFont(ofSize: 12)
        
        let statisticLabel = UILabel()
        statisticLabel.text = statisticText
        statisticLabel.textColor = .white
        
        axis = .vertical
        distribution = .fillProportionally
        
        addArrangedSubview(labelPart)
        addArrangedSubview(statisticLabel)
    }
}
