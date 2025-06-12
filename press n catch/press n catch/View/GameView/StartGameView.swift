//
//  StartGameView.swift
//  press n catch
//
//  Created by yuteng Lan on 5/9/2024.
//

import SwiftUI

struct StartGameView: View {
    
    @State private var turns: Int = 10
    @State private var totalScore: Int = 0
    @StateObject private var viewModel: GameViewModel = GameViewModel()
    
    @Binding public var level: String
    @Binding public var name: String
    
    @State private var isGameReady = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("Turns")
                        .foregroundColor(.mint)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text(String(turns))
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                VStack {
                    Text("Score")
                        .foregroundColor(.mint)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text(String(totalScore))
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                VStack {
                    Text("Level")
                        .foregroundColor(.mint)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text(level)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                Spacer()
            }
                
            if (level == "Easy") {
                EasyGameView(viewModel: viewModel, totalScore: $totalScore, turns: $turns, isGameReady: $isGameReady)
            } else if (level == "Normal") {
                NormalGameView(viewModel: viewModel, totalScore: $totalScore, turns: $turns, isGameReady: $isGameReady)
            } else if (level == "Hard") {
                HardGameView(viewModel: viewModel, totalScore: $totalScore, turns: $turns, isGameReady: $isGameReady)
            }
         }
        .onAppear() {
            // Initialize game
            isGameReady = false
            turns = 10
            totalScore = 0
            viewModel.reset(name: name, level: level)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isGameReady = true
            }
        }
    }
}

#Preview {
    StartGameView(level: .constant("Hard"), name: .constant("Lance"))
            .modelContainer(for: Record.self)
}
