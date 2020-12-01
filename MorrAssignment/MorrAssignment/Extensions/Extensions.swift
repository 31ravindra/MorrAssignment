//
//  Extensions.swift
//  MorrAssignment
//
//  Created by Ravindra Patidar on 01/12/20.
//  Copyright © 2020 Ravindra Patidar. All rights reserved.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func isStringContainsOnlyNumbers() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func isContainOnlyAlphabatandWhiteSpace() -> Bool {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        
        if(self.rangeOfCharacter(from: set.inverted) != nil ){
              return false
        } else {
              return true
        }
    }
}
