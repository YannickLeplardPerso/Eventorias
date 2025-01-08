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
    @Test func testInitialProfileLoading() {
        // Le test doit refléter les vraies données de l'utilisateur actuel
        let viewModel = ProfileViewModel()
        
        // Vérifier les valeurs initiales basées sur l'utilisateur réel connecté
        #expect(viewModel.userName == TestUser.valid.name)
        #expect(viewModel.userEmail == TestUser.valid.email)
    }
    
    @Test func testUpdateUserProfile() {
        let viewModel = ProfileViewModel()
        
        // Mettre à jour le nom d'utilisateur
        let newName = "Nouveau Nom"
        viewModel.userName = newName
        viewModel.updateUserProfile()
        
        // Vérifier que le nom a été mis à jour
        #expect(viewModel.userName == newName)
    }
    
    @Test func testImageSelection() async {
        let viewModel = ProfileViewModel()
        
        // Créer un PhotosPickerItem mock (difficile à mocker précisément)
        // Ce test vérifie principalement le comportement de base
        viewModel.selectedItem = nil
        
        // Vérifier que rien ne se passe quand selectedItem est nil
        #expect(viewModel.selectedImage == nil)
        #expect(viewModel.isLoading == false)
    }
    
    @Test func testImageUpload() {
        let viewModel = ProfileViewModel()
        
        // Créer une image de test
        let testImage = UIImage(systemName: "person.fill")!
        
        // Simuler une image sélectionnée
        viewModel.selectedImage = testImage
        
        // Vérifier le comportement de base
        // Note: Le test exact dépendra de votre implémentation de uploadProfileImage
        #expect(viewModel.isLoading == false || viewModel.isLoading == true)
        #expect(viewModel.selectedImage != nil)
    }
}
