//
//  EntryViewController.swift
//  StatisticsCalculator
//
//  Created by Eunice Orozco on 02/12/2017.
//  Copyright © 2017 TIP. All rights reserved.
//

import Foundation
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    var keyboardToolbar: UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self.view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        return keyboardToolbar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.inputAccessoryView = keyboardToolbar
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let num = Int(text) {
            GridManager.shared.numberOfData = num
            self.performSegue(withIdentifier: "gridSegue", sender: textField)
        }
    }
}
