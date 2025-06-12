//
//  ContentView.swift
//  press n catch
//
//  Created by yuteng Lan on 5/9/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Press n Catch")
                    .foregroundColor(.mint)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                LottieView(name: Constants.Animation, loopMode: .loop, animationSpeed: 1)
                Spacer()
                NavigationLink(
                    destination: TutorialView(),
                    label: {
                        Text("New Game")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)})
                .padding()
    
                NavigationLink(
                    destination: HighScoreView(preView: "ContentView"),
                    label: {
                        Text("High Score")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)})
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Record.self)
}
