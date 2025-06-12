//
//  TutorialView.swift
//  press n catch
//
//  Created by yuteng Lan on 11/9/2024.
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Tutorial")
                    .foregroundColor(.mint)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Text("Long press the pink to catch the blue!")
                VStack {
                    HStack {
                        Image("tutorial1-start")
                            .resizable()
                            .frame(width: 160, height: 300)
                        Image("tutorial2-good")
                            .resizable()
                            .frame(width: 160, height: 230)
                    }
                    HStack {
                        Image("tutorial3-bad")
                            .resizable()
                            .frame(width: 160, height: 230)
                        Image("tutorial4-hard")
                            .resizable()
                            .frame(width: 160, height: 230)
                    }
                }
                NavigationLink(
                    destination: SettingsView(),
                    label: {
                        Text("Next")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)})
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    TutorialView()
}
