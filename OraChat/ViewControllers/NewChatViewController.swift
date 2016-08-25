//
//  NewChatViewController.swift
//  OraChat
//
//  Created by Haskel Ash on 8/25/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class NewChatViewController: UIViewController, UITableViewDataSource {

    private let cellIdentifier = "ContactCell"

    @IBAction func cancelTapped(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
    }
}
