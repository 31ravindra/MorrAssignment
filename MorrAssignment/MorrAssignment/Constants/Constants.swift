//
//  Constants.swift
//  MorrAssignment
//
//  Created by Ravindra Patidar on 30/11/20.
//  Copyright © 2020 Ravindra Patidar. All rights reserved.
//

import Foundation


struct Constants {
    static let screenTitle = "Credit Card Input"
}

struct Colors {
    static let blueHex = "#3c4faf"
}


enum CardType: String {
    case Unknown, Amex, Visa, MasterCard, Discover
    
    static let allCards = [Amex, Visa, MasterCard, Discover]
    
    var regex : String {
        switch self {
        case .Amex:
            return "^3[47][0-9]{5,}$"
        case .Visa:
            return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
            return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .Discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        default:
            return ""
        }
    }
}

