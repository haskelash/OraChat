//
//  UserClient.swift
//  OraChat
//
//  Created by Haskel Ash on 8/22/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import Alamofire

private enum Endpoints: URLStringConvertible {
    case Register, Login, View, Edit
    var URLString: String {
        let baseURL = "https://private-d9e5b-oracodechallenge.apiary-mock.com/users"
        switch self {
        case .Register:
            return baseURL + "/register"
        case .Login:
            return baseURL + "/login"
        case .View:
            return baseURL + "/me"
        case .Edit:
            return baseURL + "/me"
        }
    }
}

class UserClient {
    class func register(params params: [String: AnyObject], success: ()->()) {
        Alamofire.request(.POST, Endpoints.Register, parameters: params)
            .responseJSON(completionHandler: { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization

                if let JSON = response.result.value {
                    success()
                    print("JSON: \(JSON)")

                    if let id = JSON["data"]??["id"] as? Int,
                        let email = JSON["data"]??["token"] as? String,
                        let token = JSON["data"]??["token"] as? String {

                        saveToKeychain(email: email, token: token, id: id)
                    }
                }
            })
    }

    class func login(params params: [String: AnyObject], success: ()->()) {
        Alamofire.request(.POST, Endpoints.Login, parameters: params)
            .responseJSON(completionHandler: { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization

                if let JSON = response.result.value {
                    success()
                    print("JSON: \(JSON)")

                    if let id = JSON["data"]??["id"] as? Int,
                        let email = JSON["data"]??["token"] as? String,
                        let token = JSON["data"]??["token"] as? String {

                        saveToKeychain(email: email, token: token, id: id)
                    }
                }
            })
    }
}
