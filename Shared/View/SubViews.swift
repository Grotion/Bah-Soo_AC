//
//  SubViews.swift
//  Bah-Soo_AC (iOS)
//
//  Created by Shaun Ku on 2023/1/4.
//

import SwiftUI

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
