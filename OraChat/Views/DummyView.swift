//
//  DummyView.swift
//  OraChat
//
//  Created by Haskel Ash on 8/24/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

//this class acts as a dumb UIView
//when this class is assigned first responder status, it passes it on to it's accessory view's text field

class DummyView: UIView, UITextFieldDelegate {

    var delegate: UITextFieldDelegate?
    private var accessoryView: UIView?
    @IBOutlet private var accessoryTextField: UITextField?
    override var inputAccessoryView: UIView {
        get {
            guard let accessory = accessoryView else {
                let newAccessory = NewMessageForm.instanceFromNib(self)
                accessoryView = newAccessory
                return newAccessory
            }
            return accessory
        }
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return accessoryTextField?.becomeFirstResponder() ?? false
    }

    @IBAction func cancelTapped(button: UIButton) {
        accessoryTextField?.resignFirstResponder()
        self.resignFirstResponder()
        accessoryTextField?.text = nil
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        accessoryTextField?.resignFirstResponder()
        self.resignFirstResponder()

        if delegate?.respondsToSelector(#selector(textFieldShouldReturn(_:))) == true {
            return delegate?.textFieldShouldReturn!(textField) ?? true
        } else {
            return true
        }
    }
}
