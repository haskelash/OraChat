//
//  AccountFormViewController.swift
//  OraChat
//
//  Created by Haskel Ash on 8/22/16.
//  Copyright © 2016 Haskel Ash. All rights reserved.
//

import UIKit

class AccountFormViewController: UIViewController {

    @IBOutlet private var registrationView: UIView!
    @IBOutlet private var loginView: UIView!

    @IBOutlet private var emailLoginField: UITextField!
    @IBOutlet private var passwordLoginField: UITextField!

    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var emailRegistrationField: UITextField!
    @IBOutlet private var passwordRegistrationField: UITextField!
    @IBOutlet private var confirmField: UITextField!

    @IBOutlet private var leftButton: UIBarButtonItem!
    @IBOutlet private var rightButton: UIBarButtonItem!

    private var formState = FormState.Edit
    private enum FormState {
        case Login, Register, Edit
    }

    func setUpForRegistration() {
        formState = .Register
    }

    override func viewDidLoad() {
        reconcileFormState()
    }

    @IBAction func leftButtonAction(button: UIBarButtonItem) {
        switch formState {
        case .Register:
            formState = .Login
            reconcileFormState()
        case .Login:
            formState = .Register
            reconcileFormState()
        case .Edit:
            break
        }
    }

    @IBAction func rightButtonAction(button: UIBarButtonItem) {
        switch formState {
        case .Register:
            register()
        case .Login:
            login()
        case .Edit:
            save()
        }
    }

    @IBAction func editingChanged(textField: UITextField) {
        if formState == .Register || formState == .Edit {
            if nameField.text?.characters.count > 0
                && validEmail(emailRegistrationField.text)
                && passwordRegistrationField.text?.characters.count > 0
                && confirmField.text?.characters.count > 0
                && passwordRegistrationField.text == confirmField.text {

                rightButton.enabled = true
            } else { rightButton.enabled = false }
        } else if formState == .Login {
            if validEmail(emailLoginField.text)
                && passwordLoginField.text?.characters.count > 0 {

                rightButton.enabled = true
            } else { rightButton.enabled = false }
        }
    }

    //private methods

    private func register() {
        if let name = nameField.text,
            let email = emailRegistrationField.text,
            let password = passwordRegistrationField.text,
            let confirm = confirmField.text {

            UserClient.register(params:[
                "name": name,
                "email": email,
                "password":password,
                "confirm":confirm
                ], success: {self.goToTabBarVC()}
            )
        }
    }

    private func login() {
        if let email = emailLoginField.text,
            let password = passwordLoginField.text {
            UserClient.login(params:[
                "email": email,
                "password":password
                ], success: {self.goToTabBarVC()}
            )
        }
    }

    private func save() {

    }

    private func goToTabBarVC() {
        let tabBarVC = UIApplication.sharedApplication().delegate?.window??.rootViewController?
            .storyboard?.instantiateViewControllerWithIdentifier("RootTabBarViewController")
        UIApplication.sharedApplication().delegate?.window??.rootViewController = tabBarVC
    }

    private func reconcileFormState() {
        UIView.setAnimationsEnabled(false)

        switch formState {
        case .Register:
            leftButton.title = "Login"
            rightButton.title = "Register"
            loginView.hidden = true
            registrationView.hidden = false
        case .Login:
            leftButton.title = "Register"
            rightButton.title = "Login"
            loginView.hidden = false
            registrationView.hidden = true
        case .Edit:
            leftButton.title = nil
            rightButton.title = "Save"
            loginView.hidden = true
            registrationView.hidden = false
        }

        UIView.setAnimationsEnabled(true)

        switch formState {
        case .Register, .Login:
            //reset all text fields
            nameField.text = nil
            emailRegistrationField.text = nil
            passwordRegistrationField.text = nil
            confirmField.text = nil
            emailLoginField.text = nil
            passwordLoginField.text = nil
            rightButton.enabled = false
        case .Edit:
            //prepopulate user info, clear passwords
            nameField.text = KeychainAccount.globalAccount.getName()
            emailRegistrationField.text =  NSUserDefaults
                .standardUserDefaults().stringForKey("userEmail")
            passwordRegistrationField.text = nil
            confirmField.text = nil
            rightButton.enabled = false
        }

    }

    private func validEmail(str: String?) -> Bool {
        guard let str = str else { return false }
        do {
            let regex = try NSRegularExpression(
                pattern: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
                options: .CaseInsensitive)
            let matches = regex.numberOfMatchesInString(
                str, options: [], range: NSMakeRange(0, str.characters.count))
            return matches > 0
        } catch {
            return false
        }
    }
}
