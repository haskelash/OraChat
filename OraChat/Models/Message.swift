//
//  Message.swift
//  OraChat
//
//  Created by Haskel Ash on 8/23/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import Foundation

class Message {

    var messageID: Int
    var userID: Int
    var text: String
    var author: String
    var creationDate: NSDate?

    init(messageID: Int, userID: Int, text: String, author: String, creationString: String) {
        self.messageID = messageID
        self.userID = userID
        self.text = text
        self.author = author

        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
        formatter.timeZone = NSTimeZone(abbreviation: "GMT")
        if let date = formatter.dateFromString(creationString) {
            self.creationDate = date
        }
    }
}