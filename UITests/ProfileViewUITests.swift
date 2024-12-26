//
//  ProfileViewUITests.swift
//  UITests
//
//  Created by Yannick LEPLARD on 26/12/2024.
//

    //import XCTest
    //
    //
    //
    //final class ProfileViewUITests: XCTestCase {
    //    let app = XCUIApplication()
    //    
    //    override func setUpWithError() throws {
    //        continueAfterFailure = false
    //        app.launch()
    //        
    //        // Naviguer vers le profil (à adapter selon ta navigation)
    //        app.tabBars.buttons["Profile"].tap()
    //    }
    //    
    //    func testProfileImageChange() throws {
    //        let profileButton = app.buttons["profile-image-button"]
    //        XCTAssert(profileButton.exists)
    //        profileButton.tap()
    //        
    //        // Vérifier que l'action sheet apparaît
    //        let photoLibraryButton = app.buttons["Photo Library"]
    //        XCTAssert(photoLibraryButton.exists)
    //        
    //        let takePhotoButton = app.buttons["Take Photo"]
    //        XCTAssert(takePhotoButton.exists)
    //    }
    //    
    //    func testNotificationsToggle() throws {
    //        let toggle = app.switches["notifications-toggle"]
    //        XCTAssert(toggle.exists)
    //        
    //        let initialValue = toggle.value as? String
    //        toggle.tap()
    //        let newValue = toggle.value as? String
    //        
    //        XCTAssertNotEqual(initialValue, newValue)
    //    }
    //    
    //    func testTextFieldsAreDisabled() throws {
    //        let usernameField = app.textFields["username-textfield"]
    //        let emailField = app.textFields["email-textfield"]
    //        
    //        XCTAssertFalse(usernameField.isEnabled)
    //        XCTAssertFalse(emailField.isEnabled)
    //    }
    //}
