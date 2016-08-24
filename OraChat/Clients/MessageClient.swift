//
//  MessageClient.swift
//  OraChat
//
//  Created by Haskel Ash on 8/23/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import Alamofire

class MessageClient {
    class func getList(chatID chatID: Int, success: ([Message])->()) {
        let endpoint = "https://private-d9e5b-oracodechallenge.apiary-mock.com/chats/\(chatID)/messages"
        Alamofire.request(.GET, endpoint, parameters: ["page": "1", "limit": "20"])
            .responseJSON(completionHandler: { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization

                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    success(messagesFromJSON(JSON))
                }
            })
    }

    private class func messagesFromJSON(json: AnyObject) -> [Message] {
        if let data = json["data"] as? [AnyObject] {
            let messages = data.map({(messageData: AnyObject) -> Message? in

                if let messageID = messageData["id"] as? Int,
                    let userID = messageData["user_id"] as? Int,
                    let text = messageData["message"] as? String,
                    let author = messageData["user"]??["name"] as? String,
                    let creationString = messageData["created"] as? String {

                    return Message(messageID: messageID,
                        userID:  userID,
                        text: text,
                        author: author,
                        creationString: creationString)
                }
                return nil
            })
            return messages.filter({$0 != nil}).map({$0!})
        }
        return [Message]()
    }
}
