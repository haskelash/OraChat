//
//  ChatClient.swift
//  OraChat
//
//  Created by Haskel Ash on 8/22/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import Alamofire

private let endpoint = "https://private-d9e5b-oracodechallenge.apiary-mock.com/chats"

class ChatClient {
    class func getList(success success: ([Chat])->()) {
        Alamofire.request(.GET, endpoint, parameters: ["q": "", "page": "1", "limit": "20"])
            .responseJSON(completionHandler: { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization

                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    success(chatsFromJSON(JSON))
                }
            })
    }

    private class func chatsFromJSON(json: AnyObject) -> [Chat] {
        if let data = json["data"] as? [AnyObject] {
            let chats = data.map({(chatData: AnyObject) -> Chat? in

                if let name = chatData["name"] as? String,
                    let author = chatData["user"]??["name"] as? String,
                    let participant = chatData["last_message"]??["user"]??["name"] as? String,
                    let creationString = chatData["created"] as? String,
                    let lastMessage = chatData["last_message"]??["message"] as? String {

                    return Chat(name: name,
                        author: author,
                        participant: participant,
                        creationString: creationString,
                        lastMessage: lastMessage)
                }
                return nil
            })
            return chats.filter({$0 != nil}).map({$0!})
        }
        return [Chat]()
    }
}
