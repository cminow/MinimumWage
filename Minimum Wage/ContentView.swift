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
    @State private var startWorkDate: Date = .now
    @State private var lastWorkDate: Date = .now
    @State private var disableWorkButton: Bool = false
    @State private var sliderValue: Double = 0.0

    var body: some View {
        VStack(spacing: 8.0) {
            TimelineView(.periodic(from: .now, by: 0.01)) { context in
                Text("Earnings: \(earnings.formatted(.currency(code: "USD"))) in \(Duration.seconds(Date.now.timeIntervalSince(startWorkDate)).formatted(.time(pattern: .hourMinuteSecond)))")
                    .monospacedDigit()
                    .padding(20.0)
                    .onChange(of: context.date) { oldDate, newDate in
                        if newDate.timeIntervalSince1970 >= lastWorkDate.timeIntervalSince1970 + timePerPenny && runningSimulation {
                            lastWorkDate = newDate
                            earnings += 0.01
                        }
                    }
            }
            
            Slider(
                value: $sliderValue,
                label: {
                    Text("Do Work")
                },
                onEditingChanged: { editing in
                    if !editing {
                        runningSimulation = false
                    } else {
                        runningSimulation = true
                    }
                }
            )
            .onChange(of: sliderValue) { _, _ in
                if earnings == 0.0 {
                    earnings += 0.01
                }
            }

            Text("Work the slider to earn.")
                .font(.caption)

            Button {
                startWorkDate = .now
                lastWorkDate = .now
                earnings = 0.00
            } label: {
                Text("Reset")
            }
            .padding(20.0)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
