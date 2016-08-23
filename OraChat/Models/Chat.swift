//
//  Chat.swift
//  OraChat
//
//  Created by Haskel Ash on 8/22/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import Foundation

class Chat {

    var chatID: Int
    var name: String
    var author: String
    var participant: String
    var creationDate: NSDate?
    var lastMessage: String

    init(chatID: Int, name: String, author: String,
         participant: String, creationString: String, lastMessage: String) {

        self.chatID = chatID
        self.name = name
        self.author = author
        self.participant = participant

        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZ"
        if let date = formatter.dateFromString(creationString) {
            self.creationDate = date
        }

        self.lastMessage = lastMessage
    }
}
