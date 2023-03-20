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
    @State private var btnDisable:Bool = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .center, spacing: 10) {
                    HStack {
                        Spacer()
                        Button(action: {
                            btnDisable = true
                            currentPage = Page.InstructionPage
                            btnDisable = false
                        }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 30))
                                .foregroundColor(Color(red: 147/255, green: 112/255, blue: 219/255))
                                .frame(width: geometry.size.width*0.1, height: geometry.size.width*0.1)
                                .scaledToFit()
                        }
                        .padding(5)
                        .disabled(btnDisable)
                        .opacity(btnDisable ? 0.3 : 1)
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
                                        selectionDisabled: false,
                                        btnDisable: $btnDisable
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
                        .disabled(btnDisable)
                        .opacity(btnDisable ? 0.3 : 1)
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
                                        selectionDisabled: !attendanceData.attendance.isKanda,
                                        btnDisable: $btnDisable
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
                                        selectionDisabled: !attendanceData.attendance.isKanda,
                                        btnDisable: $btnDisable
                        )
                    }
                    Spacer()
                    Button(action: {
                        btnDisable = true
                        if(attendanceData.checkTimeValid()) {
                            attendanceData.calculate()
                            currentPage = Page.ResultPage
                        }
                        btnDisable = false
                    }) {
                        Text("Calculate")
                            .padding()
                            .foregroundColor(Color(red: 0/255, green: 250/255, blue: 154/255))
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .background(Rectangle().cornerRadius(10).foregroundColor(.blue))
                            .minimumScaleFactor(0.01)
                    }
                    .disabled(btnDisable)
                    .opacity(btnDisable ? 0.3 : 1)
                    Spacer()
                }
                .alert("Warning", isPresented: $attendanceData.isInputAlert, actions: {
                    Button("Check my time again") { }
                }, message: {
                    Text(attendanceData.alertMsg)
                })
                VStack {
                    Spacer()
                    GrotionCopyright()
                        .padding(5)
                }
            }
            .sheet(isPresented: $attendanceData.timeSelector.showSelectorSheet) {
                VStack(alignment: .center, spacing: 20) {
                    HStack {
                        Button(action: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                btnDisable = true
                                attendanceData.timeSelector.showSelectorSheet = false
                                btnDisable = false
                            }
                        }){
                            Label("Back", systemImage: "chevron.backward")
                            .foregroundColor(Color.blue)
                            .font(.system(size: 20, weight: .light, design: .rounded))
                        }
                        .padding(5)
                        .disabled(btnDisable)
                        .opacity(btnDisable ? 0.3 : 1)
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
                            .disabled(btnDisable)
                            .opacity(btnDisable ? 0.3 : 1)
                            .padding()
                    Spacer()
                    HStack(alignment: .center, spacing: 10){
                        Button(action: {
                            btnDisable = true
                            attendanceData.timeSelector.getTime()
                            btnDisable = false
                        }){
                            Text("Now")
                                .padding(5)
                                .foregroundColor(Color("Color_NowBtnFg"))
                                .font(.system(size: 20, weight: .light, design: .rounded))
                                .frame(width: geometry.size.width*0.3)
                                .background(Rectangle().cornerRadius(10).foregroundColor(Color("Color_NowBtnBg")))
                                .minimumScaleFactor(0.01)
                        }
                        .disabled(btnDisable)
                        .opacity(btnDisable ? 0.3 : 1)
                        Button(action: {
                            btnDisable = true
                            attendanceData.timeSelector.reset()
                            btnDisable = false
                        }){
                            Text("Reset")
                                .padding(5)
                                .foregroundColor(Color.white)
                                .font(.system(size: 20, weight: .light, design: .rounded))
                                .minimumScaleFactor(0.01)
                                .frame(width: geometry.size.width*0.3)
                                .background(Rectangle().cornerRadius(10).foregroundColor(.red))
                        }
                        .disabled(btnDisable)
                        .opacity(btnDisable ? 0.3 : 1)
                    }
                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            btnDisable = true
                            // attendanceData.timeSelector.saveConfirmation = true
                            attendanceData.timeSelector.save()
                            attendanceData.timeSelector.showSelectorSheet = false
                            btnDisable = false
                        }
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
                    .disabled(btnDisable)
                    .opacity(btnDisable ? 0.3 : 1)
                    Spacer()
                }
                .padding(10)
            }
        }
    }
}


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(currentPage: .constant(Page.HomePage), attendanceData: AttendanceData())
    }
}

