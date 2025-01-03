//
//  AuthViewModelTests.swift
//  Tests
//
//  Created by Yannick LEPLARD on 17/12/2024.
//

import Testing
@testable import Eventorias
import Foundation



@Test func testSignInWithEmptyEmail() async {
    let viewModel = AuthViewModel()
    await viewModel.signIn(email: "", password: "Qswd123!!AlNb1@")
    
    #expect(viewModel.error == EventError.invalidEmail)
}

@Test func testSignInWithEmptyPassword() async {
    let viewModel = AuthViewModel()
    await viewModel.signIn(email: "yannick@gmail.com", password: "")
    
    #expect(viewModel.error == EventError.invalidPassword)
}

@Test func testSuccessfulSignIn() async {
    let mockAuth: AuthServiceProtocol = MockAuthService()
    let viewModel = AuthViewModel(authService: mockAuth)
    
    await viewModel.signIn(email: "test@example.com", password: "password123")
    
    #expect(viewModel.isAuthenticated == true)
    #expect(viewModel.error == nil)
}

@Test func testSignUpWithEmptyName() async {
    let viewModel = AuthViewModel()
    await viewModel.signUp(email: "test@gmail.com", password: "Qswd123!!AlNb1@", name: "")
    
    #expect(viewModel.error == EventError.nameRequired)
}

@Test func testSignUpWithEmptyEmail() async {
    let viewModel = AuthViewModel()
    await viewModel.signUp(email: "", password: "Qswd123!!AlNb1@", name: "Yannick")
    
    #expect(viewModel.error == EventError.invalidEmail)
}

@Test func testSignUpWithEmptyPassword() async {
    let viewModel = AuthViewModel()
    await viewModel.signUp(email: "test@gmail.com", password: "", name: "Yannick")
    
    #expect(viewModel.error == EventError.invalidPassword)
}
