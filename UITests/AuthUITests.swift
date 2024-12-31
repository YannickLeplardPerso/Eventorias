//
//  AuthUITests.swift
//  EventoriasTests
//
//  Created by Yannick LEPLARD on 30/12/2024.
//

//import XCTest
//
//@testable import Eventorias
//
//
//
//class AuthUITests: XCTestCase {
//    let app = XCUIApplication()
//
//    override func setUpWithError() throws {
//        continueAfterFailure = false
//        app.launch()
//    }
//
//    func testSignIn() throws {
//        // Trouve le bouton de connexion par email
//        let signInButton = app.buttons[AccessID.signSubmit]
//        XCTAssert(signInButton.exists)
//        signInButton.tap()
//
//        // Remplit le formulaire de connexion
//        let emailField = app.textFields[AccessID.signEmail]
//        let passwordField = app.secureTextFields[AccessID.signPassword]
//
//        emailField.tap()
//        emailField.typeText("test@example.com")
//
//        passwordField.tap()
//        passwordField.typeText("password123")
//        
//        // Appuie sur le bouton de connexion
//        app.buttons[AccessID.signSubmit].tap()
//        
//        // Vérifie qu'on arrive sur la liste des événements
//        XCTAssert(app.otherElements[AccessID.eventList].waitForExistence(timeout: 5))
//    }
//}
    


//    func testSignUpFlow() throws {
//        let emailSignInButton = app.buttons[AccessID.emailSignIn]
//        emailSignInButton.tap()
//        
//        // Bascule vers l'inscription
//        app.buttons[AccessID.toggleModeButton].tap()
//        
//        // Remplit le formulaire d'inscription
//        app.textFields[AccessID.nameInput].tap()
//        app.textFields[AccessID.nameInput].typeText("Test User")
//        
//        app.textFields[AccessID.emailInput].tap()
//        app.textFields[AccessID.emailInput].typeText("newuser@example.com")
//        
//        app.secureTextFields[AccessID.passwordInput].tap()
//        app.secureTextFields[AccessID.passwordInput].typeText("password123")
//        
//        app.buttons[AccessID.submitButton].tap()
//        
//        XCTAssert(app.otherElements[AccessID.eventsList].waitForExistence(timeout: 5))
//    }

