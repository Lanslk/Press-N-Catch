//
//  EasyGameView.swift
//  press n catch
//
//  Created by yuteng Lan on 6/9/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct EasyGameView: View {
    @Environment(\.modelContext) private var context  // Get context from the environment
    @ObservedObject var viewModel: GameViewModel
    @Binding public var totalScore: Int
    @Binding public var turns: Int
    @Binding public var isGameReady: Bool

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                
                let startPoint = CGPoint(x: screenWidth / 2, y: screenHeight * 0.8)
                let targetPoint = CGPoint(x: screenWidth / 2, y: screenHeight * 0.2)
                
                ForEach((0...9).reversed(), id: \.self) { index in
                    if index == viewModel.currentCircleIndex {
                        Circle()
                            .frame(width: viewModel.targetSizes[index], height: viewModel.targetSizes[index])
                            .foregroundColor(.blue)
                            .position(x: targetPoint.x, y: targetPoint.y)
                        
                        Text(String(viewModel.scoreLevel()))
                            .position(CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.55))
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.mint)
                            .opacity(viewModel.showScore ? 1 : 0)
                        
                        Text(String(viewModel.score))
                            .position(CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.6))
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .opacity(viewModel.showScore ? 1 : 0)
                        
                        Circle()
                            .position(CGPoint(x: startPoint.x, y: startPoint.y))
                            .frame(width: viewModel.circleSize, height: viewModel.circleSize)
                            .foregroundColor(Color(red: 1.0, green: 0.396, blue: 0.517))
                            .offset(y: viewModel.yOffset)
                            .onLongPressGesture(
                                minimumDuration: 2, // Continues as long as pressed
                                pressing: { pressing in
                                    if pressing {
                                        viewModel.startGrowing()
                                        viewModel.shouldFlash = false
                                    } else {
                                        viewModel.stopGrowing()
                                        viewModel.yOffset = -(startPoint.y - targetPoint.y)
                                        viewModel.waitAndMoveToNextCircle(totalScore: $totalScore, turns: $turns)
                                    }
                                },
                                perform: {}
                            )
                            .animation(.easeInOut, value: viewModel.circleSize)
                            .animation(.easeInOut, value: viewModel.yOffset)
                    }
                }
                
                if viewModel.currentCircleIndex == -1 && isGameReady {
                    
                    VStack {
                        Spacer()
                        Text("End")
                            .font(.title)
                        Text("Your score is " + String(totalScore))
                            .font(.title)
                        NavigationLink(
                            destination: HighScoreView(preView: "GameView"),
                            label: {
                                Text("High Score")
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)})
                        Spacer()
                    }
                    .position(CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.5))
                    .onAppear {
                        if (isGameReady) {
                            viewModel.saveRecord(totalScore: totalScore, context: context)
                        }
                    }
                }
                
                Image(systemName: "hand.point.up")
                    .resizable()
                    .position(x: screenWidth * 0.5125, y: screenHeight * 0.9)
                    .frame(width: 40, height: 50)
                    .opacity(viewModel.shouldFlash ? (viewModel.isVisible ? 1.0 : 0.0) : 0)  // to show/hide the image
                    .animation(
                        viewModel.shouldFlash ?
                        Animation.easeInOut(duration: 0.5)  // Smooth animation
                            .repeatForever(autoreverses: true)  // Repeat and reverse
                        : .none, value: viewModel.isVisible
                    )
                    .onAppear {
                        viewModel.isVisible.toggle()
                    }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    @State static var totalScore: Int = 0
    @State static var turns: Int = 10
    @State static var isGameReady = true

    static var previews: some View {
        EasyGameView(
            viewModel: GameViewModel(),
            totalScore: $totalScore,
            turns: $turns,
            isGameReady: $isGameReady
        )
    }
}
