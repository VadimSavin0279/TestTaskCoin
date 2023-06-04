//
//  UIButton + Extension.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//

import Foundation
import UIKit

extension UIButton {
    convenience init(imageName: String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
    }
}
