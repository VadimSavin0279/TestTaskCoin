//
//  String + Extension.swift
//  TestTaskCoin
//
//  Created by 123 on 02.06.2023.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
    
    func round(with value: Int) -> String {
        if let index = self.firstIndex(of: ".") {
            
            let index2 = self.index(index, offsetBy: value + 1)
            return String(self[..<index2])
        }
        return "null"
    }
    
    func roundToSignificantFigure() -> String{
        var newStr = self
        let indexOfDot = newStr.firstIndex(of: ".")
        var indexOfFirstNumber: String.Index?
    
        var indexOfExponent: String.Index?
        var exponent: String = ""
        
        for ch in newStr {
            if ch == "0" || ch == "." {
                continue
            } else {
                indexOfFirstNumber = newStr.firstIndex(of: ch)
                break
            }
        }
        
        indexOfExponent = newStr.firstIndex(of: "e")
        if let indexOfExponent = indexOfExponent {
            exponent = String(newStr[indexOfExponent...])
        }
        
        if indexOfFirstNumber?.utf16Offset(in: newStr) ?? 0 > indexOfDot?.utf16Offset(in: newStr) ?? 1 {
            newStr = newStr.round(with: indexOfFirstNumber?.utf16Offset(in: newStr) ?? 2)
        } else {
            newStr = newStr.round(with: 2)
        }
        
        return newStr + exponent
    }
}

