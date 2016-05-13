//
//  Draw.swift
//  radialGraph
//
//  Created by Connor Holowachuk on 2016-05-12.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import UIKit

class Draw: UIView {

    override func drawRect(rect: CGRect) {
        
        let pi = 3.14159265358979323846264338327950288
        
        
        let businessNames = ["Green Bean", "Soup r' Salad", "Sam's Bar", "Tequila Bob's", "Starbucks", "Jimmy G's", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"]
        let businessPayments: [Double] = [4.27, 5.22, 5.20, 4.27, 6.18, 5.78, 3.45, 3.89, 5.02, 6.06, 4.03, 3.09, 3.23, 5.98]
        var businessPaymentsScaled: [Double] = [] //max is 0.8607309
        let numberOfBusinesses: Int = businessNames.count
        
        let angleBetweenLines = 2 * pi / Double(numberOfBusinesses)
        
        let outerRadius = self.frame.height / 6.0
        let middleRadius = outerRadius * 2.0 / 3.0
        let innerRadius = middleRadius * 0.5
        let centerPoint = CGPointMake(self.frame.width * 0.5, self.frame.height - (outerRadius * 1.333333))
        
        var outerPointsArray: [CGPoint] = []
        
        let outerCircleRect = CGRect(x: centerPoint.x - outerRadius, y: centerPoint.y - outerRadius, width: 2.0 * outerRadius, height: 2.0 * outerRadius)
        let outerCircle = UIBezierPath(ovalInRect: outerCircleRect)
        
        let middleCircleRect = CGRect(x: centerPoint.x - middleRadius, y: centerPoint.y - middleRadius, width: 2.0 * middleRadius, height: 2.0 * middleRadius)
        let middleCircle = UIBezierPath(ovalInRect: middleCircleRect)
        
        let innerCircleRect = CGRect(x: centerPoint.x - innerRadius, y: centerPoint.y - innerRadius, width: 2.0 * innerRadius, height: 2.0 * innerRadius)
        let innerCircle = UIBezierPath(ovalInRect: innerCircleRect)
        
        UIColor.lightGrayColor().colorWithAlphaComponent(0.4).setStroke()
        outerCircle.stroke()
        middleCircle.stroke()
        innerCircle.stroke()
        
        for index in 0...numberOfBusinesses - 1{
            let angleForIndex = Double(index) * angleBetweenLines
            let pointX = centerPoint.x + (outerRadius * CGFloat(sin(angleForIndex)))
            let pointY = centerPoint.y - (outerRadius * CGFloat(cos(angleForIndex)))
            let point = CGPointMake(pointX, pointY)
            
            outerPointsArray.append(point)
            
            let lineContext = UIGraphicsGetCurrentContext()
            CGContextSetLineWidth(lineContext, 0.8)
            CGContextSetStrokeColorWithColor(lineContext, UIColor.lightGrayColor().colorWithAlphaComponent(0.6).CGColor)
            CGContextMoveToPoint(lineContext, centerPoint.x, centerPoint.y)
            CGContextAddLineToPoint(lineContext, point.x, point.y)
            CGContextStrokePath(lineContext)
            
            let textField = UITextField()
            textField.text = businessNames[index]
            textField.font = UIFont(name: "HelveticaNeue-Thin", size: 8.0)
            
            let textFieldWidth = self.frame.width / 6.0
            let textFieldHeight: CGFloat = 20.0
            let textFieldExtraSpace = self.frame.width / (2 * 27.22718362)
            
            let criticalAngle1 = (pi / 2.0) - atan(Double(textFieldHeight / textFieldWidth))
            let criticalAngle2 = pi - criticalAngle1
            let criticalAngle1AfterPi = criticalAngle1 + pi
            let criticalAngle2AfterPi = criticalAngle2 + pi
            
            var distanceFromCenterToEdge: CGFloat = 0.0
            let maxDistanceFromCenterToEdge: CGFloat = sqrt((textFieldWidth * textFieldWidth / 4.0) + (textFieldHeight * textFieldHeight / 4.0))
            
            var totalDistance: CGFloat = 0.0 // outerRadius + distanceFromCenterToEdge + textFieldExtraSpace
            var textFieldCenterX: CGFloat = 0.0 //centerPoint.x + totalDistance * CGFloat(sin(angleForIndex))
            var textFieldCenterY: CGFloat = 0.0 //centerPoint.y - totalDistance * CGFloat(cos(angleForIndex))
            
            if angleForIndex >= 0 && angleForIndex < criticalAngle1 {
                distanceFromCenterToEdge = ((textFieldHeight / 2.0 - maxDistanceFromCenterToEdge) * CGFloat(cos(angleForIndex * (pi / 2.0) / criticalAngle1))) + maxDistanceFromCenterToEdge
                
                totalDistance = outerRadius + distanceFromCenterToEdge + textFieldExtraSpace
                textFieldCenterX = centerPoint.x + totalDistance * CGFloat(sin(angleForIndex))
                textFieldCenterY = centerPoint.y - totalDistance * CGFloat(cos(angleForIndex))
                
            } else if angleForIndex >= criticalAngle1 && angleForIndex <= criticalAngle2 {
                distanceFromCenterToEdge = ((textFieldWidth / 2.0 - maxDistanceFromCenterToEdge) * CGFloat(sin((angleForIndex * pi / (criticalAngle2 - criticalAngle1)) - criticalAngle1))) + maxDistanceFromCenterToEdge
                
                totalDistance = outerRadius + distanceFromCenterToEdge + textFieldExtraSpace
                textFieldCenterX = centerPoint.x + totalDistance * CGFloat(sin(angleForIndex))
                textFieldCenterY = centerPoint.y - totalDistance * CGFloat(cos(angleForIndex))
                
            } else if angleForIndex > criticalAngle2 && angleForIndex < pi {
                distanceFromCenterToEdge = ((textFieldHeight / 2.0 - maxDistanceFromCenterToEdge) * CGFloat(sin((angleForIndex * (pi / 2.0) / (pi - criticalAngle2)) - criticalAngle2))) + maxDistanceFromCenterToEdge
                
                totalDistance = outerRadius + distanceFromCenterToEdge + textFieldExtraSpace
                textFieldCenterX = centerPoint.x + totalDistance * CGFloat(sin(angleForIndex))
                textFieldCenterY = centerPoint.y - totalDistance * CGFloat(cos(angleForIndex))
                
            } else if angleForIndex >= pi && angleForIndex < criticalAngle1AfterPi {
                let revisedAngle = angleForIndex - pi
                
                distanceFromCenterToEdge = ((textFieldHeight / 2.0 - maxDistanceFromCenterToEdge) * CGFloat(cos(revisedAngle * (pi / 2.0) / criticalAngle1))) + maxDistanceFromCenterToEdge
                
                totalDistance = outerRadius + distanceFromCenterToEdge + textFieldExtraSpace
                textFieldCenterX = centerPoint.x - totalDistance * CGFloat(sin(revisedAngle))
                textFieldCenterY = centerPoint.y + totalDistance * CGFloat(cos(revisedAngle))
                
            } else if angleForIndex >= criticalAngle1AfterPi && angleForIndex <= criticalAngle2AfterPi {
                let revisedAngle = angleForIndex - pi
                
                distanceFromCenterToEdge = ((textFieldWidth / 2.0 - maxDistanceFromCenterToEdge) * CGFloat(sin((revisedAngle * pi / (criticalAngle2 - criticalAngle1)) - criticalAngle1))) + maxDistanceFromCenterToEdge
                
                totalDistance = outerRadius + distanceFromCenterToEdge + textFieldExtraSpace
                textFieldCenterX = centerPoint.x - totalDistance * CGFloat(sin(revisedAngle))
                textFieldCenterY = centerPoint.y + totalDistance * CGFloat(cos(revisedAngle))
                
            } else if angleForIndex > criticalAngle2AfterPi && criticalAngle2AfterPi < 2 * pi {
                let revisedAngle = angleForIndex - pi
                
                distanceFromCenterToEdge = ((textFieldHeight / 2.0 - maxDistanceFromCenterToEdge) * CGFloat(sin((revisedAngle * (pi / 2.0) / (pi - criticalAngle2)) - criticalAngle2))) + maxDistanceFromCenterToEdge
                
                totalDistance = outerRadius + distanceFromCenterToEdge + textFieldExtraSpace
                textFieldCenterX = centerPoint.x - totalDistance * CGFloat(sin(revisedAngle))
                textFieldCenterY = centerPoint.y + totalDistance * CGFloat(cos(revisedAngle))
            }
            
            
            textField.frame = CGRect(x: textFieldCenterX - (textFieldWidth / 2.0), y: textFieldCenterY - (textFieldHeight / 2.0), width: textFieldWidth, height: textFieldHeight)
            textField.textAlignment = NSTextAlignment.Center
            
            self.addSubview(textField)
        }
        
        
        let maxPayment = businessPayments.maxElement()
        for index in 0...businessPayments.count - 1 {
            businessPaymentsScaled.append(businessPayments[index] / maxPayment! * 0.8607309)
        }
        
        
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = 2.0
        UIColor.cyanColor().colorWithAlphaComponent(0.9).setStroke()
        
        let basePointCPD: CGFloat = 100.0 / CGFloat(numberOfBusinesses)
        let baseIntermediateCPD = basePointCPD * 1.618033 * 1.618033
        
        for index in 0...numberOfBusinesses - 1 {
            var nextIndex = index + 1
            if nextIndex >= numberOfBusinesses {
                nextIndex = 0
            }
            let angleForIndex = Double(index) * angleBetweenLines
            let nextAngleForIndex = Double(nextIndex) * angleBetweenLines
            
            let paymentPointX = centerPoint.x - CGFloat(businessPaymentsScaled[index]) * (centerPoint.x - outerPointsArray[index].x)
            let paymentPointY = centerPoint.y - CGFloat(businessPaymentsScaled[index]) * (centerPoint.y - outerPointsArray[index].y)
            let paymentPoint = CGPointMake(paymentPointX, paymentPointY)
            
            bezierPath.moveToPoint(paymentPoint)
            
            var intermediatePointDFC: CGFloat!
            if businessPaymentsScaled[index] >= businessPaymentsScaled[nextIndex] {
                intermediatePointDFC = CGFloat(businessPaymentsScaled[nextIndex]) / 1.618033 * outerRadius
            } else {
                intermediatePointDFC = CGFloat(businessPaymentsScaled[index]) / 1.618033 * outerRadius
            }
            
            let intermediatePointX = centerPoint.x + (intermediatePointDFC * CGFloat(sin(angleBetweenLines / 2.0 + angleForIndex)))
            let intermediatePointY = centerPoint.y - (intermediatePointDFC * CGFloat(cos(angleBetweenLines / 2.0 + angleForIndex)))
            let intermediatePoint = CGPointMake(intermediatePointX, intermediatePointY)
            
            print("\(centerPoint.x - intermediatePoint.x), \(centerPoint.y - intermediatePoint.y)")
            
            let controlLengthOne: CGFloat = calculateMagnitude(centerPoint.x - paymentPointX, y: centerPoint.y - paymentPointY) / outerRadius * basePointCPD
            let paymentPointCPX: CGFloat = paymentPointX + controlLengthOne * CGFloat(cos(angleForIndex))
            let paymentPointCPY: CGFloat = paymentPointY + controlLengthOne * CGFloat(sin(angleForIndex))
            let paymentPointCP = CGPointMake(paymentPointCPX, paymentPointCPY)
            
            let controlLengthTwo: CGFloat = calculateMagnitude(centerPoint.x - intermediatePointX, y: centerPoint.y - intermediatePointY) / outerRadius * baseIntermediateCPD
            let intermediatePointCPX: CGFloat = intermediatePointX - (controlLengthTwo * CGFloat(cos(angleBetweenLines / 2.0 + angleForIndex)))
            let intermediatePointCPY: CGFloat = intermediatePointY - (controlLengthTwo * CGFloat(sin(angleBetweenLines / 2.0 + angleForIndex)))
            let intermediatePointCP = CGPointMake(intermediatePointCPX, intermediatePointCPY)
            
            bezierPath.addCurveToPoint(intermediatePoint, controlPoint1: paymentPointCP, controlPoint2: intermediatePointCP)
            
            let nextPointX = centerPoint.x - CGFloat(businessPaymentsScaled[nextIndex]) * (centerPoint.x - outerPointsArray[nextIndex].x)
            let nextPointY = centerPoint.y - CGFloat(businessPaymentsScaled[nextIndex]) * (centerPoint.y - outerPointsArray[nextIndex].y)
            let nextPoint = CGPointMake(nextPointX, nextPointY)
            
            let controlLengthThree: CGFloat = calculateMagnitude(centerPoint.x - nextPointX, y: centerPoint.y - nextPointY) / outerRadius * basePointCPD
            
            let nextPointCPX = nextPointX - (controlLengthThree * CGFloat(cos(nextAngleForIndex)))
            let nextPointCPY = nextPointY - (controlLengthThree * CGFloat(sin(nextAngleForIndex)))
            let nextPointCP = CGPointMake(nextPointCPX, nextPointCPY)
            
            let intermediatePointCPX2 = intermediatePointX + (controlLengthTwo * CGFloat(cos(angleBetweenLines / 2.0 + angleForIndex)))
            let intermediatePointCPY2 = intermediatePointY + (controlLengthTwo * CGFloat(sin(angleBetweenLines / 2.0 + angleForIndex)))
            let intermediatePointCP2 = CGPointMake(intermediatePointCPX2, intermediatePointCPY2)
            
            bezierPath.addCurveToPoint(nextPoint, controlPoint1: intermediatePointCP2, controlPoint2: nextPointCP)
            
        }
        
        bezierPath.stroke()
        
        /*
        //context is object used for drawing
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.02)
        CGContextSetStrokeColorWithColor(context, UIColor.cyanColor().CGColor)
        
        //create path
        CGContextMoveToPoint(context, 50, 50)
        CGContextAddLineToPoint(context, 250, 320)
        
        //draw path
        CGContextStrokePath(context)
        */
    }
    
    func calculateMagnitude(x: CGFloat, y: CGFloat) -> CGFloat {
        let mag = sqrt(x * x + y * y)
        return mag
    }

}
