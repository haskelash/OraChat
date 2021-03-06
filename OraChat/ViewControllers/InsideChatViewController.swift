//
//  InsideChatViewController.swift
//  OraChat
//
//  Created by Haskel Ash on 8/23/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class InsideChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var chatID: Int?
    var chatName: String?
    weak var chatList: ChatsListViewController?

    @IBOutlet private var tableView: UITableView!
    private let dummyView = DummyView()

    private let cellIdentifier = "MessageCell"
    private var model = [Message]()
    private var plusButtonHeight: CGFloat = 72


    override func viewDidLoad() {
        if let id = chatID {
            MessageClient.getList(chatID: id, success: { messages in
                self.model = messages
                self.tableView.reloadData()
            })
        }

        self.navigationItem.title = chatName
        tableView.contentInset.bottom = plusButtonHeight
        dummyView.delegate = self
        view.addSubview(dummyView)
        if chatID == nil {
            dummyView.placeholer = "What would you like to say?"
            dummyView.becomeFirstResponder()
        }
    }

    @IBAction func plusButtonTapped(button: UIButton) {
        dummyView.becomeFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }

        if let chatID = chatID { //existing chat
            MessageClient.createMessage(chatID: chatID, message: text, success: { messageObject in
                self.model.append(messageObject)
                let path = NSIndexPath(forRow: self.model.count-1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Right)
            })
        } else if let name = chatName { //we also need to create a new chat
            ChatClient.createChat(name: name, success: {chat in
                self.chatID = chat.chatID
                self.dummyView.placeholer = nil

                MessageClient.createMessage(chatID: chat.chatID, message: text, success: { messageObject in
                    chat.participant = messageObject.author
                    chat.lastMessage = messageObject.text
                    self.chatList?.addChat(chat)

                    self.model.append(messageObject)
                    let path = NSIndexPath(forRow: self.model.count-1, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Right)
                })
            })
        }
        textField.text = nil
        return true
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

        return ceil(boundingBox.height) + MessageCell.extraCellHeight
    }
}
