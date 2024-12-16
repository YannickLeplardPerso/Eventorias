//
//  AuthViewModelTests.swift
//  EventoriasTests
//
//  Created by Yannick LEPLARD on 16/12/2024.
//

import XCTest
@testable import Eventorias



@MainActor
final class AuthViewModelTests: XCTestCase {
    var sut: AuthViewModel!

    override func setUp() async throws {
        sut = AuthViewModel()
    }

    override func tearDown() async throws {
        sut = nil
    }

    // MARK: - Sign In Tests
    
    func test_signIn_withEmptyEmail_shouldReturnInvalidEmailError() async throws {
        // Given
        let email = ""
        let password = "password123"
        
        // When
        sut.signIn(email: email, password: password) { }
        
        // Then
        XCTAssertEqual(sut.error, .invalidEmail)
        XCTAssertFalse(sut.isAuthenticated)
    }
    
    func test_signIn_withValidCredentials_shouldAuthenticate() async {
        // Given
        let expectation = expectation(description: "Sign in completion")
        let email = "test@test.com"
        let password = "password123"
        
        // When
        sut.signIn(email: email, password: password) {
            expectation.fulfill()
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 2)
        XCTAssertTrue(sut.isAuthenticated)
        XCTAssertNil(sut.error)
    }
    
    // MARK: - Sign Up Tests
    
    func test_signUp_withEmptyName_shouldReturnNameRequiredError() async throws {
        // Given
        let email = "test@test.com"
        let password = "password123"
        let name = ""
        
        // When
        sut.signUp(email: email, password: password, name: name) { }
        
        // Then
        XCTAssertEqual(sut.error, .nameRequired)
        XCTAssertFalse(sut.isAuthenticated)
    }
    
    func test_signUp_shouldSetLoadingState() async {
        // Given
        let email = "test@test.com"
        let password = "password123"
        let name = "John Doe"
        
        // When
        sut.signUp(email: email, password: password, name: name) { }
        
        // Then
        XCTAssertTrue(sut.isLoading)
        // Note: We should also test that isLoading becomes false, but that would require mocking Firebase
    }
}
