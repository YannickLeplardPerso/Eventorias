//
//  AuthViewModelTests.swift
//  EventoriasTests
//
//  Created by Yannick LEPLARD on 17/12/2024.
//

//import Testing
//import FirebaseAuth



//struct AuthViewModelTests {
//    @Test func testSignInWithEmptyEmail() async throws {
//        let viewModel = AuthViewModel()
//        
//        viewModel.signIn(email: "", password: "password123") {}
//        
//        expect(viewModel.error).toBe(.invalidEmail)
//        expect(viewModel.isLoading).toBe(false)
//        expect(viewModel.isAuthenticated).toBe(false)
//    }
//}
    
//    @Test func testSignInSuccess() async throws {
//        let viewModel = AuthViewModel()
//        let completionExpectation = expectation(description: "Completion called")
//        
//        // Mock successful Firebase auth response
//        MockFirebaseAuth.mockSignInSuccess()
//        
//        await viewModel.signIn(email: "test@example.com", password: "password123") {
//            completionExpectation.fulfill()
//        }
//        
//        await waitForExpectations(timeout: 1.0)
//        
//        expect(viewModel.isAuthenticated).toBe(true)
//        expect(viewModel.error).toBe(nil)
//        expect(viewModel.isLoading).toBe(false)
//    }
//    
//    @Test func testSignInFailure() async throws {
//        let viewModel = AuthViewModel()
//        
//        // Mock Firebase auth error
//        MockFirebaseAuth.mockSignInFailure(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"]))
//        
//        await viewModel.signIn(email: "test@example.com", password: "wrongpassword") {}
//        
//        expect(viewModel.isAuthenticated).toBe(false)
//        expect(viewModel.error).toBe(.unknownError("signIn failed : Invalid credentials"))
//        expect(viewModel.isLoading).toBe(false)
//    }
//    
//    @Test func testSignUpWithEmptyName() async throws {
//        let viewModel = AuthViewModel()
//        
//        await viewModel.signUp(email: "test@example.com", password: "password123", name: "") {}
//        
//        expect(viewModel.error).toBe(.nameRequired)
//        expect(viewModel.isLoading).toBe(false)
//        expect(viewModel.isAuthenticated).toBe(false)
//    }
//    
//    @Test func testSignUpSuccess() async throws {
//        let viewModel = AuthViewModel()
//        let completionExpectation = expectation(description: "Completion called")
//        
//        // Mock successful Firebase create user and profile update
//        MockFirebaseAuth.mockCreateUserSuccess()
//        MockFirebaseAuth.mockUpdateProfileSuccess()
//        
//        await viewModel.signUp(email: "test@example.com", password: "password123", name: "John Doe") {
//            completionExpectation.fulfill()
//        }
//        
//        await waitForExpectations(timeout: 1.0)
//        
//        expect(viewModel.isAuthenticated).toBe(true)
//        expect(viewModel.error).toBe(nil)
//        expect(viewModel.isLoading).toBe(false)
//    }
//    
//    @Test func testSignUpFailureOnCreateUser() async throws {
//        let viewModel = AuthViewModel()
//        
//        // Mock Firebase create user error
//        MockFirebaseAuth.mockCreateUserFailure(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email already exists"]))
//        
//        await viewModel.signUp(email: "existing@example.com", password: "password123", name: "John Doe") {}
//        
//        expect(viewModel.isAuthenticated).toBe(false)
//        expect(viewModel.error).toBe(.unknownError("signUpFirebase failed : Email already exists"))
//        expect(viewModel.isLoading).toBe(false)
//    }
//    
//    @Test func testSignUpFailureOnProfileUpdate() async throws {
//        let viewModel = AuthViewModel()
//        
//        // Mock successful user creation but failed profile update
//        MockFirebaseAuth.mockCreateUserSuccess()
//        MockFirebaseAuth.mockUpdateProfileFailure(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Profile update failed"]))
//        
//        await viewModel.signUp(email: "test@example.com", password: "password123", name: "John Doe") {}
//        
//        expect(viewModel.isAuthenticated).toBe(false)
//        expect(viewModel.error).toBe(.unknownError("signUp failed : Profile update failed"))
//        expect(viewModel.isLoading).toBe(false)
//    }
//}

// Mock Firebase Auth helper
//private class MockFirebaseAuth {
//    static func mockSignInSuccess() {
//        // Implement Firebase Auth mocking here
//    }
//    
//    static func mockSignInFailure(error: Error) {
//        // Implement Firebase Auth error mocking here
//    }
//    
//    static func mockCreateUserSuccess() {
//        // Implement user creation success mocking here
//    }
//    
//    static func mockCreateUserFailure(error: Error) {
//        // Implement user creation failure mocking here
//    }
//    
//    static func mockUpdateProfileSuccess() {
//        // Implement profile update success mocking here
//    }
//    
//    static func mockUpdateProfileFailure(error: Error) {
//        // Implement profile update failure mocking here
//    }
//}
