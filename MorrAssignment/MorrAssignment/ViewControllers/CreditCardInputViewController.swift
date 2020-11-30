//
//  CreditCardInputViewController.swift
//  MorrAssignment
//
//  Created by Ravindra Patidar on 30/11/20.
//  Copyright © 2020 Ravindra Patidar. All rights reserved.
//

import UIKit

class CreditCardInputViewController: UIViewController {
    
   
    @IBOutlet weak var customCardNumberTxtField: CustomOutlinedTxtField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
       // customCardNumberTxtField.layer.borderWidth = 2.0
        
        
       
    }
    
    
    func setupNavigationBar() {
        
        self.navigationItem.title = Constants.screenTitle
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    func checkCardNumber(input: String) -> (type: CardType, formatted: String, valid: Bool) {
        // Get only numbers from the input string
      //  let numberOnly = input.stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: .RegularExpressionSearch)
        
        let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "")
        
        var type: CardType = .Unknown
        var formatted = ""
        var valid = false
        
        // detect card type
        for card in CardType.allCards {
            if (matchesRegex(regex: card.regex, text: numberOnly)) {
                type = card
                break
            }
        }
        
        // check validity
        valid = luhnCheck(number: numberOnly)
        
        // format
        var formatted4 = ""
        for character in numberOnly{
            if formatted4.count == 4 {
                formatted += formatted4 + " "
                formatted4 = ""
            }
            formatted4.append(character)
        }
        
        formatted += formatted4 // the rest
        
        // return the tuple
        return (type, formatted, valid)
    }

    
    
    func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }

    func luhnCheck(number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed()
        
        for (index, char) in digitStrings.enumerated() {
            guard let digit = Int(String(char)) else { return false }
            let odd = index % 2 == 1
            
            switch (odd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }

    
    @IBAction func btnSubmitClick(_ sender: Any) {
        let text = customCardNumberTxtField.textField.text
    }
    
}
