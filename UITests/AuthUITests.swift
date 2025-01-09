//
//  AuthUITests.swift
//  EventoriasTests
//
//  Created by Yannick LEPLARD on 30/12/2024.
//

import XCTest


class EventoriasUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testSuccessfulSignIn() throws {
        let signSheetButton = app.buttons[AccessID.signSheet]
        XCTAssertTrue(signSheetButton.exists, "Le bouton de connexion par email doit exister")
        signSheetButton.tap()
        
        let emailTextField = app.textFields[AccessID.signEmail]
        let passwordTextField = app.secureTextFields[AccessID.signPassword]
        let signInButton = app.buttons[AccessID.signSubmit]
        
        XCTAssertTrue(emailTextField.exists, "Le champ email doit exister")
        XCTAssertTrue(passwordTextField.exists, "Le champ mot de passe doit exister")
        XCTAssertTrue(signInButton.exists, "Le bouton de connexion doit exister")
        
        emailTextField.tap()
        emailTextField.typeText(TestUser.valid.email)
        
        passwordTextField.tap()
        passwordTextField.typeText(TestUser.valid.password)
        
        signInButton.tap()
        
        let eventList = app.collectionViews[AccessID.eventView]
        XCTAssertTrue(eventList.waitForExistence(timeout: 10), "La liste d'événements doit être visible")
        
        XCTAssertTrue(eventList.cells.count > 0, "La liste doit contenir des événements")
    }
    
    func testNavigateToEventDetails() throws {
        try testSuccessfulSignIn()
        
        let eventList = app.collectionViews[AccessID.eventView]
        XCTAssertTrue(eventList.cells.count > 0, "La liste doit contenir des événements")
        
        let firstEventCard = eventList.cells.firstMatch // element(boundBy: 0)
        XCTAssertTrue(firstEventCard.exists, "Le premier événement doit exister")
        
        firstEventCard.tap()
        
        let detailView = app.scrollViews[AccessID.detailView]
        XCTAssertTrue(detailView.waitForExistence(timeout: 10), "La vue de détails doit être visible")
    }
    
    
    
    
    func testCreateNewEvent() throws {
        try testSuccessfulSignIn()
        
        let addEventButton = app.buttons.matching(NSPredicate(format: "identifier == %@ AND label == 'Add new event'", AccessID.eventView)).element
        
        XCTAssertTrue(addEventButton.exists, "Le bouton d'ajout d'événement doit exister")
        addEventButton.tap()
        
        let testEvent = TestEvent.random()
        
        let titleTextField = app.textFields[AccessID.eventAddTitle]
        let descriptionTextField = app.textViews[AccessID.eventAddDescription]
        let addressTextField = app.textFields[AccessID.eventAddAddress]
        let createEventButton = app.buttons[AccessID.eventCreate]
        let categorySelection = app.buttons[AccessID.eventAddCategory(testEvent.category.rawValue.lowercased())]
        
        XCTAssertTrue(titleTextField.exists, "Champ de titre doit exister")
        XCTAssertTrue(descriptionTextField.exists, "Champ de description doit exister")
        XCTAssertTrue(addressTextField.exists, "Champ d'adresse doit exister")
        XCTAssertTrue(createEventButton.exists, "Bouton de création doit exister")
        XCTAssertTrue(categorySelection.exists, "Sélection de catégorie doit exister")
        
        titleTextField.tap()
        titleTextField.typeText(testEvent.title)
                
        descriptionTextField.tap()
        descriptionTextField.typeText(testEvent.description)
        
        addressTextField.tap()
        addressTextField.typeText(testEvent.address)
        
        app.buttons[AccessID.eventAddCategory(testEvent.category.rawValue)].tap()
        
        createEventButton.tap()
        
        let eventList = app.collectionViews[AccessID.eventView]
        XCTAssertTrue(eventList.waitForExistence(timeout: 5), "Doit revenir à la liste d'événements après création")
        
        let newEventCard = eventList.cells.containing(.staticText, identifier: testEvent.title).element
        
        let maxSwipes = 100
        var swipeCount = 0
        
        while (!newEventCard.exists || !newEventCard.isHittable) && swipeCount < maxSwipes {
            eventList.swipeUp()
            swipeCount += 1
        }
        
        XCTAssertTrue(newEventCard.exists, "Le nouvel événement doit apparaître dans la liste")
    }
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    // Test de création d'événement
//    func testCreateNewEvent() throws {
//        // S'assurer d'être connecté
//        try testSuccessfulSignIn()
//        
//        // Taper sur le bouton d'ajout d'événement
//        let addEventButton = app.buttons[AccessID.eventAdd]
//        XCTAssertTrue(addEventButton.exists)
//        addEventButton.tap()
//        
//        // Remplir les champs de création d'événement
//        let titleTextField = app.textFields["event-title-input"]
//        let descriptionTextField = app.textFields["event-description-input"]
//        let addressTextField = app.textFields["event-address-input"]
//        let createEventButton = app.buttons["create-event-button"]
//        
//        XCTAssertTrue(titleTextField.exists)
//        XCTAssertTrue(descriptionTextField.exists)
//        XCTAssertTrue(addressTextField.exists)
//        XCTAssertTrue(createEventButton.exists)
//        
//        titleTextField.tap()
//        titleTextField.typeText("Test Event")
//        
//        descriptionTextField.tap()
//        descriptionTextField.typeText("This is a test event description")
//        
//        addressTextField.tap()
//        addressTextField.typeText("211 Avenue Jean Jaurès, 75019 Paris")
//        
//        // Sélectionner une catégorie
//        let categorySelector = app.buttons["category-selector"]
//        categorySelector.tap()
//        
//        // Créer l'événement
//        createEventButton.tap()
//        
//        // Vérifier le retour à la liste des événements
//        let eventList = app.otherElements[AccessID.eventList]
//        XCTAssertTrue(eventList.waitForExistence(timeout: 5), "Should return to event list after creation")
//    }
//    
//    // Test de recherche d'événement
//    func testSearchEvent() throws {
//        // S'assurer d'être connecté
//        try testSuccessfulSignIn()
//        
//        let searchBar = app.textFields[AccessID.eventSearch]
//        XCTAssertTrue(searchBar.exists)
//        
//        searchBar.tap()
//        searchBar.typeText("Concert")
//        
//        // Vérifier que la liste des événements a été filtrée
//        // Note: Vous devrez peut-être ajuster ce test selon votre implémentation exacte
//        let eventCards = app.buttons.matching(identifier: "event-card")
//        XCTAssertTrue(eventCards.count > 0, "Should show filtered events")
//    }
//    
//    // Test de tri des événements
//    func testSortEvents() throws {
//        // S'assurer d'être connecté
//        try testSuccessfulSignIn()
//        
//        let sortButton = app.buttons[AccessID.eventSort]
//        XCTAssertTrue(sortButton.exists)
//        sortButton.tap()
//        
//        // Vérifier que les options de tri sont disponibles
//        XCTAssertTrue(app.buttons[AccessID.sortDateSection].exists)
//        XCTAssertTrue(app.buttons[AccessID.sortCategorySection].exists)
//        
//        // Sélectionner un tri par date
//        let sortRecentToOld = app.buttons[AccessID.sortRecentToOld]
//        XCTAssertTrue(sortRecentToOld.exists)
//        sortRecentToOld.tap()
//    }
//    
//    // Test de navigation vers les détails d'un événement
//    func testNavigateToEventDetails() throws {
//        // S'assurer d'être connecté
//        try testSuccessfulSignIn()
//        
//        // Sélectionner le premier événement de la liste
//        let firstEventCard = app.buttons[AccessID.eventCard("first-event-id")]
//        XCTAssertTrue(firstEventCard.exists)
//        firstEventCard.tap()
//        
//        // Vérifier que les détails de l'événement sont affichés
//        // Note: Vous devrez peut-être ajouter des identifiants spécifiques pour ces vérifications
//        XCTAssertTrue(app.navigationBars.element.exists)
//    }

