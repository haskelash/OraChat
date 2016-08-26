//
//  ChatGrouping.swift
//  OraChat
//
//  Created by Haskel Ash on 8/25/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import Foundation

class ChatGrouping: CustomStringConvertible {

    private var groupedChats: [NSDate: [Chat]]
    private(set) var dates: [NSDate]

    var description: String {
        return "\(groupedChats)"
    }

    init(chats: [Chat]) {
        groupedChats = [:]

        dates = chats.map({$0.creationDate?.roundedDownDate()}).filter({$0 != nil})
            .map({$0!}).sort({ a, b in return a.isEarlierThan(b) })

        for date in dates {
            groupedChats[date] = []
        }

        for chat in chats {
            guard let date = chat.creationDate else { continue }
            groupedChats[date.roundedDownDate()]?.append(chat)
        }
    }

    func insert(chat: Chat) {
        guard let date = chat.creationDate else { return }
        if let _ = groupedChats[date.roundedDownDate()] {
            groupedChats[date.roundedDownDate()]?.append(chat)
        } else {
            groupedChats[date.roundedDownDate()] = [chat]
            dates = dates.sort({ a, b in return a.isEarlierThan(b) })
        }
    }

    func path(chat: Chat) -> NSIndexPath? {
        if let date = chat.creationDate?.roundedDownDate(),
            let section = dates.indexOf(date),
            let row = groupedChats[date]?.indexOf({ aChat in aChat === chat }) {

            return NSIndexPath(forRow: row, inSection: section)
        }
        return nil
    }

    subscript(index: Int) -> [Chat]? {
        return groupedChats[dates[index]]
    }
}

extension NSDate {
    func roundedDownDate() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone(abbreviation: "GMT")!
        let comps = NSDateComponents()
        comps.year = calendar.component(.Year, fromDate: self)
        comps.month = calendar.component(.Month, fromDate: self)
        comps.day = calendar.component(.Day, fromDate: self)
        return calendar.dateFromComponents(comps)!
    }
}
