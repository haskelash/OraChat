//
//  InsideChatViewController.swift
//  OraChat
//
//  Created by Haskel Ash on 8/23/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class InsideChatViewController: UIViewController, UITableViewDataSource {

    var chatID: Int?

    @IBOutlet private var tableView: UITableView!

    private let identifier = "MessageCell"
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
        return 20
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    }
}
