//
//  KeychainAccount.swift
//  OraChat
//
//  Created by Haskel Ash on 8/22/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import SwiftKeychain

struct KeychainAccount: KeychainGenericPasswordType {

    internal let accountName: String
    private let token: String
    private let id: Int
    internal var data = [String: AnyObject]()

    var dataToStore: [String: AnyObject] {
        return ["token": token, "id": id]
    }

    var accessToken: String? {
        return data["token"] as? String
    }

    var identifier: Int? {
        return data["id"] as? Int
    }

    init(name: String, accessToken: String = "", identifier: Int = -1) {
        accountName = name
        token = accessToken
        id = identifier
    }
}

func saveToKeychain(email email: String, token: String, id: Int) {
    NSUserDefaults.standardUserDefaults().setValue(email, forKey: "userEmail")
    NSUserDefaults.standardUserDefaults().synchronize()
    let account = KeychainAccount(name: email, accessToken: token, identifier: id)
    do {
        try account.saveInKeychain()
    } catch {

    }
}

func fetchTokenAndIdFromKeychain() -> (token: String?, id: Int?) {
    if let email = NSUserDefaults.standardUserDefaults().stringForKey("userEmail") {
        var account = KeychainAccount(name: email)
        do {
            try account.fetchFromKeychain()
            return (account.accessToken, account.identifier)
        } catch {
            print(error)
        }
    }
    return (nil, nil)
}
