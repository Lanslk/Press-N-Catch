//
//  ScoreSectionView.swift
//  press n catch
//
//  Created by yuteng Lan on 9/9/2024.
//

import SwiftUI

struct ScoreSectionView: View {
    let title: String
    let records: [Record]
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundStyle(.mint)
                .font(.title2)
            ScrollView {
                LazyVStack {
                    ForEach(Array(records.sorted(by: { $0.score > $1.score }).prefix(10).enumerated()), id: \.element) { index, data in
                        HStack {
                            if index < 3 {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(index == 0 ? .yellow : index == 1 ? .gray : .brown)
                            }
                            Text("\(index + 1). \(data.name.description)")
                            Spacer()
                            Text(String(data.score))
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    HighScoreView(preView: "GameView")
        .modelContainer(for: Record.self)
}
