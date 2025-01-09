//
//  ProfleViewModelTests.swift
//  Tests
//
//  Created by Yannick LEPLARD on 26/12/2024.
//

import Foundation
@testable import Eventorias
import FirebaseAuth
import Testing
import UIKit
import PhotosUI



struct ProfileViewModelTests {
    private func signinTestUser() async throws {
        try await FirebaseAuthService().signIn(email: TestUser.valid.email, password: TestUser.valid.password)
        try await Auth.auth().currentUser?.reload()
    }
    
    // pour remettre le bon nom à l'utilisateur (en cas de bug)
//    func configureTestUser() async throws {
//        guard let user = Auth.auth().currentUser else { return }
//        
//        let changeRequest = user.createProfileChangeRequest()
//        changeRequest.displayName = TestUser.valid.name
//        try await changeRequest.commitChanges()
//        try await user.reload()
//    }
    
    @Test func testInitialProfileLoading() async throws {
//        try await configureTestUser()
        try await signinTestUser()
        let viewModel = ProfileViewModel()
        
        #expect(viewModel.userEmail == TestUser.valid.email)
        #expect(viewModel.userName == TestUser.valid.name)
    }
    
     
    @Test func testUpdateUserProfile() async throws {
        try await signinTestUser()
        let viewModel = ProfileViewModel()
       
        let originalName = viewModel.userName
        let newName = "New TestName"
        
        viewModel.userName = newName
        await viewModel.updateUserProfile()
        
        let newViewModel = ProfileViewModel()
        
        #expect(newViewModel.userName == newName)
        
        viewModel.userName = originalName
        await viewModel.updateUserProfile()
        
        let finalViewModel = ProfileViewModel()
        #expect(finalViewModel.userName == originalName)
    }
}
