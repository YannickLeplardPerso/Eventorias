//
//  EventViewModelTests.swift
//  EventoriasTests
//
//  Created by Yannick LEPLARD on 16/12/2024.
//

import XCTest
@testable import Eventorias



@MainActor
final class EventViewModelTests: XCTestCase {
    var sut: EventViewModel!
    
    override func setUp() async throws {
        sut = EventViewModel()
    }
    
    override func tearDown() async throws {
        sut = nil
    }
    
    func test_initViewModel_shouldCreateEmptyEvent() async throws {
        XCTAssertTrue(sut.newEvent.title.isEmpty)
        XCTAssertTrue(sut.newEvent.location.isEmpty)
        XCTAssertEqual(sut.newEvent.category, .other)
    }
    
    func test_isFormValid_withEmptyTitle_shouldReturnFalse() async throws {
        // Given
        sut.newEvent.title = ""
        sut.newEvent.location = "Some location"
        
        // Then
        XCTAssertFalse(sut.isFormValid)
    }
    
    func test_isFormValid_withEmptyLocation_shouldReturnFalse() async throws {
        // Given
        sut.newEvent.title = "Some title"
        sut.newEvent.location = ""
        
        // Then
        XCTAssertFalse(sut.isFormValid)
    }
    
    func test_isFormValid_withValidData_shouldReturnTrue() async throws {
        // Given
        sut.newEvent.title = "Some title"
        sut.newEvent.location = "Some location"
        
        // Then
        XCTAssertTrue(sut.isFormValid)
    }
    
    func test_resetNewEvent_shouldClearAllFields() async throws {
        // Given
        sut.newEvent.title = "Some title"
        sut.newEvent.location = "Some location"
        sut.selectedImage = UIImage()
        
        // When
        sut.resetNewEvent()
        
        // Then
        XCTAssertTrue(sut.newEvent.title.isEmpty)
        XCTAssertTrue(sut.newEvent.location.isEmpty)
        XCTAssertNil(sut.selectedImage)
    }
    
    func test_filteredEvents_withEmptySearchText_shouldReturnAllEvents() async throws {
        // Given
        let events = [
            createSampleEvent(title: "Event 1"),
            createSampleEvent(title: "Event 2")
        ]
        sut.events = events
        sut.searchText = ""
        
        // Then
        XCTAssertEqual(sut.filteredEvents.count, events.count)
    }
    
    func test_filteredEvents_withMatchingSearchText_shouldFilterEvents() async throws {
        // Given
        sut.events = [
            createSampleEvent(title: "Concert Rock"),
            createSampleEvent(title: "Business Meeting")
        ]
        sut.searchText = "Rock"
        
        // Then
        XCTAssertEqual(sut.filteredEvents.count, 1)
        XCTAssertEqual(sut.filteredEvents.first?.title, "Concert Rock")
    }
    
    // Helper method to create sample events
    private func createSampleEvent(title: String) -> Event {
        Event(
            title: title,
            description: "Description",
            date: Date(),
            location: "Location",
            category: .other,
            creatorId: "creator123",
            createdAt: Date()
        )
    }
}
