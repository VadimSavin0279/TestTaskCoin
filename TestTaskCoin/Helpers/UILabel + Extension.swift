//
//  UILabel + Extension.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(text: String, textColor: UIColor, font: UIFont) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}
