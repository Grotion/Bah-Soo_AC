//
//  HomePage.swift
//  Bah-Soo_AC (iOS)
//
//  Created by Shaun Ku on 2022/11/29.
//

import SwiftUI

struct HomePage: View {
    @Binding var currentPage:Page
    @ObservedObject var attendanceData:AttendanceData
    @State private var isReset:Bool = false
    @State private var inputAlert:Bool = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .center, spacing: 10) {
                    HStack {
                        Spacer()
                        Button(action: {
                            currentPage = Page.InstructionPage
                        }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 30))
                                .foregroundColor(Color(red: 147/255, green: 112/255, blue: 219/255))
                                .frame(width: geometry.size.width*0.1, height: geometry.size.width*0.1)
                                .scaledToFit()
                        }
                        .padding(5)
                    }
                    Spacer()
                    Group {
                        Text("Bah-Soo")
                            .foregroundColor(Color(red: 0/255, green: 88/255, blue: 161/255))
                            .font(.custom("AvenirNextCondensed-Bold", size: 36))
                            .lineLimit(1)
                            .frame(width: geometry.size.width*0.8)
                            .minimumScaleFactor(0.01)
                        Text("Attendance Calculator")
                            .foregroundColor(Color(red: 189/255, green: 0/255, blue: 44/255))
                            .font(.system(.largeTitle))
                            .fontWeight(.heavy)
                            .lineLimit(1)
                            .frame(width: geometry.size.width*0.8)
                            .minimumScaleFactor(0.01)
                    }
                    Spacer()
                    Group {
                        TimeSelectorRow(geometry: geometry,
                                        timeTitle: "Clock In",
                                        selectAction: { attendanceData.selectClockIn() },
                                        displayTime: attendanceData.attendance.clockIn,
                                        formatter: attendanceData.formatter,
                                        showConfirmation: $attendanceData.punchClockInConfrimation,
                                        confirmationDisplay: { attendanceData.punchClockInConfrimation = true },
                                        confirmationTest: "Are you sure to punch current time ?",
                                        confirmationYesAction: { attendanceData.punchClockIn() },
                                        confirmationNoAction: {attendanceData.punchClockInConfrimation = false},
                                        selectionDisabled: false
                        )
                        Toggle(isOn: $attendanceData.attendance.isKanda) {
                            Label("Go to Kanda?", systemImage: "figure.walk")
                                .lineLimit(1)
                                .foregroundColor(Color("Color_GoToKanda"))
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                        }
                        .padding()
                        .tint(Color(red: 189/255, green: 0/255, blue: 44/255))
                        .controlSize(.large)
                        .toggleStyle(.automatic)
                        .frame(maxWidth: geometry.size.width * 0.8)
                        TimeSelectorRow(geometry: geometry,
                                        timeTitle: "Kanda In",
                                        selectAction: { attendanceData.selectKandaIn() },
                                        displayTime: attendanceData.attendance.kandaIn,
                                        formatter: attendanceData.formatter,
                                        showConfirmation: $attendanceData.punchKandaInConfrimation,
                                        confirmationDisplay: { attendanceData.punchKandaInConfrimation = true },
                                        confirmationTest: "Are you sure to punch current time ?",
                                        confirmationYesAction: { attendanceData.punchKandaIn() },
                                        confirmationNoAction: { attendanceData.punchKandaInConfrimation = false },
                                        selectionDisabled: !attendanceData.attendance.isKanda
                        )
                        TimeSelectorRow(geometry: geometry,
                                        timeTitle: "Kanda Out",
                                        selectAction: { attendanceData.selectKandaOut() },
                                        displayTime: attendanceData.attendance.kandaOut,
                                        formatter: attendanceData.formatter,
                                        showConfirmation: $attendanceData.punchKandaOutConfrimation,
                                        confirmationDisplay: { attendanceData.punchKandaOutConfrimation = true },
                                        confirmationTest: "Are you sure to punch current time ?",
                                        confirmationYesAction: { attendanceData.punchKandaOut() },
                                        confirmationNoAction: { attendanceData.punchKandaOutConfrimation = false },
                                        selectionDisabled: !attendanceData.attendance.isKanda
                        )
                    }
                    Spacer()
                    Button(action: {
                        if(attendanceData.checkTimeValid()) {
                            attendanceData.calculate()
                            currentPage = Page.ResultPage
                        }
                    }) {
                        Text("Calculate")
                            .padding()
                            .foregroundColor(Color(red: 0/255, green: 250/255, blue: 154/255))
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .background(Rectangle().cornerRadius(10).foregroundColor(.blue))
                            .minimumScaleFactor(0.01)
                    }
                    Spacer()
                }
                .alert("Warning", isPresented: $attendanceData.isInputAlert, actions: {
                    Button("Check my time again") { }
                }, message: {
                    Text(attendanceData.alertMsg)
                })
                .sheet(isPresented: $attendanceData.timeSelector.showSelectorSheet) {
                    VStack(alignment: .center, spacing: 20) {
                        HStack {
                            Button(action: {
                                attendanceData.timeSelector.showSelectorSheet = false
                            }){
                                Label("Back", systemImage: "chevron.backward")
                                .foregroundColor(Color.blue)
                                .font(.system(size: 20, weight: .light, design: .rounded))
                            }
                            .padding(5)
                            Spacer()
                        }
                        Spacer()
                        Text(attendanceData.timeSelector.description)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 14, weight: .light, design: .rounded))
                            .minimumScaleFactor(0.01)
                        DatePicker("",
                                   selection: $attendanceData.timeSelector.selectDate)
//                                   in: attendanceData.timeSelector.range,
//                                   displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                            .datePickerStyle(GraphicalDatePickerStyle())
                        Spacer()
                        HStack(alignment: .center, spacing: 10){
                            Button(action: {
                                attendanceData.timeSelector.getTime()
                            }){
                                Text("Now")
                                    .padding(5)
                                    .foregroundColor(Color("Color_NowBtnFg"))
                                    .font(.system(size: 20, weight: .light, design: .rounded))
                                    .frame(width: geometry.size.width*0.3)
                                    .background(Rectangle().cornerRadius(10).foregroundColor(Color("Color_NowBtnBg")))
                                    .minimumScaleFactor(0.01)
                            }
                            Button(action: {
                                attendanceData.timeSelector.reset()
                            }){
                                Text("Reset")
                                    .padding(5)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 20, weight: .light, design: .rounded))
                                    .minimumScaleFactor(0.01)
                                    .frame(width: geometry.size.width*0.3)
                                    .background(Rectangle().cornerRadius(10).foregroundColor(.red))
                            }
                        }
                        Button(action: {
                            attendanceData.timeSelector.saveConfirmation = true
                            // attendanceData.timeSelector.save()
                        }){
                            Text("Save")
                                .padding(5)
                                .foregroundColor(Color.green)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .minimumScaleFactor(0.01)
                                .frame(width: geometry.size.width*0.6)
                                .background(Rectangle().cornerRadius(10).foregroundColor(Color("Color_SaveBtnBg")))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                                .confirmationDialog("Are you sure to save selected time ?",
                                                    isPresented: $attendanceData.timeSelector.saveConfirmation,
                                                    titleVisibility: .visible) {
                                    Button("No", role: .cancel) {}
                                    Button("Yes") {
                                        attendanceData.timeSelector.save()
                                        DispatchQueue.main.async {
                                            attendanceData.timeSelector.showSelectorSheet = false
                                        }
                                    }
                                }
                        }
                        Spacer()
                    }
                    .padding(10)
                }
                VStack {
                    Spacer()
                    GrotionCopyright()
                        .padding(5)
                }
            }
        }
    }
}


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(currentPage: .constant(Page.HomePage), attendanceData: AttendanceData())
    }
}

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
    var body: some View {
        
        HStack(alignment: .center, spacing: 5) {
            Text(timeTitle)
                .lineLimit(1)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .frame(maxWidth: geometry.size.width * 0.25)
                .minimumScaleFactor(0.01)
            Button(action: {
                selectAction()
            }){
                Text(displayTime, formatter: formatter)
                    .lineLimit(1)
                    .padding(5)
                    .foregroundColor(Color(red: 0/255, green: 0/255, blue: 139/255))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .minimumScaleFactor(0.01)
            }
            .disabled(selectionDisabled)
            .frame(maxWidth: geometry.size.width * 0.45)
            .background(Rectangle().cornerRadius(10).foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255)))
            .opacity(selectionDisabled ? 0.3 : 1)
            Button(action: {
                confirmationDisplay()
            }) {
                Text("Punch 🕰")
                    .lineLimit(1)
                    .padding(5)
                    .foregroundColor(Color(red: 139/255, green: 0/255, blue: 0/255))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.01)
            }
            .disabled(selectionDisabled)
            .frame(maxWidth: geometry.size.width * 0.25)
            .background(Rectangle().cornerRadius(10).foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255)))
            .opacity(selectionDisabled ? 0.3 : 1)
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
