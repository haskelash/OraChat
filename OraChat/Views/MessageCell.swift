//
//  MessageCell.swift
//  OraChat
//
//  Created by Haskel Ash on 8/23/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import SnapKit
import DateTools

class MessageCell: UITableViewCell {

    static let fontSize: CGFloat = 15
    static let messageWidth: CGFloat = 226
    static let extraCellHeight: CGFloat =
        MessageCell.verticalSpacing +
        BubbleLabel.insets.top +
        BubbleLabel.insets.bottom +
        MessageCell.smidgeOfExtraHeight +
        MessageCell.spaceBetweenMessageAndDate +
        MessageCell.dateHeight +
        MessageCell.verticalSpacing

    static let currentUserId: Int = {return fetchTokenAndIdFromKeychain().id! ?? -1}()

    static private let verticalSpacing: CGFloat = 10
    static private let smidgeOfExtraHeight: CGFloat = 2
    static private let spaceBetweenMessageAndDate: CGFloat = 2
    static private let dateHeight: CGFloat = 18

    private let containerView = UIView()
    private let messageLabel = BubbleLabel()
    private let timeAgoLabel = UILabel()

    private var leftConstraint: Constraint?
    private var rightConstraint: Constraint?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.addSubview(containerView)
        containerView.snp_makeConstraints{ make in
            make.top.equalTo(self).offset(MessageCell.verticalSpacing)
            make.bottom.equalTo(self).offset(-MessageCell.verticalSpacing)
            leftConstraint = make.left.equalTo(self).offset(20).constraint
            rightConstraint = make.right.equalTo(self).offset(-20).constraint
            make.width.equalTo(MessageCell.messageWidth)
        }
        rightConstraint?.uninstall()

        messageLabel.font = UIFont.systemFontOfSize(MessageCell.fontSize)
        messageLabel.backgroundColor = UIColor(red: 0.906, green: 0.906, blue: 0.922, alpha: 1.00)
        messageLabel.numberOfLines = 0
        containerView.addSubview(messageLabel)
        messageLabel.snp_makeConstraints{ make in
            make.top.equalTo(containerView)
            make.bottom.equalTo(containerView).offset(-(MessageCell.spaceBetweenMessageAndDate+MessageCell.dateHeight))
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
        }

        timeAgoLabel.font = UIFont.systemFontOfSize(MessageCell.fontSize)
        timeAgoLabel.textColor = UIColor(red:0.961, green:0.651, blue:0.137, alpha:1.00)
        containerView.addSubview(timeAgoLabel)
        timeAgoLabel.snp_makeConstraints{ make in
            make.top.equalTo(messageLabel.snp_bottom).offset(MessageCell.spaceBetweenMessageAndDate)
            make.bottom.equalTo(containerView)
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
        }
    }

    func inject(message message: Message) {
        messageLabel.text = message.text
        timeAgoLabel.text = "\(message.creationDate)"

        if message.userID == MessageCell.currentUserId {
            messageLabel.side = .Right
            leftConstraint?.uninstall()
            rightConstraint?.install()
            timeAgoLabel.textAlignment = .Right
        } else {
            messageLabel.side = .Left
            leftConstraint?.install()
            rightConstraint?.uninstall()
            timeAgoLabel.textAlignment = .Left
        }
    }
}
