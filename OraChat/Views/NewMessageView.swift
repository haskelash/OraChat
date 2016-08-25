//
//  NewMessageForm.swift
//  OraChat
//
//  Created by Haskel Ash on 8/24/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class NewMessageForm: UIView {
    class func instanceFromNib(owner: DummyView) -> UIView {
        return UINib(nibName: "NewMessageView", bundle: nil)
            .instantiateWithOwner(owner, options: nil)[0] as! UIView
    }
}
