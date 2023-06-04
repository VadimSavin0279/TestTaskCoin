//
//  LineView.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//

import Foundation
import UIKit

class LineView: UIView {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        widthAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
