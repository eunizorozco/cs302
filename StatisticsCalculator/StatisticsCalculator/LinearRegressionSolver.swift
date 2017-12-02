//
//  LinearRegressionSolver.swift
//  StatisticsCalculator
//
//  Created by Eunice Orozco on 02/12/2017.
//  Copyright © 2017 TIP. All rights reserved.
//

import Foundation

struct Point {
    var x: Double
    var y: Double
}

class LinearRegressionSolver {

    private lazy var points = [Point]()
    private var n: Double = 0
    
    private var sigmaY: Double = 0
    private var sigmaX: Double = 0
    private var sigmaXY: Double = 0
    private var sigmaXX: Double = 0
    private var sigmaYY: Double = 0
    
    init(points: [Point]) {
        self.points = points
        self.n = Double(points.count)
    
        self.sigmaY = self.points.map({$0.y}).reduce(0, +)
        self.sigmaX = self.points.map({$0.x}).reduce(0, +)
        
        self.sigmaXY = self.points.map({$0.x * $0.y}).reduce(0, +)
        self.sigmaXX = self.points.map({$0.x * $0.x}).reduce(0, +)
        self.sigmaYY = self.points.map({$0.y * $0.y}).reduce(0, +)
    }
    
    var A: Double {
        return ((sigmaY * sigmaXX) - (sigmaX * sigmaXY)) / (n * sigmaXX - (sigmaX * sigmaX))
    }
    
    var B: Double {
        return ((n * sigmaXY) - (sigmaX * sigmaY)) / (n * sigmaXX - (sigmaX * sigmaX))
    }
    
    var meanX: Double {
        return sigmaX / n
    }
    
    var meanY: Double {
        return sigmaY / n
    }
    
    var r: Double {
        let Sxx = (sigmaXX / n) - (meanX * meanX)
        let Syy = (sigmaYY / n) - (meanY * meanY)
        let Sxy = (sigmaXY / n) - (meanX * meanY)
        return Sxy / (sqrt(Sxx) * sqrt(Syy))
    }
    
    var lineEquation: String {
        return "y = \(A) + \(B)x"
    }
    
    var linearRegressionPoints: [Point] {
        var linearPoints = self.points.map({ (point) -> Point in
            let y = A + (B * point.x)
            return Point(x: point.x, y: y)
        })
        linearPoints.append(contentsOf: self.points.map({ (point) -> Point in
            let x = (point.y - A) / B
            return Point(x: x, y: point.y)
        }))
        return linearPoints
    }
}
