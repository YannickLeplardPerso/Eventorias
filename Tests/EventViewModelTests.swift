//
//  EventViewModelTests.swift
//  Tests
//
//  Created by Yannick LEPLARD on 26/12/2024.
//

import Testing
import SwiftUI
import PhotosUI
@testable import Eventorias



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
