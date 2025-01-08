//
//  AuthViewModelTests.swift
//  Tests
//
//  Created by Yannick LEPLARD on 17/12/2024.
//

import Foundation
import Testing
@testable import Eventorias



//struct TestUser {
//    let name: String
//    let email: String
//    let password: String
//    
//    static let valid = TestUser(
//        name: "Yannick TEST",
//        email: "yannick@example.com",
//        password: "StrongP@ssw0rd42!"
//    )
//}

struct AuthViewModelTests {
    @Test func testSignInWithEmptyEmail() async {
        let viewModel = AuthViewModel()
        await viewModel.signIn(email: "", password: TestUser.valid.password)
        
        #expect(viewModel.error == .invalidEmail)
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.isLoading == false)
    }
    
    @Test func testSignInWithEmptyPassword() async {
        let viewModel = AuthViewModel()
        await viewModel.signIn(email: TestUser.valid.email, password: "")
        
        #expect(viewModel.error == .invalidPassword)
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.isLoading == false)
    }
    
    @Test func testSuccessfulSignIn() async {
        let mockAuth = MockAuthService()
        let viewModel = AuthViewModel(authService: mockAuth)
        
        await viewModel.signIn(email: TestUser.valid.email, password: TestUser.valid.password)
        
        #expect(viewModel.isAuthenticated == true)
        #expect(viewModel.error == nil)
        #expect(viewModel.isLoading == false)
    }
    
    @Test func testFailedSignIn() async {
        let mockAuth = MockAuthService()
        mockAuth.shouldSucceed = false
        let viewModel = AuthViewModel(authService: mockAuth)
        
        await viewModel.signIn(email: TestUser.valid.email, password: "wrong")
        
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.error != nil)
        #expect(viewModel.isLoading == false)
    }
    
    @Test func testSignUpWithEmptyName() async {
        let viewModel = AuthViewModel()
        await viewModel.signUp(
            email: TestUser.valid.email,
            password: TestUser.valid.password,
            name: ""
        )
        
        #expect(viewModel.error == .nameRequired)
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.isLoading == false)
    }
    
    @Test func testSuccessfulSignUp() async {
        let mockAuth = MockAuthService()
        let viewModel = AuthViewModel(authService: mockAuth)
        
        await viewModel.signUp(
            email: TestUser.valid.email,
            password: TestUser.valid.password,
            name: TestUser.valid.name
        )
        
        #expect(viewModel.isAuthenticated == true)
        #expect(viewModel.error == nil)
        #expect(viewModel.isLoading == false)
    }
    
    @Test func testFailedSignUp() async {
        let mockAuth = MockAuthService()
        mockAuth.shouldSucceed = false
        let viewModel = AuthViewModel(authService: mockAuth)
        
        await viewModel.signUp(
            email: TestUser.valid.email,
            password: TestUser.valid.password,
            name: TestUser.valid.name
        )
        
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.error != nil)
        #expect(viewModel.isLoading == false)
    }
}
