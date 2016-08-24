//
//  InsideChatViewController.swift
//  OraChat
//
//  Created by Haskel Ash on 8/23/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class InsideChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var chatID: Int?

    @IBOutlet private var tableView: UITableView!

    private let cellIdentifier = "MessageCell"
    private var model = [Message]()

    override func viewDidLoad() {
        if let id = chatID {
            MessageClient.getList(chatID: id, success: { messages in
                self.model = messages
                self.tableView.reloadData()
            })
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MessageCell

        cell.inject(message: model[indexPath.row])

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let boundingBox = model[indexPath.row].text.boundingRectWithSize(
            CGSizeMake(MessageCell.messageWidth-(BubbleLabel.insets.left+BubbleLabel.insets.right), CGFloat.max),
            options: [.UsesLineFragmentOrigin, .UsesFontLeading],
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(MessageCell.fontSize)],
            context: nil)

        return ceil(boundingBox.height) + MessageCell.extraLabelHeight + MessageCell.verticalSpacing*2
    }
}
