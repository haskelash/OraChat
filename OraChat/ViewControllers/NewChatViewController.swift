//
//  NewChatViewController.swift
//  OraChat
//
//  Created by Haskel Ash on 8/25/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class NewChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    private let dummyView = DummyView()
    private let cellIdentifier = "ContactCell"

    override func viewDidLoad() {
        view.addSubview(dummyView)
        dummyView.delegate = self
    }

    @IBAction func cancelTapped(button: UIBarButtonItem) {
        dummyView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        dummyView.placeholer = "Enter chat name"
        dummyView.becomeFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let name = textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if name?.characters.count > 0 {
            if let newChatVC = self.storyboard?
                .instantiateViewControllerWithIdentifier("InsideChatViewController") as? InsideChatViewController,
                let tabBarVC = self.presentingViewController as? UITabBarController,
                let navVC = tabBarVC.selectedViewController as? UINavigationController,
                let chatListVC = navVC.topViewController as? ChatsListViewController {

                newChatVC.chatList = chatListVC
                newChatVC.chatName = name
                navVC.pushViewController(newChatVC, animated: false)
            }
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Enter a chat name first", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                self.dummyView.becomeFirstResponder()
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
        return true
    }
}
