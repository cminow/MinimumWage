//
//  ContentView.swift
//  Minimum Wage
//
//  Created by Charlie Minow on 6/25/26.
//

import SwiftUI

struct ContentView: View {
    let timePerPenny: Double = 3600.0 / 725.0
    @State private var runningSimulation: Bool = false
    @State private var earnings: Double = 0.00
    @State private var lastWorkDate: Date = Date()
    @State private var disableWorkButton: Bool = false

    var body: some View {
        VStack(spacing: 8.0) {
            TimelineView(.periodic(from: .now, by: 0.1)) { context in
                Text("Earnings: \(earnings.formatted(.currency(code: "USD")))")
                    .monospacedDigit()
                    .onChange(of: context.date) { oldDate, newDate in
                        if newDate.timeIntervalSince1970 >= lastWorkDate.timeIntervalSince1970 + timePerPenny {
                            disableWorkButton = false
                            lastWorkDate = newDate
                        }
                    }
            }
            
            Button {
                disableWorkButton = true
                lastWorkDate = .now
                earnings += 0.01
            } label: {
                Text("Do Work")
                    .foregroundStyle(disableWorkButton ? .gray : .black)
            }
            .padding([.leading, .trailing], 8.0)
            .padding([.top, .bottom], 4.0)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(disableWorkButton ? Color("disabledGray") : .green)
            }
            .disabled(disableWorkButton)

            Button {
                disableWorkButton = true
                lastWorkDate = .now
                earnings = 0.00
            } label: {
                Text("Reset")
            }
            .padding(10.0)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
