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
