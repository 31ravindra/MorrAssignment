//
//  CreditCardInputViewController.swift
//  MorrAssignment
//
//  Created by Ravindra Patidar on 30/11/20.
//  Copyright © 2020 Ravindra Patidar. All rights reserved.
//

import UIKit
import MaterialComponents
class CreditCardInputViewController: UIViewController {
    
    
    @IBOutlet weak var customCardNumberTxtField: CustomOutlinedTxtField!
    
    @IBOutlet weak var dateTxtField: CustomOutlinedTxtField!
    
    @IBOutlet weak var cvvTxtField: CustomOutlinedTxtField!
    
    @IBOutlet weak var firstNameTxtField: CustomOutlinedTxtField!
    
    
    @IBOutlet weak var lastNameTxtField: CustomOutlinedTxtField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setDelegateTextField()
        setupToHideKeyboardOnTapOnView()
        
        customCardNumberTxtField.textField.keyboardType = .asciiCapableNumberPad
        dateTxtField.textField.keyboardType = .asciiCapableNumberPad
        cvvTxtField.textField.keyboardType = .asciiCapableNumberPad
        
        self.view.backgroundColor = UIColor.white
        
        
        // customCardNumberTxtField.layer.borderWidth = 2.0
        
        
        
    }
    
    func setDelegateTextField() {
        customCardNumberTxtField.textField.delegate = self
        dateTxtField.textField.delegate = self
        cvvTxtField.textField.delegate = self
        firstNameTxtField.textField.delegate = self
        lastNameTxtField.textField.delegate = self
    }
    
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(CreditCardInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
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
            let nsString = text.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
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
    
    
    func validCardDate(dateStr: String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        if !dateStr.contains("/") {
            return false
        } else {
            let enteredDate = dateFormatter.date(from: dateStr)!
            let endOfMonth = Calendar.current.date(byAdding: .month, value: 1, to: enteredDate)!
            let now = Date()
            if (endOfMonth < now) {
                return false
                //print("Expired - \(enteredDate) - \(endOfMonth)")
            } else {
                // valid
                return true
                // print("valid - now: \(now) entered: \(enteredDate)")
            }
        }
        
    }
    
    func changeTxtFieldBorderForError(txtFiled: CustomOutlinedTxtField) {
        txtFiled.textFieldControllerFloating.normalColor = UIColor.red
        txtFiled.textFieldControllerFloating.floatingPlaceholderActiveColor  = UIColor.red
        
        txtFiled.textFieldControllerFloating.floatingPlaceholderNormalColor = UIColor.red
    }
    
    func changeTxtFiledBorderForMatch(txtFiled: CustomOutlinedTxtField){
        txtFiled.textFieldControllerFloating.normalColor = UIColor.lightGray
        txtFiled.textFieldControllerFloating.floatingPlaceholderActiveColor  = UIColor.green
        
        txtFiled.textFieldControllerFloating.floatingPlaceholderNormalColor = UIColor.lightGray
    }
    
    
    func showSuccessAlert() {
        let alertController = UIAlertController(title: "", message: "Payment Successful", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            // print("Ok button tapped");
            // self.view.endEditing(true)
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func btnSubmitClick(_ sender: Any) {
        var flag = true
        let cardNumText = customCardNumberTxtField.textField.text ?? ""
        let isValidTuple = checkCardNumber(input: cardNumText )
        if !isValidTuple.valid || cardNumText.count == 0 {
            changeTxtFieldBorderForError(txtFiled: customCardNumberTxtField)
            flag = false
        } else {
            changeTxtFiledBorderForMatch(txtFiled: customCardNumberTxtField)
        }
        
        let cvvStr = cvvTxtField.textField.text ?? ""
        if cvvStr.isStringContainsOnlyNumbers() {
            if isValidTuple.type == CardType.Amex {
                if cvvStr.count == 4 {
                    changeTxtFiledBorderForMatch(txtFiled: cvvTxtField)
                } else {
                    flag = false
                    changeTxtFieldBorderForError(txtFiled: cvvTxtField)
                }
            } else {
                if cvvStr.count == 3 {
                    changeTxtFiledBorderForMatch(txtFiled: cvvTxtField)
                } else {
                    flag = false
                    changeTxtFieldBorderForError(txtFiled: cvvTxtField)
                }
            }
        }
        
        let firstNameStr = firstNameTxtField.textField.text ?? ""
        if firstNameStr.isContainOnlyAlphabatandWhiteSpace(){
            changeTxtFiledBorderForMatch(txtFiled: firstNameTxtField)
        }else {
            flag = false
            changeTxtFieldBorderForError(txtFiled: firstNameTxtField)
        }
        
        let lastNameStr = lastNameTxtField.textField.text ?? ""
        if lastNameStr.isContainOnlyAlphabatandWhiteSpace() {
            changeTxtFiledBorderForMatch(txtFiled: lastNameTxtField)
        }else {
            flag = false
            changeTxtFieldBorderForError(txtFiled: lastNameTxtField)
        }
        
        let dateStr = dateTxtField.textField.text ?? ""
        if validCardDate(dateStr: dateStr) {
            changeTxtFiledBorderForMatch(txtFiled: dateTxtField)
        }else{
            flag = false
            changeTxtFieldBorderForError(txtFiled: dateTxtField)
        }
        
        if flag {
            showSuccessAlert()
        } else {
            self.view.endEditing(true)
        }
        
        
    }
    
    
    
}

extension CreditCardInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == customCardNumberTxtField.textField {
            changeTxtFiledBorderForMatch(txtFiled: customCardNumberTxtField)
        } else if textField == cvvTxtField.textField {
            changeTxtFiledBorderForMatch(txtFiled: cvvTxtField)
        } else if textField == dateTxtField.textField {
            changeTxtFiledBorderForMatch(txtFiled: dateTxtField)
        } else if textField == firstNameTxtField.textField {
            changeTxtFiledBorderForMatch(txtFiled: firstNameTxtField)
        } else if textField == lastNameTxtField.textField {
            changeTxtFiledBorderForMatch(txtFiled: lastNameTxtField)
        }
    }
    
    
    
    
}
