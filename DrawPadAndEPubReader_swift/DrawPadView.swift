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
    private let EDGE_WIDTH : Double = 683.0
    private var SCREEN_WIDTH : Double = 0
    private var ratio : Double = 1.0
    private var currentDrawPath : DrawPath?

    public var currentColor : UIColor = UIColor.black
    public var currentBrushSize : CGFloat = 4.0
    public var currentBackgroudImg : UIImage?
    
    override func draw(_ rect: CGRect) {
        SCREEN_WIDTH = Double(self.frame.size.width)
        ratio = EDGE_WIDTH / SCREEN_WIDTH
        
        if currentNote != nil {
            let paths : Results<DrawPath>? = currentNote?.paths.filter("TRUEPREDICATE")
            let context = UIGraphicsGetCurrentContext()
            paths?.forEach{ drawpath in
                drawPath(path: drawpath, context: context!)
            }
        }
    }
    
     public func drawBackground(img : UIImage?){
        if img == nil {
            return
        }
        currentBackgroudImg = img
        UIGraphicsBeginImageContext(self.frame.size)
        currentBackgroudImg?.draw(in: self.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        backgroundColor = UIColor(patternImage: image)
        self.setNeedsDisplay()
    }
   
    private func drawPath(path:DrawPath, context:CGContext){
        let color = UIColor(hexString: path.color!)
        context.setStrokeColor((color.cgColor))
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
            let x_pos = point.x / ratio
            let y_pos = point.y
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentDrawPath = DrawPath()
        currentDrawPath?.color = currentColor.toHexString()
        currentDrawPath?.bushsize.value = Int(currentBrushSize)
        
        let drawPoint : DrawPoint = DrawPoint()
        if let touch = touches.first {
            let position = touch.location(in: self)
            drawPoint.x = Double(position.x) * ratio
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
        drawPoint.x = Double(point.x) * ratio
        drawPoint.y = Double(point.y)
        
        let realm = try! Realm()
        try! realm.write{
            if (currentDrawPath?.isInvalidated)! {
                currentDrawPath = DrawPath()
                currentDrawPath?.color = currentColor.toHexString()
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
        
        let realm = try! Realm()
        try! realm.write{
            currentDrawPath?.completed = true
            realm.add(currentDrawPath!)
        }
        currentDrawPath = nil
        //self.setNeedsLayout()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesEnded(touches, with: event)
    }
    
    public func saveDrawPaths(title : String?){
        let realm = try! Realm()
        try! realm.write {
            if title != nil {
                currentNote?.title = title
                currentNote?.saved = true
            }
            
            let paths : Results<DrawPath>? = currentNote?.paths.filter("TRUEPREDICATE")
            paths?.forEach{ drawpath in
                if !drawpath.saved {
                    drawpath.saved = true
                }
            }
        }
    }
}

extension String {
    var hex: Int? {
        return Int(self, radix: 16)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    public func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}

