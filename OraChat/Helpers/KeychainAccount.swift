//
//  KeychainAccount.swift
//  OraChat
//
//  Created by Haskel Ash on 8/22/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import SwiftKeychain

struct KeychainAccount: KeychainGenericPasswordType {

    static var globalAccount: KeychainAccount = KeychainAccount.fetchRefreshedAccount()

    internal let accountName: String
    private let name: String
    private let token: String
    private let id: Int
    internal var data = [String: AnyObject]()

    var dataToStore: [String: AnyObject] {
        return ["token": token, "name": name, "id": id]
    }

    func getToken() -> String? {
        return data["token"] as? String
    }

    func getName() -> String? {
        return data["name"] as? String
    }

    func getId() -> Int? {
        return data["id"] as? Int
    }

    init(email: String, name: String = "", token: String = "", id: Int = -1) {
        accountName = email
        self.name = name
        self.token = token
        self.id = id
    }

    static func fetchRefreshedAccount() -> KeychainAccount {
        if let email = NSUserDefaults.standardUserDefaults().stringForKey("userEmail") {
            var account = KeychainAccount(email: email)
            do {
                try account.fetchFromKeychain()
                return account
            } catch {
                print(error)
            }
        }
        return KeychainAccount(email: "")
    }

    static func save(email email: String, name: String, token: String, id: Int) {
        NSUserDefaults.standardUserDefaults().setValue(email, forKey: "userEmail")
        NSUserDefaults.standardUserDefaults().synchronize()
        let account = KeychainAccount(email: email, name: name, token: token, id: id)
        do {
            try account.saveInKeychain()
            KeychainAccount.globalAccount = KeychainAccount.fetchRefreshedAccount()
        } catch {
            print(error)
        }
    }
}
