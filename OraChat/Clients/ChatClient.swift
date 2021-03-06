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

    static let headers = [
        "Content-Type": "application/json; charset=utf-8",
        "Accept": "application/json",
        "Authorization": "Bearer \(KeychainAccount.globalAccount.getToken())"]

    class func getList(search search: String? = nil, success: ([Chat])->()) {
        var params = ["page": "1", "limit": "20"]
        if search != nil { params["q"] = search }

        Alamofire.request(.GET, endpoint, headers: headers, parameters: params)
            .responseJSON(completionHandler: { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization

                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    success(chatsFromJSON(JSON))

                    //to simulate a smaller array in case of search,
                    //comment out the above line and uncomment the lines below

//                    let foo = chatsFromJSON(JSON)
//                    if search == nil {
//                        success([foo[0], foo[1], foo[0], foo[1]])
//                    } else {
//                        success(foo)
//                    }
                }
            })
    }

    class func createChat(name name: String, success: (Chat)->()) {
        Alamofire.request(.POST, endpoint, headers: headers, parameters: ["name": name], encoding: .JSON)
            .responseJSON(completionHandler: { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization

                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    if let chatObject = chatFromJSON(JSON) {
                        success(chatObject)
                    }
                }
            })
    }

    private class func chatsFromJSON(json: AnyObject) -> [Chat] {
        if let data = json["data"] as? [AnyObject] {
            let chats = data.map({(chatData: AnyObject) -> Chat? in

                if let chatID = chatData["id"] as? Int,
                    let name = chatData["name"] as? String,
                    let author = chatData["user"]??["name"] as? String,
                    let participant = chatData["last_message"]??["user"]??["name"] as? String,
                    let creationString = chatData["created"] as? String,
                    let lastMessage = chatData["last_message"]??["message"] as? String {

                    return Chat(chatID: chatID,
                        name: name,
                        author: author,
                        creationString: creationString,
                        participant: participant,
                        lastMessage: lastMessage)
                }
                return nil
            })
            return chats.filter({$0 != nil}).map({$0!})
        }
        return [Chat]()
    }

    private class func chatFromJSON(json: AnyObject) -> Chat? {
        if let dict = json as? [String: AnyObject],
            let data = dict["data"],
            let chatID = data["id"] as? Int,
            let name = data["name"] as? String,
            let author = data["user"]??["name"] as? String,
            let creationString = data["created"] as? String {

            return Chat(chatID: chatID,
                        name: name,
                        author: author,
                        creationString: creationString)
        }
        return nil
    }
}
