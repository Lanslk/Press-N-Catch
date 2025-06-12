//
//  GameViewModel.swift
//  press n catch
//
//  Created by yuteng Lan on 6/9/2024.
//

import SwiftUI
import SwiftData
import Combine

class GameViewModel: ObservableObject {
    var movingTimer: Timer? = nil
    @Published var targetPoint: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.2)
    @Published var moving: Bool = true
    var left = true
    
    @Published var circleSize: CGFloat = 50
    @Published var yOffset: CGFloat = 0
    @Published var currentCircleIndex: Int = 9
    @Published var score: Int = 0
    @Published var showScore: Bool = false
    @Published var shouldFlash = true
    @Published var isVisible = false
    
    @Published var name = ""
    @Published var level = ""
    
    
    var targetSizes: [CGFloat] = Array(repeating: 0, count: 10)
    var shapeList: [String] = Array(repeating: "Circle", count: 10)
    var shapes: [String] = ["Circle", "Square", "Triangle"]
    var timer: Timer? = nil
    
    init() {
        self.generateTargetSizes()
        self.generateShape()
    }
    
    // when game start or restart, reset the parameters
    func reset(name: String, level: String) {
        self.generateTargetSizes()
        self.generateShape()
        
        targetPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.2)
        moving = true
        left = true
        circleSize = 50
        yOffset = 0
        currentCircleIndex = 9
        score = 0
        showScore = false
        shouldFlash = true
        isVisible = false
        
        self.name = name
        self.level = level
        
        
        
    }
    
    // randomly generate target size
    func generateTargetSizes() {
        for index in 0..<targetSizes.count {
            targetSizes[index] = CGFloat.random(in: 50...220)
        }
    }
    
    // randomly generate shpae : circle, suqare, triangle
    func generateShape() {
        for index in 0..<shapeList.count {
            shapeList[index] = shapes[Int.random(in: 0...2)]
        }
    }
    
    
    // Function to start enlarging the circle
    func startGrowing() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.circleSize += 10
        }
    }
    
    // Function to stop enlarging the circle
    func stopGrowing() {
        timer?.invalidate()
        timer = nil
    }
    
    // Move to the next circle after 1 second delay, get and show score
    func waitAndMoveToNextCircle(totalScore: Binding<Int>, turns: Binding<Int>) {
        score = getScore()
        
        if score < 0 {
            score = 0
        }
        totalScore.wrappedValue += score
        
        showScore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showScore = false
            self.moveToNextCircle(turns: turns)
        }
    }
    
    // Move to the next circle
    func moveToNextCircle(turns: Binding<Int>) {
        if currentCircleIndex > 0 {
            currentCircleIndex -= 1
            shouldFlash = true
            turns.wrappedValue = currentCircleIndex + 1
            circleSize = 50
            targetPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.2)
            moving = true
        } else {
            // end game
            currentCircleIndex -= 1
            turns.wrappedValue = 0
            circleSize = 0
            moving = false
        }
        yOffset = 0
    }
    
    // Give description to different score
    func scoreLevel() -> String {
        switch score {
        case 90...100:
            return "Perfect!"
        case 70...89:
            return "Good!"
        case 50...69:
            return "Not Bad!"
        case 0...50:
            return "Keep Trying!"
        default:
            return "Error"
        }
    }
    
    // save record into local spacce
    func saveRecord(totalScore: Int, context: ModelContext) {
        
        do {
//            // Fetch all records
//            let fetchRequest = FetchDescriptor<Record>()
//            let records = try context.fetch(fetchRequest)
//            
//            // Delete all fetched records
//            for record in records {
//                context.delete(record)
//            }
            
            // Insert the new record
            let newRecord = Record()
            newRecord.name = name
            newRecord.score = totalScore
            newRecord.level = level
            context.insert(newRecord)
            
            // Save changes to the context
            try context.save()

        } catch {
            print("Failed to save records: \(error)")
        }
    }
    
    // move target horizontally
    func moveTarget() {
        if moving {
            if left {
                if (targetPoint.x > 0) {
                    targetPoint.x -= 10
                } else {
                    left = false
                }
                
            } else {
                if (targetPoint.x < UIScreen.main.bounds.width) {
                    targetPoint.x += 10
                } else {
                    left = true
                }
            }
        }
    }
    
    // New function to start the movement timer
        func startMovingTarget() {
            // Invalidate any existing timer before creating a new one
            movingTimer?.invalidate()
            movingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                self.moveTarget()
            }
        }
        
    // New function to stop the movement timer
    func stopMovingTarget() {
        movingTimer?.invalidate()
        movingTimer = nil
    }
    
    // calculate score
    func getScore() -> Int {
        var score: Int = 0
        
        // Get the target size for the current circle
        let baseA = Double(circleSize)
        let baseB = Double(targetSizes[currentCircleIndex])
        
        let xA = Double(UIScreen.main.bounds.width / 2)
        let xB = Double(targetPoint.x)
        
        // Calculate the left and right edges of both shapes (for horizontal overlap)
        let leftA = xA - baseA / 2
        let rightA = xA + baseA / 2
        let leftB = xB - baseB / 2
        let rightB = xB + baseB / 2
        
        // Calculate the overlapping base (horizontal overlap)
        let overlapBase = max(0, min(rightA, rightB) - max(leftA, leftB))
        
        if baseA > baseB {
            score = Int(overlapBase / baseA * 100)
        } else {
            score = Int(overlapBase / baseB * 100)
        }
        
        // Ensure the score is non-negative
        if score < 0 {
            score = 0
        }
        
        return score
    }
}
