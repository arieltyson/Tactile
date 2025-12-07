//
//  ContentView.swift
//  Journal
//
//  Created by Ariel Tyson on 4/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            
            // Header
            Text("Tactile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            
            Spacer()
            
            WaveformView()
                .frame(height: 200)
            
            Spacer()
            
            // Footer Instruction
            Text("Tap anywhere to record")
                .font(.caption)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(FeedbackService.shared)
}
