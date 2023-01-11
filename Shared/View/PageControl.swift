//
//  PageControl.swift
//  Bah-Soo_AC (iOS)
//
//  Created by Shaun Ku on 2022/11/29.
//

import SwiftUI

enum Page {
    case HomePage, InstructionPage, ResultPage
}

struct PageControl: View {
    @State var currentPage = Page.HomePage
    @ObservedObject var attendanceData = AttendanceData()
    var body: some View {
        GeometryReader { geometry in
            ZStack
            {
                switch currentPage
                {
                    case Page.HomePage: HomePage(currentPage: $currentPage, attendanceData: attendanceData)
                    case Page.InstructionPage: InstructionPage(currentPage: $currentPage)
                    case Page.ResultPage: ResultPage(currentPage: $currentPage, attendanceData: attendanceData)
                }
            }
//            .padding(10)
            .frame(width: geometry.size.width * 0.99, height: geometry.size.height*0.99)
        }
    }
}


struct PageControl_Previews: PreviewProvider {
    static var previews: some View {
        PageControl()
    }
}

