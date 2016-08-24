//
//  ChatCell.swift
//  OraChat
//
//  Created by Haskel Ash on 8/22/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet private var nameAuthorLabel: UILabel!
    @IBOutlet private var participantTimeAgoLabel: UILabel!
    @IBOutlet private var lastMessageLabel: UILabel!

    func inject(chat chat: Chat) {
        nameAuthorLabel.text = "\(chat.name) by \(chat.author)"
        participantTimeAgoLabel.text = chat.participant
        if let timeAgo = chat.creationDate?.timeAgoSinceNow() {
            participantTimeAgoLabel.text? += " - \(timeAgo)"
        }
        lastMessageLabel.text = chat.lastMessage
    }
}
