//
//  ContentView.swift
//  DockProgress
//
//  Created by Rob Sturcke on 1/23/24.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var dockProgress: DockProgress = .shared
  
  var body: some View {
    VStack(spacing: 12) {
      Picker("Style", selection: $dockProgress.type) {
        ForEach(DockProgress.ProgressType.allCases, id: \.rawValue) { type in
          Text(type.rawValue)
            .tag(type)
        }
      }
      .pickerStyle(.segmented)
      
      Toggle("Show Dock Progress", isOn: $dockProgress.isVisible)
        .toggleStyle(.switch)
    }
    .padding(15)
    .frame(width: 200, height: 200)
    .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
      if dockProgress.isVisible {
        if dockProgress.progress >= 1.0 {
          dockProgress.isVisible = false
          dockProgress.progress = .zero
        } else {
          dockProgress.progress += 0.007
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
