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

    //private methods

    private func register() {

    }

    private func login() {

    }

    private func save() {

    }

    private func reconcileFormState() {
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
    }
}
