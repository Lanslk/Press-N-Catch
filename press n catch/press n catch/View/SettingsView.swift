//
//  SettingsView.swift
//  press n catch
//
//  Created by yuteng Lan on 5/9/2024.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var level = "Easy"
    let levels = ["Easy", "Normal", "Hard"]
    
    @State private var showAlert = false
    @State private var navigateToGameView = false
    
    @State private var name = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
                    .foregroundColor(.mint)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                Spacer()
                HStack {
                    Text("Player Name")
                        .font(.title2)
                    TextField("Your Name", text: $name)
                        .font(.title2)
                        .padding()
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                HStack {
                    Spacer()
                    Text("Level")
                        .font(.title2)
                    Spacer()
                    Picker("Select a level", selection: $level) {
                        ForEach(levels, id: \.self) { level in
                            Text(level)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.title2)
                    Spacer()
                }
                .padding()
                Spacer()
                Button(action: {
                    if name.isEmpty {
                        showAlert = true  // Show alert if name is empty
                    } else {
                        // Navigate to the game if name is entered
                        navigateToGameView = true
                    }
                }, label: {
                    Text("Start Game")
                        .font(.title)
                })
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Name Required"),
                        message: Text("Please enter your name to start the game."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToGameView) {
                StartGameView(level: $level, name: $name)
            }
        }
    }
}

#Preview {
    SettingsView()
}
