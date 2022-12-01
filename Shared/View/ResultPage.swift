//
//  ResultPage.swift
//  Bah-Soo_AC (iOS)
//
//  Created by Shaun Ku on 2022/11/29.
//

import SwiftUI

struct ResultPage: View {
    @Binding var currentPage:Page
    @ObservedObject var attendanceData:AttendanceData
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button(action: {
                        currentPage = Page.HomePage
                    }, label: {
                        Image(systemName: "arrow.backward.circle")
                            .font(.system(size: 30))
                            .foregroundColor(Color(red: 147/255, green: 112/255, blue: 219/255))
                            .frame(width: geometry.size.width*0.1, height: geometry.size.width*0.1)
                            .scaledToFit()
                    })
                        .padding(5)
                    Spacer()
                }
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        TimeRow(showedTest: "Clock In:", date: attendanceData.attendance.clockIn, formatter: attendanceData.formatter)
                        TimeRow(showedTest: "Clock Out:", date: attendanceData.clockOut, formatter: attendanceData.formatter)
                        Divider()
                        if(attendanceData.attendance.isKanda) {
                            TimeRow(showedTest: "Kanda In:", date: attendanceData.attendance.kandaIn, formatter: attendanceData.formatter)
                            TimeRow(showedTest: "Kanda Out:", date: attendanceData.attendance.kandaOut, formatter: attendanceData.formatter)
                            HStack{
                                Text("Time In Kanda:")
                                    .font(.custom("Helvetica", size: 18))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.01)
                                Spacer()
                                Text("\(attendanceData.timeInKanda.hour ?? 0) hr \(attendanceData.timeInKanda.minute ?? 0) min")
                                    .font(.custom("Helvetica", size: 18))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.01)
                            }
                            Divider()
                        }
                        TimeRow(showedTest: "Overtime Starts:", date: attendanceData.overtimeStart, formatter: attendanceData.formatter)
                        ForEach(attendanceData.overtime.indices, id: \.self) {
                            (index) in
                            TimeRow(showedTest: "Overtime \(Double(index)*0.5+1) hr:", date: attendanceData.overtime[index], formatter: attendanceData.formatter)
                        }
                    }
                }
                .padding(10)
                .frame(width: geometry.size.width*0.95, height: geometry.size.height*0.9)
                Spacer()
            }
        }
    }
}


struct ResultPage_Previews: PreviewProvider {
    static var previews: some View {
        ResultPage(currentPage: .constant(Page.ResultPage), attendanceData: AttendanceData())
    }
}

struct TimeRow: View {
    var showedTest:String
    var date: Date
    var formatter: DateFormatter
    var body: some View {
        HStack{
            Text("\(showedTest)")
                .font(.custom("Helvetica", size: 18))
                .lineLimit(1)
                .minimumScaleFactor(0.01)
            Spacer()
            Text(date, formatter: formatter)
                .font(.custom("Helvetica", size: 18))
                .lineLimit(1)
                .minimumScaleFactor(0.01)
        }
    }
}
