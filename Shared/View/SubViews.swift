//
//  SubViews.swift
//  Bah-Soo_AC (iOS)
//
//  Created by Shaun Ku on 2023/1/4.
//

import SwiftUI

struct TimeSelectorRow: View {
    var geometry: GeometryProxy
    var timeTitle: String
    var selectAction: () -> Void
    var displayTime: Date
    var formatter: DateFormatter
    @Binding var showConfirmation: Bool
    var confirmationDisplay: () -> Void
    var confirmationTest: String
    var confirmationYesAction: () -> Void
    var confirmationNoAction: () -> Void
    var selectionDisabled: Bool
    @Binding var btnDisable: Bool
    var body: some View {
        
        HStack(alignment: .center, spacing: 5) {
            Text(timeTitle)
                .lineLimit(1)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .frame(maxWidth: geometry.size.width * 0.25)
                .minimumScaleFactor(0.01)
            Button(action: {
                btnDisable = true
                selectAction()
                btnDisable = false
            }){
                Text(displayTime, formatter: formatter)
                    .lineLimit(1)
                    .padding(5)
                    .foregroundColor(Color(red: 0/255, green: 0/255, blue: 139/255))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .minimumScaleFactor(0.01)
            }
            .disabled(selectionDisabled || btnDisable)
            .frame(maxWidth: geometry.size.width * 0.45)
            .background(Rectangle().cornerRadius(10).foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255)))
            .opacity(selectionDisabled || btnDisable ? 0.3 : 1)
            Button(action: {
                btnDisable = true
                confirmationDisplay()
                btnDisable = false
            }) {
                Text("Punch 🕰")
                    .lineLimit(1)
                    .padding(5)
                    .foregroundColor(Color(red: 139/255, green: 0/255, blue: 0/255))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.01)
            }
            .disabled(selectionDisabled || btnDisable)
            .frame(maxWidth: geometry.size.width * 0.25)
            .background(Rectangle().cornerRadius(10).foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255)))
            .opacity(selectionDisabled || btnDisable ? 0.3 : 1)
            .confirmationDialog("Are you sure to punch current time ?",
                                isPresented: $showConfirmation,
                                titleVisibility: .visible) {
                Button("No", role: .cancel) {
                    confirmationNoAction()
                }
                Button("Yes") {
                    confirmationYesAction()
                }
                
            }
        }
    }
}

struct GrotionCopyright: View {
    var body: some View {
        VStack{
            Spacer()
            Text("© 2023 Grotion")
        }
    }
}

struct CustomizeDivider: View {
    var body: some View {
        Divider()
            .frame(height: 1)
            .overlay(Color("Color_Divider"))
    }
}
