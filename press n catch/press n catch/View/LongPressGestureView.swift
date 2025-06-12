//
//  LongPressGestureView.swift
//  tap n catch
//
//  Created by yuteng Lan on 6/9/2024.
//

import Foundation
import SwiftUI

struct GrowingCircleView: View {
    @State private var circleSize: CGFloat = 50
    @State private var yOffset: CGFloat = 0
    @State private var isPressing = false
    @State private var timer: Timer? = nil
    @State private var isVisible = false   // for finger image
    @State private var shouldFlash = true // for finger image

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                
                // Start position
                let startPoint = CGPoint(x: screenWidth / 2, y: screenHeight * 0.8)
                // Target position
                let targetPoint = CGPoint(x: screenWidth / 2, y: screenHeight * 0.2)
                
                Circle()
                    .frame(width: 240, height: 240)
                    .foregroundColor(.red)
                    .position(x: targetPoint.x, y: targetPoint.y)
                
                Circle()
                    .position(CGPoint(x: startPoint.x, y: startPoint.y))
                    .frame(width: circleSize, height: circleSize)
                    .foregroundColor(.blue)
                    .offset(y: yOffset)
                    .onLongPressGesture(
                        minimumDuration: 2, // Continues as long as pressed
                        pressing: { pressing in
                            if pressing {
                                startGrowing()
                                shouldFlash = false
                            } else {
                                stopGrowing()
                                yOffset = -(startPoint.y - targetPoint.y)
                                
                            }
                        },
                        perform: {}
                    )
                    .animation(.easeInOut, value: circleSize)
                    .animation(.easeInOut, value: yOffset)
                
                Image(systemName: "hand.point.up")
                    .resizable()
                    .position(x: screenWidth * 0.5125, y: screenHeight * 0.9)
                    .frame(width: 40, height: 50)
                    .opacity(shouldFlash ? (isVisible ? 1.0 : 0.0) : 0)  // to show/hide the image
                    .animation(
                        shouldFlash ?
                        Animation.easeInOut(duration: 0.5)  // Smooth animation
                            .repeatForever(autoreverses: true)  // Repeat and reverse
                        : .none
                    )
                    .onAppear {
                        isVisible.toggle()
                    }
            }
        }
            
    }
    
    // Function to start enlarging the circle
    private func startGrowing() {
        isPressing = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.isPressing {
                self.circleSize += 10
            }
        }
    }
    
    // Function to stop enlarging the circle
    private func stopGrowing() {
        isPressing = false
        timer?.invalidate()
        timer = nil
    }
}

struct GrowingCircleView_Previews: PreviewProvider {
    static var previews: some View {
        GrowingCircleView()
    }
}
