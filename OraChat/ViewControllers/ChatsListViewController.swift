//
//  ChatsListViewController.swift
//  OraChat
//
//  Created by Haskel Ash on 8/22/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class ChatsListViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet private var tableView: UITableView!

    private var searchModel: [Chat]?
    private var fullModel = [Chat]()
    private var activeModel: [Chat] {
        get {
            return searchModel ?? fullModel
        }
    }
    private var cellIdentifier = "ChatCell"
    private var plusButtonHeight: CGFloat = 72

    override func viewDidLoad() {
        ChatClient.getList(success: { chats in
            self.fullModel = chats
            self.tableView.reloadData()
        })

        tableView.contentInset.bottom = plusButtonHeight
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToChatSegue",
            let insideChatVC = segue.destinationViewController as? InsideChatViewController,
            let selectedPath = tableView.indexPathForSelectedRow {

            let chat = activeModel[selectedPath.row]
            insideChatVC.chatID = chat.chatID
            insideChatVC.chatName = chat.name
            tableView.deselectRowAtIndexPath(selectedPath, animated: true)
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
            self.searchModel = chats
            self.tableView.reloadData()
        })

        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeModel.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatCell

        cell.inject(chat: activeModel[indexPath.row])

        return cell
    }
}
