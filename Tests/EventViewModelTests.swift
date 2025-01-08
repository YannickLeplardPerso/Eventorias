//
//  EventViewModelTests.swift
//  Tests
//
//  Created by Yannick LEPLARD on 26/12/2024.
//

import Testing
@testable import Eventorias

import SwiftUI
import PhotosUI



// Struct centralisant les données de test
struct TestEventData {
    // Lieux de test
    struct Locations {
        static let zenithParis = EventLocation(
            address: "Zénith de Paris, 211 Avenue Jean Jaurès, 75019 Paris",
            latitude: 48.8932,
            longitude: 2.3934
        )
        
        static let palaisDesCongresParis = EventLocation(
            address: "Palais des Congrès, 2 Place de la Porte Maillot, 75017 Paris",
            latitude: 48.8785,
            longitude: 2.2833
        )
        
        static let invalidLocation = EventLocation(
            address: "",
            latitude: nil,
            longitude: nil
        )
    }
    
    // Événements de test
    struct Events {
        static let concertIronMaiden = Event(
            title: "Powerslave tour",
            description: "Concert Iron Maiden",
            date: Date(),
            location: Locations.zenithParis,
            category: .culture,
            creatorId: "1",
            createdAt: Date()
        )
        
        static let xCodeConference = Event(
            title: "Conférence xCode",
            description: "le nouveau framework testing",
            date: Date(),
            location: Locations.palaisDesCongresParis,
            category: .business,
            creatorId: "2",
            createdAt: Date()
        )
        
        // Événements pour les tests de tri et filtrage
        static let todayEvent = Event(
            title: "Tournoi tennis",
            description: "Description tournoi tennis",
            date: Date(),
            location: Locations.palaisDesCongresParis,
            category: .sports,
            creatorId: "2",
            createdAt: Date()
        )
        
        static let tomorrowEvent = Event(
            title: "Concert",
            description: "Description Concert",
            date: Date().addingTimeInterval(86400),
            location: Locations.zenithParis,
            category: .culture,
            creatorId: "1",
            createdAt: Date()
        )
        
        // Événements pour le test de filtrage par catégorie
        static let sportEvent = Event(
            title: "Événement sportif",
            description: "Description sport",
            date: Date(),
            location: Locations.zenithParis,
            category: .sports,
            creatorId: "1",
            createdAt: Date()
        )
        
        static let cultureEvent1 = Event(
            title: "Événement culturel 1",
            description: "Description culture 1",
            date: Date(),
            location: Locations.palaisDesCongresParis,
            category: .culture,
            creatorId: "2",
            createdAt: Date()
        )
        
        static let businessEvent = Event(
            title: "Événement business",
            description: "Description business",
            date: Date(),
            location: Locations.palaisDesCongresParis,
            category: .business,
            creatorId: "2",
            createdAt: Date()
        )
        
        static let cultureEvent2 = Event(
            title: "Événement culturel 2",
            description: "Description culture 2",
            date: Date(),
            location: Locations.palaisDesCongresParis,
            category: .culture,
            creatorId: "1",
            createdAt: Date()
        )
    }
}

struct EventViewModelTests {
    @Test func testCreateEmptyEvent() {
        let emptyEvent = EventViewModel.createEmptyEvent()
        
        #expect(emptyEvent.title.isEmpty)
        #expect(emptyEvent.description.isEmpty)
        #expect(emptyEvent.location.address.isEmpty)
        #expect(emptyEvent.location.latitude == nil)
        #expect(emptyEvent.location.longitude == nil)
        #expect(emptyEvent.category == .other)
        #expect(emptyEvent.creatorId.isEmpty)
    }
    
    @MainActor
    @Test func testResetNewEvent() {
        let viewModel = EventViewModel()
        viewModel.newEvent.title = "Test title"
        viewModel.newEvent.description = "Test description"
        viewModel.newEvent.category = .culture
        viewModel.newEvent.location = TestEventData.Locations.zenithParis
        viewModel.newEvent.creatorId = "ID"
        
        viewModel.selectedItem = PhotosPickerItem(itemIdentifier: "")
        #expect(viewModel.selectedItem != nil)
        viewModel.selectedImage = UIImage()
        #expect(viewModel.selectedImage != nil)
        
        viewModel.resetNewEvent()
        
        #expect(viewModel.newEvent.title.isEmpty)
        #expect(viewModel.newEvent.description.isEmpty)
        #expect(viewModel.newEvent.location.address.isEmpty)
        #expect(viewModel.newEvent.location.latitude == nil)
        #expect(viewModel.newEvent.location.longitude == nil)
        #expect(viewModel.newEvent.category == .other)
        #expect(viewModel.newEvent.creatorId.isEmpty)
        
        #expect(viewModel.selectedImage == nil)
        #expect(viewModel.selectedItem == nil)
    }
    
    @Test func testIsFormValidWithEmptyTitle() {
        let viewModel = EventViewModel()
        viewModel.newEvent.title = ""
        viewModel.newEvent.location = TestEventData.Locations.zenithParis
        
        #expect(viewModel.isFormValid == false)
    }
    
    @Test func testIsFormValidWithEmptyAddress() {
        let viewModel = EventViewModel()
        viewModel.newEvent.title = "Test title"
        viewModel.newEvent.location = TestEventData.Locations.invalidLocation
        
        #expect(viewModel.isFormValid == false)
    }
    
    @Test func testIsFormValidWithUngeocodeableAddress() async {
        let viewModel = EventViewModel()
        viewModel.newEvent.title = "Test title"
        
        await viewModel.geocodeAddress("!!!@@@###")
        
        #expect(viewModel.isFormValid == false)
        #expect(viewModel.newEvent.location.latitude == nil)
        #expect(viewModel.newEvent.location.longitude == nil)
        #expect(viewModel.error == .invalidAddress)
    }
    
    @Test func testIsFormValidWithValidAddress() async {
        let viewModel = EventViewModel()
        viewModel.newEvent.title = "Test title"
        viewModel.newEvent.location = TestEventData.Locations.zenithParis
        
        await viewModel.geocodeAddress(viewModel.newEvent.location.address)
        
        #expect(viewModel.isFormValid == true)
        #expect(viewModel.newEvent.location.latitude != nil)
        #expect(viewModel.newEvent.location.longitude != nil)
        #expect(viewModel.error == nil)
    }
    
    @Test func testFilterEventsBySearchText() {
        let viewModel = EventViewModel()
        
        viewModel.events = [
            TestEventData.Events.concertIronMaiden,
            TestEventData.Events.xCodeConference
        ]
        viewModel.searchText = "xCode"
        
        #expect(viewModel.filteredEvents.count == 1)
        #expect(viewModel.filteredEvents[0].title == TestEventData.Events.xCodeConference.title)
    }
    
    @Test func testSortEventsByDateAscending() {
        let viewModel = EventViewModel()
        
        viewModel.events = [
            TestEventData.Events.tomorrowEvent,
            TestEventData.Events.todayEvent
        ]
        viewModel.applySort(.date(ascending: true))
        
        #expect(viewModel.filteredEvents[0].title == TestEventData.Events.todayEvent.title)
        #expect(viewModel.filteredEvents[1].title == TestEventData.Events.tomorrowEvent.title)
    }
    
    @Test func testFilterEventsByCategory() {
        let viewModel = EventViewModel()
        
        viewModel.events = [
            TestEventData.Events.sportEvent,
            TestEventData.Events.cultureEvent1,
            TestEventData.Events.businessEvent,
            TestEventData.Events.cultureEvent2
        ]
        
        viewModel.applySort(.category(.culture))
        
        #expect(viewModel.filteredEvents.count == 2)
        #expect(viewModel.filteredEvents[0].category == .culture)
        
        viewModel.applySort(.category(.other))
        #expect(viewModel.filteredEvents.count == 0)
    }
}


//import Testing
//@testable import Eventorias
//
//import SwiftUI
//import PhotosUI
//
//
//
//@Test func testCreateEmptyEvent() {
//    let emptyEvent = EventViewModel.createEmptyEvent()
//    
//    #expect(emptyEvent.title.isEmpty)
//    #expect(emptyEvent.description.isEmpty)
//    #expect(emptyEvent.location.address.isEmpty)
//    #expect(emptyEvent.location.latitude == nil)
//    #expect(emptyEvent.location.longitude == nil)
//    #expect(emptyEvent.category == .other)
//    #expect(emptyEvent.creatorId.isEmpty)
//}
//
//@Test func testResetNewEvent() {
//    let viewModel = EventViewModel()
//    viewModel.newEvent.title = "Test title"
//    viewModel.newEvent.description = "Test description"
//    viewModel.newEvent.category = .culture
//    viewModel.newEvent.location = EventLocation(
//        address: "Test address",
//        latitude: 48.8566,
//        longitude: 2.3522
//    )
//    viewModel.newEvent.creatorId = "ID"
//    
//    viewModel.selectedItem = PhotosPickerItem(itemIdentifier: "")
//    #expect(viewModel.selectedItem != nil)
//    viewModel.selectedImage = UIImage()
//    #expect(viewModel.selectedImage != nil)
//    
//    viewModel.resetNewEvent()
//    
//    #expect(viewModel.newEvent.title.isEmpty)
//    #expect(viewModel.newEvent.description.isEmpty)
//    #expect(viewModel.newEvent.location.address.isEmpty)
//    #expect(viewModel.newEvent.location.latitude == nil)
//    #expect(viewModel.newEvent.location.longitude == nil)
//    #expect(viewModel.newEvent.category == .other)
//    #expect(viewModel.newEvent.creatorId.isEmpty)
//    
//    #expect(viewModel.selectedImage == nil)
//    #expect(viewModel.selectedItem == nil)
//}
//
//@Test func testIsFormValidWithEmptyTitle() {
//    let viewModel = EventViewModel()
//    viewModel.newEvent.title = ""
//    viewModel.newEvent.location = EventLocation(
//        address: "Zénith de Paris, 211 Avenue Jean Jaurès, 75019 Paris",
//        latitude: 48.8932,    // Coordonnées réelles du Zénith
//        longitude: 2.3934
//    )
//    
//    #expect(viewModel.isFormValid == false)
//}
//
//@Test func testIsFormValidWithEmptyAddress() {
//    let viewModel = EventViewModel()
//    viewModel.newEvent.title = "Test title"
//    viewModel.newEvent.location = EventLocation(
//        address: "",
//        latitude: nil,
//        longitude: nil
//    )
//    
//    #expect(viewModel.isFormValid == false)
//}
//
//@Test func testIsFormValidWithUngeocodeableAddress() async {
//    let viewModel = EventViewModel()
//    viewModel.newEvent.title = "Test title"
//    viewModel.newEvent.location = EventLocation(
//        address: "Nowhere !",
//        latitude: nil,
//        longitude: nil
//    )
//    
//    await viewModel.geocodeAddress("!!!@@@###") //("Nowhere !") renvoie une géolocalisation valide quelque-part au Pakistan ???! (34°00'24.9"N 72°00'16.2"E = Nowshera)
////    try? await Task.sleep(for: .seconds(2))
//    
//    #expect(viewModel.isFormValid == false)
//    #expect(viewModel.newEvent.location.latitude == nil)
//    #expect(viewModel.newEvent.location.longitude == nil)
//    #expect(viewModel.error == .invalidAddress)
//}
//
//@Test func testIsFormValidWithValidAddress() async {
//    let viewModel = EventViewModel()
//    viewModel.newEvent.title = "Test title"
//    viewModel.newEvent.location = EventLocation(
//        address: "Zénith de Paris, 211 Avenue Jean Jaurès, 75019 Paris",
//        latitude: 48.8932,    // Coordonnées réelles du Zénith
//        longitude: 2.3934
//    )
//    
//    await viewModel.geocodeAddress(viewModel.newEvent.location.address)
////    try? await Task.sleep(for: .seconds(2))
//    
//    #expect(viewModel.isFormValid == true)
//    #expect(viewModel.newEvent.location.latitude != nil)
//    #expect(viewModel.newEvent.location.longitude != nil)
//    #expect(viewModel.error == nil)
//}
//
//@Test func testFilterEventsBySearchText() {
//    let viewModel = EventViewModel()
//    
//    let event1 = Event(
//        title: "Powerslave tour",
//        description: "Concert Iron Maiden",
//        date: Date(),
//        location: EventLocation(
//            address: "Zénith de Paris, 211 Avenue Jean Jaurès, 75019 Paris",
//            latitude: 48.8932,
//            longitude: 2.3934
//        ),
//        category: .culture,
//        creatorId: "1",
//        createdAt: Date()
//    )
//    
//    let event2 = Event(
//        title: "Conférence xCode",
//        description: "le nouveau framework testing",
//        date: Date(),
//        location: EventLocation(
//            address: "Palais des Congrès de Lyon, 50 Quai Charles de Gaulle, 69006 Lyon",
//            latitude: 45.7847,
//            longitude: 4.8520
//        ),
//        category: .business,
//        creatorId: "2",
//        createdAt: Date()
//    )
//    
//    viewModel.events = [event1, event2]
//    viewModel.searchText = "xCode"
//    
//    #expect(viewModel.filteredEvents.count == 1)
//    #expect(viewModel.filteredEvents[0].title == event2.title)
//}
//
//@Test func testSortEventsByDateAscending() {
//    let viewModel = EventViewModel()
//    let today = Date()
//    let tomorrow = Date().addingTimeInterval(86400)
//    
//    let eventTomorrow = Event(
//        title: "Concert",
//        description: "Description Concert",
//        date: tomorrow,
//        location: EventLocation(
//            address: "Zénith de Paris",
//            latitude: 48.8932,
//            longitude: 2.3934
//        ),
//        category: .culture,
//        creatorId: "1",
//        createdAt: Date()
//    )
//    
//    let eventToday = Event(
//        title: "Tournoi tennis",
//        description: "Description tournoi tennis",
//        date: today,
//        location: EventLocation(
//            address: "Palais des Congrès",
//            latitude: 48.8785,
//            longitude: 2.2833
//        ),
//        category: .sports,
//        creatorId: "2",
//        createdAt: Date()
//    )
//    
//    viewModel.events = [eventTomorrow, eventToday]
//    viewModel.applySort(.date(ascending: true))
//    
//    #expect(viewModel.filteredEvents[0].title == eventToday.title)
//    #expect(viewModel.filteredEvents[1].title == eventTomorrow.title)
//}
//
//@Test func testFilterEventsByCategory() {
//    let viewModel = EventViewModel()
//    
//    let eventSport = Event(
//        title: "title sport",
//        description: "description sport",
//        date: Date(),
//        location: EventLocation(
//            address: "Zénith de Paris",
//            latitude: 48.8932,
//            longitude: 2.3934
//        ),
//        category: .sports,
//        creatorId: "1",
//        createdAt: Date()
//    )
//    
//    let eventCulture = Event(
//        title: "title culture",
//        description: "description culture",
//        date: Date(),
//        location: EventLocation(
//            address: "Palais des Congrès",
//            latitude: 48.8785,
//            longitude: 2.2833
//        ),
//        category: .culture,
//        creatorId: "2",
//        createdAt: Date()
//    )
//    
//    let eventBusiness = Event(
//        title: "title business",
//        description: "description business",
//        date: Date(),
//        location: EventLocation(
//            address: "Palais des Congrès",
//            latitude: 48.8785,
//            longitude: 2.2833
//        ),
//        category: .business,
//        creatorId: "2",
//        createdAt: Date()
//    )
//    
//    let eventCulture2 = Event(
//        title: "title culture2",
//        description: "description culture2",
//        date: Date(),
//        location: EventLocation(
//            address: "Palais des Congrès",
//            latitude: 48.8785,
//            longitude: 2.2833
//        ),
//        category: .culture,
//        creatorId: "1",
//        createdAt: Date()
//    )
//    
//    viewModel.events = [eventSport, eventCulture, eventBusiness, eventCulture2]
//    viewModel.applySort(.category(.culture))
//    
//    #expect(viewModel.filteredEvents.count == 2)
//    #expect(viewModel.filteredEvents[0].category == .culture)
//    
//    viewModel.applySort(.category(.other))
//    #expect(viewModel.filteredEvents.count == 0)
//}
