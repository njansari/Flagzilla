//
//  LineChartShape.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 15/10/2021.
//

import SwiftUI

struct LineChartShape: Shape {
    let dataPoints: [DataPoint]
    let pointSize: Double
    let drawPoints: Bool

    init(dataPoints: [DataPoint], pointSize: Double, drawPoints: Bool) {
        let startPoint = [DataPoint(value: 0)]
        self.dataPoints = [startPoint, dataPoints].flatMap { $0 }

        self.pointSize = pointSize
        self.drawPoints = drawPoints
    }

    func path(in rect: CGRect) -> Path {
        let drawRect = rect.insetBy(dx: pointSize / 2, dy: 0)

        var path = Path()

        let xMultiplier = drawRect.width / Double(dataPoints.count - 1)
        let yMultiplier = drawRect.height

        for (index, dataPoint) in dataPoints.enumerated() {
            var x = Double(index) * xMultiplier
            var y = dataPoint.value * yMultiplier

            y = drawRect.height - y

//            x += drawRect.minX
            y += drawRect.minY

            if drawPoints {
                x -= pointSize / 2
                y -= pointSize / 2

                if index != 0 {
                    path.addEllipse(in: CGRect(x: x, y: y, width: pointSize, height: pointSize))
                }
            } else {
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }

        return path
    }
}
