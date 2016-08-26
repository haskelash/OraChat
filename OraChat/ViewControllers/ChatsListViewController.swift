//
//  ChatsListViewController.swift
//  OraChat
//
//  Created by Haskel Ash on 8/22/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class ChatsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet private var tableView: UITableView!

    private var searchModel: ChatGrouping?
    private var fullModel = ChatGrouping(chats: [])
    private var activeModel: ChatGrouping {
        get {
            return searchModel ?? fullModel
        }
    }
    private var cellIdentifier = "ChatCell"
    private var plusButtonHeight: CGFloat = 72

    override func viewDidLoad() {
        ChatClient.getList(success: { chats in
            self.fullModel = ChatGrouping(chats: chats)
            self.tableView.reloadData()
        })

        tableView.contentInset.bottom = plusButtonHeight
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToChatSegue",
            let insideChatVC = segue.destinationViewController as? InsideChatViewController,
            let path = tableView.indexPathForSelectedRow,
            let chat = activeModel[path.section]?[path.row] {

            insideChatVC.chatID = chat.chatID
            insideChatVC.chatName = chat.name
            tableView.deselectRowAtIndexPath(path, animated: true)
        }
    }

    func addChat(chat: Chat) {
        fullModel.append(chat)
        //TODO: only add to search model if chat matches search string by some criteria
        searchModel?.append(chat)
        let path = NSIndexPath(forRow: self.activeModel.count-1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([path], withRowAnimation: .None)
    }

    var shouldBeginEditing = true

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchBar.isFirstResponder() {
            shouldBeginEditing = false
        }
        if searchBar.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            self.searchModel = nil
            self.tableView.reloadData()
        }
    }

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let toReturn = shouldBeginEditing
        shouldBeginEditing = true
        return toReturn
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchModel = nil
        self.tableView.reloadData()

        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        ChatClient.getList(search: searchBar.text, success: { chats in
            self.searchModel = ChatGrouping(chats: chats)
            self.tableView.reloadData()
        })

        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return activeModel.dates.count
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor(red:0.969, green:0.969, blue:0.969, alpha:1.00)

        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 8.0
        style.tailIndent = -8.0
        let str = activeModel.dates[section].formattedDateWithFormat("MMMM dd, yyyy")
        label.attributedText = NSAttributedString(string: str, attributes: [NSParagraphStyleAttributeName: style])

        return label
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeModel[section]?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatCell

        if let chat = activeModel[indexPath.section]?[indexPath.row] {
            cell.inject(chat: chat)
        }

        return cell
    }
}
