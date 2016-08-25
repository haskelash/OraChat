//
//  ChatsListViewController.swift
//  OraChat
//
//  Created by Haskel Ash on 8/22/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class ChatsListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet private var tableView: UITableView!

    private var model = [Chat]()
    private var cellIdentifier = "ChatCell"
    private var plusButtonHeight: CGFloat = 72

    override func viewDidLoad() {
        ChatClient.getList(success: { chats in
            self.model = chats
            self.tableView.reloadData()
        })

        tableView.contentInset.bottom = plusButtonHeight
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToChatSegue",
            let insideChatVC = segue.destinationViewController as? InsideChatViewController,
            let selectedPath = tableView.indexPathForSelectedRow {

            let chat = model[selectedPath.row]
            insideChatVC.chatID = chat.chatID
            insideChatVC.chatName = chat.name
            tableView.deselectRowAtIndexPath(selectedPath, animated: true)
        }
    }

    func addChat(chat: Chat) {
        model.append(chat)
        let path = NSIndexPath(forRow: self.model.count-1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([path], withRowAnimation: .None)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatCell

        cell.inject(chat: model[indexPath.row])

        return cell
    }
}
