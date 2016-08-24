//
//  MessageCell.swift
//  OraChat
//
//  Created by Haskel Ash on 8/23/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import SnapKit

class MessageCell: UITableViewCell {

    static let messageWidth: CGFloat = 226.0
    static let verticalSpacing: CGFloat = 10.0
    static let fontSize: CGFloat = 15.0

    static let currentUserId: Int = {return fetchTokenAndIdFromKeychain().id! ?? -1}()

    private var messageLabel = BubbleLabel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.addSubview(messageLabel)
        messageLabel.snp_makeConstraints{ make in
            make.top.equalTo(self).offset(MessageCell.verticalSpacing)
            make.bottom.equalTo(self).offset(-MessageCell.verticalSpacing)
            make.left.equalTo(self).offset(0)
            make.width.equalTo(MessageCell.messageWidth)
        }
        messageLabel.font = UIFont.systemFontOfSize(MessageCell.fontSize)
        messageLabel.backgroundColor = UIColor.orangeColor()
        messageLabel.numberOfLines = 0
    }

    func inject(message message: Message) {
        messageLabel.text = message.text
        messageLabel.side = (message.userID == MessageCell.currentUserId) ? .Right : .Left
    }
}
