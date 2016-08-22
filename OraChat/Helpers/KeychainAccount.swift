//
//  KeychainAccount.swift
//  OraChat
//
//  Created by Haskel Ash on 8/22/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import SwiftKeychain

struct KeychainAccount: KeychainGenericPasswordType {

    let accountName: String
    let token: String
    var data = [String: AnyObject]()

    var dataToStore: [String: AnyObject] {
        return ["token": token]
    }

    var accessToken: String? {
        return data["token"] as? String
    }

    init(name: String, accessToken: String = "") {
        accountName = name
        token = accessToken
    }
}

func saveToKeychain(email email: String, token: String) {
    NSUserDefaults.standardUserDefaults().setValue(email, forKey: "userEmail")
    NSUserDefaults.standardUserDefaults().synchronize()
    let account = KeychainAccount(name: email, accessToken: token)
    do {
        try account.saveInKeychain()
    } catch {

    }
}

func fetchTokenFromKeychain() -> String? {
    if let email = NSUserDefaults.standardUserDefaults().stringForKey("userEmail") {
        var account = KeychainAccount(name: email)
        do {
            try account.fetchFromKeychain()
            return account.accessToken
        } catch {
            print(error)
        }
    }
    return nil
}
