//
//  DrawPadView.swift
//  DrawPadAndEPubReader
//
//  Created by Hosung, Lee on 2017. 6. 14..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit
import RealmSwift
import CoreGraphics

class DrawPadView: UIView {
    
    public var currentNote : DrawNote?
    let EDGE_WIDTH : Double = 683.0
    var ratio : Double = 1.0
    var currentDrawPath : DrawPath?
    var currentColor : UIColor = UIColor.black
    var currentBrushSize : CGFloat = 4.0
    
    override func draw(_ rect: CGRect) {
        ratio = EDGE_WIDTH / Double(self.frame.size.width)
        if currentNote != nil {
            let paths : Results<DrawPath>? = currentNote?.paths.filter("TRUEPREDICATE")
            let context = UIGraphicsGetCurrentContext()
            paths?.forEach{ drawpath in
                drawPath(path: drawpath, context: context!)
            }
        }
    }
    
    private func drawPath(path:DrawPath, context:CGContext){
        let color = ColorFromInt(rgbValue: path.color.value!)
        context.setStrokeColor(color.cgColor)
        let bushsize = CGFloat(path.bushsize.value!)
        context.setLineWidth(bushsize)
        let pathpath = drawPathPath(points: path.points)
        context.addPath(pathpath)
        context.strokePath()
    }
    
    private func drawPathPath(points:List<DrawPoint>) -> CGPath{
        let pathpath = CGMutablePath()
        var index : Int = 0
        points.forEach { point in
            let x_pos = point.x / (ratio * 0.95)
            let y_pos = (point.y)
            let cgPoint = CGPoint(x: x_pos, y: y_pos)
            if index == 0 {
                pathpath.move(to: cgPoint)
            } else {
                pathpath.addLine(to: cgPoint)
            }
            index = index + 1
        }
        return pathpath
    }
    
    public func clearCanvas(){
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(self.bounds)
        self.setNeedsDisplay()
    }
    
    private func ColorFromInt(rgbValue: Int) -> UIColor {
        let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private func ColorToInt(color: UIColor) -> Int? {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &alpha)
        //print("\(r), \(g) \(b) \(alpha)")
        let colorvalue = String(format: "-1%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        //print("\(colorvalue.hex!)")
        return colorvalue.hex!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentDrawPath = DrawPath()
        currentDrawPath?.color.value = ColorToInt(color: currentColor)
        currentDrawPath?.bushsize.value = Int(currentBrushSize)
        
        let drawPoint : DrawPoint = DrawPoint()
        if let touch = touches.first {
            let position = touch.location(in: self)
            drawPoint.x = Double(position.x) / self.ratio
            drawPoint.y = Double(position.y)
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(currentDrawPath!)
            currentDrawPath?.points.append(drawPoint)
            currentNote?.paths.append(currentDrawPath!)
        }
        
        self.setNeedsLayout()
    }
    
    private func addPoint(point: CGPoint){
        let drawPoint : DrawPoint = DrawPoint()
        drawPoint.x = Double(point.x) / self.ratio
        drawPoint.y = Double(point.y)
        
        let realm = try! Realm()
        try! realm.write{
            if (currentDrawPath?.isInvalidated)! {
                currentDrawPath = DrawPath()
                currentDrawPath?.color.value = ColorToInt(color: currentColor)
                currentDrawPath?.bushsize.value = Int(currentBrushSize)
            }
            realm.add(drawPoint)
            currentDrawPath?.points.append(drawPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            addPoint (point: position)
        }
        self.setNeedsLayout()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            addPoint (point: position)
        }
        
        currentDrawPath = nil
        //self.setNeedsLayout()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesEnded(touches, with: event)
    }
}

extension String {
    var hex: Int? {
        return Int(self, radix: 16)
    }
}
