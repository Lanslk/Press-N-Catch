//
//  HighScoreView.swift
//  press n catch
//
//  Created by yuteng Lan on 9/9/2024.
//

import SwiftUI
import SwiftData

struct HighScoreView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State public var preView: String
    
    @Query var allRecords: [Record]

    var easyRecords: [Record] {
        allRecords.filter { $0.level == "Easy" }
    }

    var normalRecords: [Record] {
        allRecords.filter { $0.level == "Normal" }
    }

    var hardRecords: [Record] {
        allRecords.filter { $0.level == "Hard" }
    }
    
    var body: some View {
        VStack {
            Text("Score Board")
                .foregroundColor(.mint)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Spacer()
            
            Group {
                ScoreSectionView(title: "Easy", records: easyRecords)
                ScoreSectionView(title: "Normal", records: normalRecords)
                ScoreSectionView(title: "Hard", records: hardRecords)
            }
            
            Spacer()
            if (preView == "GameView") {
                NavigationLink(
                    destination: SettingsView(),
                    label: {
                        Text("Restart")
                            .font(.title)
                    })
                .navigationBarBackButtonHidden(preView == "GameView")
            }
        }
        .padding()
    }
}

#Preview {
    HighScoreView(preView: "GameView")
        .modelContainer(for: Record.self)
}
