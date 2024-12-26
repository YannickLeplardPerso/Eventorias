//
//  AuthViewModelTests.swift
//  Tests
//
//  Created by Yannick LEPLARD on 17/12/2024.
//

import Testing
@testable import Eventorias



@Test func testSignInWithEmptyEmail() {
    let viewModel = AuthViewModel()
    viewModel.signIn(email: "", password: "Qswd123!!AlNb1@") {}
    
    #expect(viewModel.error == EventError.invalidEmail)
}

@Test func testSignInWithEmptyPassword() {
    let viewModel = AuthViewModel()
    viewModel.signIn(email: "yannick@gmail.com", password: "") {}
    
    #expect(viewModel.error == EventError.invalidPassword)
}

//@Test func testSuccessfulSignIn() async {
//    let viewModel = AuthViewModel(auth: MockFirebaseAuth())
//    viewModel.signIn(email: "test@gmail.com", password: "Qswd123!!AlNb1@") {}
//    #expect(viewModel.isAuthenticated == true)
//    #expect(viewModel.error == nil)
//}

@Test func testSignUpWithEmptyName() {
    let viewModel = AuthViewModel()
    viewModel.signUp(email: "test@gmail.com", password: "Qswd123!!AlNb1@", name: "") {}
    
    #expect(viewModel.error == EventError.nameRequired)
}

@Test func testSignUpWithEmptyEmail() {
    let viewModel = AuthViewModel()
    viewModel.signUp(email: "", password: "Qswd123!!AlNb1@", name: "Yannick") {}
    
    #expect(viewModel.error == EventError.invalidEmail)
}

@Test func testSignUpWithEmptyPassword() {
    let viewModel = AuthViewModel()
    viewModel.signUp(email: "test@gmail.com", password: "", name: "Yannick") {}
    
    #expect(viewModel.error == EventError.invalidPassword)
}
