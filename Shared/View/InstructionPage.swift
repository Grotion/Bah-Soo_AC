//
//  InstructionPage.swift
//  Bah-Soo_AC (iOS)
//
//  Created by Shaun Ku on 2022/11/29.
//

import SwiftUI

struct InstructionPage: View {
    @Binding var currentPage:Page
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
                    VStack(alignment: .leading, spacing: 5) {
                        Group {
                            Group {
                                Text("Bah-Soo Attendance Calculator is a tool for calculating clock out time from given clock in time.")
                                CustomizeDivider()
                                Text("Feature")
                                    .bold()
                                    .underline()
                                Text("If the user has a lot of work to do, the result will also show overtime from 1 hour up to 8 hours. This will help the user to know exactly when to get off work and rest.")
                                Text("Exercise is a worthwhile habit to maintain. This tool allows the user to indicate whether he or she enters Kanda after work, then calculates attendance and overtime apart from the time spent in Kanda. The original attendance record system doesn't show the time that the user enters and leaves Kanda immediately, it is beneficial to record the time the user enters and leaves Kanda.")
                                CustomizeDivider()
                            }
                            Group {
                                Text("Timestamps")
                                    .bold()
                                    .underline()
                                Text("Clock In - The time starts to work")
                                Text("Kanda In - The time enters Kanda")
                                Text("Kanda Out - The time leaves Kanda")
                                CustomizeDivider()
                            }
                            Group {
                                Text("Usage")
                                    .bold()
                                    .underline()
                                Text("Step 1 - Select or punch clock in time")
                                Text("Step 2 - Select if you went to Kanda")
                                Text("Step 3 - Select or punch Kanda in time if you went to Kanda")
                                Text("Step 4 - Select or punch Kanda out time if you went to Kanda")
                                Text("Step 5 - Press \"Calculate\" to view attendance result")
                                CustomizeDivider()
                            }
                            Group {
                                Text("Reminder & Restriction")
                                    .bold()
                                    .underline()
                                Text(" - Time data will save locally, it’s save to close app after record time.")
                                Text(" - Bah-Soo AC does")
                                + Text(" NOT ")
                                    .bold()
                                + Text("associate with other system, so you have to punch or select time manually.")
                                Text(" - Bah-Soo AC does ")
                                + Text(" NOT ")
                                    .bold()
                                + Text("support if you go to Kanda before or during work.")
                                   Text(" - Timestamps")
                                + Text(" don't automatically ")
                                    .bold()
                                + Text("count as the most appropriate time. For example, if Bah-Soo’s clock in time is 8 A.M. to 9 A.M. but you clocked in at 07:55, the system doesn't automatically convert to 8 A.M.")
                                   Text(" - Bah-Soo AC allows users to record")
                                + Text(" one pair ")
                                    .bold()
                                + Text("of Kanda in and out time only, so if you enter and leave Kanda multiple times in a day, please add the time up manually.")
                                CustomizeDivider()
                            }
                            Group {
                                Text("As the old saying goes, time is money. By using this app to record attendance, you can take maximum advantage of each second!!")
                                    .italic()
                                CustomizeDivider()
                            }
                            Group {
                                Text("Developer")
                                    .bold()
                                    .underline()
                                Text("Grotion")
                                    .italic()
                                Text("Special Thanks")
                                    .bold()
                                    .underline()
                                Text("Luna Hung")
                                    .italic()
                            }
                        }
                        .multilineTextAlignment(.leading)
                        .font(.custom("Helvetica", size: 16))
                        .minimumScaleFactor(0.01)
                        
                    }
                    .frame(width: geometry.size.width*0.9)
                }
                .frame(height: geometry.size.height*0.88)
                Spacer()
            }
        }
        
    }
}


struct InstructionPage_Previews: PreviewProvider {
    static var previews: some View {
        InstructionPage(currentPage: .constant(Page.InstructionPage))
    }
}
