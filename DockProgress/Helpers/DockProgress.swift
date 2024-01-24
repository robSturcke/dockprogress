//
//  DockProgress.swift
//  DockProgress
//
//  Created by Rob Sturcke on 1/23/24.
//

import Foundation
import SwiftUI

class DockProgress: ObservableObject {
  static let shared = DockProgress()
  
  @Published var progress: CGFloat = .zero {
    didSet {
      updateDock()
    }
  }
  @Published var tint: Color = .red {
    didSet {
      updateDock()
    }
  }
  @Published var type: ProgressType = .full {
    didSet {
      updateDock()
    }
  }
  @Published var isVisible: Bool = false {
    didSet {
      updateDock()
    }
  }
  
  private func updateDock() {
    if !isVisible {
      NSApplication.shared.dockTile.contentView = nil
      NSApplication.shared.dockTile.display()
    } else {
      if let logo = NSApplication.shared.applicationIconImage {
        let view = NSHostingView(rootView: CustomDockView(logo: logo, tint: tint, progress: progress, type: type))
        view.layer?.backgroundColor = .clear
        view.frame.size = logo.size
        
        NSApplication.shared.dockTile.contentView = view
        
        NSApplication.shared.dockTile.display()
      }
    }
      
  }
  
  enum ProgressType: String, CaseIterable {
    case full = "Full Rounded Rectangle"
    case bottom = "Bottom Capsule"
  }
}

fileprivate struct CustomDockView: View {
  var logo: NSImage
  var tint: Color
  var progress: CGFloat
  var type: DockProgress.ProgressType
  var body: some View {
    ZStack {
      Image(nsImage: logo)
        .scaledToFit()
      
      GeometryReader {
        let size = $0.size
        
        let cappedProgress = max(min(progress, 1), 0)
        
        if type == .full {
          RoundedRectangle(cornerRadius: size.width / 5)
            .trim(from: 0, to: cappedProgress)
            .stroke(tint, lineWidth: 6)
            .rotationEffect(.init(degrees: -90 ))
        } else {
          ZStack(alignment: .leading) {
            Capsule()
              .fill(Color.primary.opacity(0.5))
            
            Capsule()
              .fill(tint)
              .frame(width: cappedProgress * size.width)
          }
          .frame(height: 8)
          .frame(maxHeight: .infinity, alignment: .bottom)
        }
      }
      .padding(15)
    }
  }
}
