//
//  AttendanceData.swift
//  Bah-Soo_AC (iOS)
//
//  Created by Shaun Ku on 2022/11/29.
//

import Foundation
import SwiftUI
 
struct Attendance: Identifiable, Codable {
    var id = UUID()
    var clockIn: Date = Date()
    var isKanda: Bool = false
    var kandaIn: Date = Date()
    var kandaOut: Date = Date()
}

enum TimeSelectorType {
    case None, ClockIn, KandaIn, KandaOut
}

struct TimeSelector {
    var showSelectorSheet: Bool = false
    var type: TimeSelectorType = TimeSelectorType.None
    var description: String = ""
    var selectDate: Date = Date()
    var range: ClosedRange<Date> = Date(timeIntervalSince1970: 0)...Date()
    var getTime: () -> Void = {}
    var reset: () -> Void = {}
    var save: () -> Void = {}
    var saveConfirmation: Bool = false
}
 
 
class AttendanceData: ObservableObject {
 
    @AppStorage("attendance") var attendanceData: Data?
    @Published var clockOut: Date = Date()
    @Published var timeInKanda: DateComponents = DateComponents()
    @Published var overtimeStart: Date = Date()
    @Published var overtime = [Date]()
    @Published var punchClockInConfrimation: Bool = false
    @Published var punchKandaInConfrimation: Bool = false
    @Published var punchKandaOutConfrimation: Bool = false
    @Published var isInputAlert: Bool = false
    @Published var alertMsg = ""
    @Published var timeSelector: TimeSelector = TimeSelector()
    let formatter = DateFormatter()
 
    init() {
        if let attendanceData = attendanceData {
            do {
                attendance = try JSONDecoder().decode(Attendance.self, from: attendanceData)
            }
            catch {
                print(error)
            }
        }
        initTimeValue()
    }
 
    @Published var attendance = Attendance() {
        didSet {
            do {
                attendanceData = try JSONEncoder().encode(attendance)
            }
            catch {
                print(error)
            }
        }
    }
    
    func initTimeValue() {
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        ignoreSecond()
        clockOut = attendance.clockIn+32400
        overtimeStart = clockOut+1800
        overtime.removeAll()
        isInputAlert = false
        alertMsg = ""
        timeSelector = TimeSelector()
    }
 
    func checkTimeValid() -> Bool{
        /*
         if (Calendar.current.dateComponents(in: TimeZone.current, from: attendance.clockIn).hour!<7 ||
            Calendar.current.dateComponents(in: TimeZone.current, from: attendance.clockIn).hour!>9) {
            alertMsg = "Clock in time must be between 7AM and 9AM"
            isInputAlert = true
            return false
        }
         */
        if (attendance.isKanda && attendance.clockIn>=attendance.kandaIn){
            alertMsg = "Kanda in time must greater than clock in time"
            isInputAlert = true
            return false
        }
        else if (attendance.isKanda && attendance.kandaIn>attendance.kandaOut){
            alertMsg = "Kanda out time must greater or equal than kanda in time"
            isInputAlert = true
            return false
        }
        else if (attendance.isKanda && attendance.clockIn+32400>attendance.kandaIn){
            alertMsg = "Cannot go into Kanda during work"
            isInputAlert = true
            return false
        }
        else if (attendance.isKanda && attendance.kandaIn.distance(to:attendance.kandaOut)>200){
            print("Time in Kanda \(attendance.kandaIn.distance(to:attendance.kandaOut))")
        }
        return true
    }
    
    func selectClockIn() {
        let minDate = Date(timeIntervalSinceReferenceDate: 0)
        timeSelector.showSelectorSheet = true
        timeSelector.type = TimeSelectorType.ClockIn
        timeSelector.description = "Your selecting clock in time"
        timeSelector.selectDate = attendance.clockIn
        timeSelector.range = minDate...Date()
        timeSelector.getTime = { self.timeSelector.selectDate = Date() }
        timeSelector.reset = { self.timeSelector.selectDate = self.attendance.clockIn }
        timeSelector.save = {
            self.attendance.clockIn = minDate>self.timeSelector.selectDate ? minDate : self.timeSelector.selectDate
            self.ignoreSecond()
        }
    }
 
    func punchClockIn() {
        attendance.clockIn = Date()
        // attendance.kandaIn = attendance.clockIn
        // attendance.kandaOut = attendance.kandaIn
        self.ignoreSecond()
    }
    
    func selectKandaIn() {
        let minDate = attendance.clockIn
        timeSelector.showSelectorSheet = true
        timeSelector.type = TimeSelectorType.KandaIn
        timeSelector.description = "Your selecting Kanda in time"
        timeSelector.selectDate = attendance.kandaIn
        timeSelector.range = attendance.clockIn...Date()
        timeSelector.getTime = { self.timeSelector.selectDate = Date() }
        timeSelector.reset = { self.timeSelector.selectDate = self.attendance.kandaIn }
        timeSelector.save = {
            self.attendance.kandaIn = minDate>self.timeSelector.selectDate ? minDate : self.timeSelector.selectDate
            self.ignoreSecond()
        }
    }
 
    func punchKandaIn() {
        attendance.kandaIn = Date()
        // attendance.kandaOut = attendance.kandaIn
        self.ignoreSecond()
    }
    
    func selectKandaOut() {
        let minDate = attendance.kandaIn
        timeSelector.showSelectorSheet = true
        timeSelector.type = TimeSelectorType.KandaOut
        timeSelector.description = "Your selecting Kanda out time"
        timeSelector.selectDate = attendance.kandaOut
        timeSelector.range = attendance.kandaIn...Date()
        timeSelector.getTime = { self.timeSelector.selectDate = Date() }
        timeSelector.reset = { self.timeSelector.selectDate = self.attendance.kandaOut }
        timeSelector.save = {
            self.attendance.kandaOut = minDate>self.timeSelector.selectDate ? minDate : self.timeSelector.selectDate
            self.ignoreSecond()
        }
        
    }
 
    func punchKandaOut() {
        attendance.kandaOut = Date()
        self.ignoreSecond()
    }
    
    func ignoreSecond() {
        var clockInComponent = Calendar.current.dateComponents(in: TimeZone.current, from: attendance.clockIn)
        clockInComponent.second = 0
        attendance.clockIn = Calendar.current.date(from: clockInComponent) ?? Date()

        var kandaInComponent = Calendar.current.dateComponents(in: TimeZone.current, from: attendance.kandaIn)
        kandaInComponent.second = 0
        attendance.kandaIn = Calendar.current.date(from: kandaInComponent) ?? Date()

        var kandaOutComponent = Calendar.current.dateComponents(in: TimeZone.current, from: attendance.kandaOut)
        kandaOutComponent.second = 0
        attendance.kandaOut = Calendar.current.date(from: kandaOutComponent) ?? Date()
    }
    
    func calculate() {
        overtime.removeAll()
        clockOut = attendance.clockIn+32400
        overtimeStart = clockOut+1800
        ignoreSecond()
        timeInKanda = Calendar.current.dateComponents([.hour, .minute], from: attendance.kandaIn, to: attendance.kandaOut)

        if attendance.isKanda {
            if attendance.kandaIn<overtimeStart {
                overtimeStart = attendance.kandaOut
                for hr in stride(from: 1, through: 8, by: 0.5) {
                    overtime.append(attendance.kandaOut+hr*3600)
                }
            }
            else {
                let before = Calendar.current.dateComponents([.hour, .minute], from: overtimeStart, to: attendance.kandaIn)
                for hr in stride(from: 1, through: 8, by: 0.5){
                    if CGFloat((before.hour!*60+before.minute!))>=(hr*60){
                        overtime.append(overtimeStart+(hr*3600))
                    }
                    else {
                        overtime.append(overtimeStart+(hr*3600)+CGFloat(timeInKanda.hour!*3600+timeInKanda.minute!*60))
                    }
                }
            }
        }
        else {
            for hr in stride(from: 1, through: 8, by: 0.5){
                overtime.append(overtimeStart+(hr*3600))
            }
        }
    }
}
