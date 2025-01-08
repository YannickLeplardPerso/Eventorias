//
//  TestUser.swift
//  Tests
//
//  Created by Yannick LEPLARD on 04/01/2025.
//

import Foundation



struct TestUser {
    let name: String
    let email: String
    let password: String
}

extension TestUser {
    static let valid = TestUser(
        name: "User Test",
        email: "test@exemple.com",
        password: "TestPassword@42!"
    )
}
