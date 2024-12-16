//
//  CustomProgressViewComponent.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 11/12/2024.
//

import SwiftUI



struct CustomProgressViewComponent: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .evMain))
    }
}
