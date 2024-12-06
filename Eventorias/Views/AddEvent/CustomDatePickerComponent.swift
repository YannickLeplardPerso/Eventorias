//
//  CustomDatePickerComponent.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 05/12/2024.
//

import SwiftUI

struct CustomDatePickerComponent: View {
    let title: String
    @Binding var date: Date
    let components: DatePickerComponents
    
    var body: some View {
        ZStack(alignment: .leading) {
            DatePicker("", selection: $date, displayedComponents: components)
                .labelsHidden()
                .padding(.horizontal, 12)
                .padding(.top, 28)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Text(title)
                        .font(.system(size: 12))
                        .foregroundColor(.evGraybis)
                        .padding(.leading, 12)
                        .padding(.top, 8),
                    alignment: .topLeading
                )
        }
        .background(.evBackground)
        .cornerRadius(6)
    }
}



struct CustomDatePickerComponent_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 12) {
            CustomDatePickerComponent(
                title: "Date",
                date: .constant(Date()),
                components: .date
            )
            .layoutPriority(1)
            
            CustomDatePickerComponent(
                title: "Time",
                date: .constant(Date()),
                components: .hourAndMinute
            )
            .layoutPriority(1)
        }
        .padding(.horizontal)
    }
}
