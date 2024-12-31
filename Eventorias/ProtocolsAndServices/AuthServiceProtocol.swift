//
//  AuthServiceProtocol.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 24/12/2024.
//

//import Foundation
//
//
//
//protocol AuthServiceProtocol {
//    var currentUser: UserProtocol? { get }
//    func signIn(email: String, password: String) async throws -> UserProtocol
//}
//
//protocol UserProtocol {
//    var uid: String { get }
//    var email: String? { get }
//    var displayName: String? { get }
//    // NEW
//    var photoURL: URL? { get }
//    func createProfileChangeRequest() -> ProfileChangeRequest
//}
//
//protocol ProfileChangeRequest {
//    var displayName: String? { get set }
//    var photoURL: URL? { get set }
//    func commitChanges() async throws
//}
