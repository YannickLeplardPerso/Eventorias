//
//  ProfleViewModel.swift
//  Tests
//
//  Created by Yannick LEPLARD on 26/12/2024.
//

import Testing
@testable import Eventorias

import SwiftUI
import FirebaseAuth



@Test func testImageProcessingFailure() {
    let viewModel = ProfileViewModel()
    
    // Firebase Auth n'est pas initialisé donc uploadProfileImage doit échouer
    viewModel.uploadProfileImage(UIImage())
    
    #expect(viewModel.error == .imageProcessingFailed)
}
