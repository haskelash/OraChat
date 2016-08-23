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

    override func viewDidLoad() {
        ChatClient.getList(success: { chats in
            self.model = chats
            self.tableView.reloadData()
        })
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
