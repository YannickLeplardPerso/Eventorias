//
//  AuthServiceProtocol.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 24/12/2024.
//

import Foundation



protocol AuthServiceProtocol {
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String, name: String) async throws
}

//protocol AuthServiceProtocol {
//    var currentUser: UserProtocol? { get }
//    func signIn(email: String, password: String) async throws -> UserProtocol
//    func signUp(email: String, password: String, name: String) async throws -> UserProtocol
//}
//
//protocol UserProtocol {
//    var uid: String { get }
//    var email: String? { get }
//    var displayName: String? { get }
//    var photoURL: URL? { get }
//    func updateProfile(displayName: String?) async throws
//}
