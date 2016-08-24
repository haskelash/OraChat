//
//  MessageCell.swift
//  OraChat
//
//  Created by Haskel Ash on 8/23/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import SnapKit

class MessageCell: UITableViewCell {

    static let messageWidth:CGFloat = 226.0
    static let fontSize: CGFloat = 15.0

    private var messageLabel = UILabel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.addSubview(messageLabel)
        messageLabel.snp_makeConstraints{ make in
            make.top.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(0)
            make.left.equalTo(self).offset(0)
            make.width.equalTo(MessageCell.messageWidth)
        }
        messageLabel.font = UIFont.systemFontOfSize(MessageCell.fontSize)
        messageLabel.backgroundColor = UIColor.orangeColor()
        messageLabel.numberOfLines = 0
    }

    func inject(message message: Message) {
        messageLabel.text = message.text
    }
}
