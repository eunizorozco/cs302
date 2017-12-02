//
//  ResultViewController.swift
//  StatisticsCalculator
//
//  Created by Eunice Orozco on 02/12/2017.
//  Copyright © 2017 TIP. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ResultViewController: UIViewController {
    
    @IBOutlet var chartView: CombinedChartView! {
        didSet {
            chartView.chartDescription?.enabled = false
            
            chartView.dragEnabled = true
            chartView.setScaleEnabled(true)
            chartView.maxVisibleCount = 200
            chartView.pinchZoomEnabled = true
            
            let legend = chartView.legend
            legend.horizontalAlignment = .right
            legend.verticalAlignment = .top
            legend.orientation = .vertical
            legend.drawInside = false
            legend.font = .systemFont(ofSize: 10, weight: .light)
            legend.xOffset = 5
            
            let leftAxis = chartView.leftAxis
            leftAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
            leftAxis.axisMinimum = 0
            
            chartView.rightAxis.enabled = false
            
            let xAxis = chartView.xAxis
            xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        }
    }
    
    @IBOutlet weak var regressionEqLineLabel: UILabel!
    @IBOutlet weak var meanXLabel: UILabel!
    @IBOutlet weak var meanYLabel: UILabel!
    @IBOutlet weak var rLabel: UILabel!
    
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var grid = GridManager.shared
        var points = [Point]()
        for (key, xValue) in grid.dataX {
            points.append({
                let y = grid.dataY[key] ?? 0
                return Point(x: xValue, y: y)
            }())
        }
        
        let solver = LinearRegressionSolver(points: points)
        
        self.meanXLabel.text = "\(solver.meanX)"
        self.meanYLabel.text = "\(solver.meanY)"
        
        let r = String(format: "%.6f", solver.r)
        self.rLabel.text = r
        self.aLabel.text = "\(solver.A)"
        self.bLabel.text = "\(solver.B)"
    
        self.regressionEqLineLabel.text = "The graph of regression line: \(solver.lineEquation)"
        self.setChartData(solver: solver)
    }
    
    func setChartData (solver: LinearRegressionSolver) {
        var i = 0
        var grid = GridManager.shared
        var dataSets = [ScatterChartDataSet]()
        
        while i < grid.numberOfData {
            if let x = grid.dataX[i], let y = grid.dataY[i] {
                let dataEntry = [ChartDataEntry(x: x, y: y)]
                let dataSet = ScatterChartDataSet(values: dataEntry, label: "Point \(i + 1)")
                dataSet.setScatterShape(.circle)
                dataSets.append(dataSet)
            }
            i = i.advanced(by: 1)
        }
        
        let data = CombinedChartData()
        data.scatterData = ScatterChartData(dataSets: dataSets)
        
        let lineDataSet = LineChartDataSet(values: {
            return solver.linearRegressionPoints.map({ (point) -> ChartDataEntry in
                return ChartDataEntry(x: point.x, y: point.y)
            })
        }(), label: "Regression Line")
        
        
        
        lineDataSet.circleRadius = 0
        lineDataSet.lineWidth = 3
        lineDataSet.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        data.lineData = LineChartData(dataSet: lineDataSet)
        
        self.chartView.data = data
    }
}

