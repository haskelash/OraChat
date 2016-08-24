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
    static let extraLabelHeight: CGFloat = BubbleLabel.insets.top + BubbleLabel.insets.bottom + 2
    static let fontSize: CGFloat = 15.0

    static let currentUserId: Int = {return fetchTokenAndIdFromKeychain().id! ?? -1}()

    private let containerView = UIView()
    private let messageLabel = BubbleLabel()
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

        self.addSubview(messageLabel)
        messageLabel.snp_makeConstraints{ make in
            make.top.equalTo(containerView)
            make.bottom.equalTo(containerView)
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
        }
        messageLabel.font = UIFont.systemFontOfSize(MessageCell.fontSize)
        messageLabel.backgroundColor = UIColor(red: 0.906, green: 0.906, blue: 0.922, alpha: 1.00)
        messageLabel.numberOfLines = 0
    }

    func inject(message message: Message) {
        messageLabel.text = message.text
        if message.userID == MessageCell.currentUserId {
            messageLabel.side = .Right
            leftConstraint?.uninstall()
            rightConstraint?.install()
        } else {
            messageLabel.side = .Left
            leftConstraint?.install()
            rightConstraint?.uninstall()
        }
    }
}
