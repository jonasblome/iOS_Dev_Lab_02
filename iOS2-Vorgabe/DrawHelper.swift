//
//  DrawHelper.swift
//  iOS2-Vorgabe
//
//  Created by Klaus Jung on 24.09.21.
//

import SwiftUI

struct DrawHelper {
    
    static func pathForSquare(centerX: Double, centerY: Double, size: Double) -> Path {
        SwiftUI.Rectangle().path(in: CGRect(x: CGFloat(centerX - size/2), y: CGFloat(centerY - size/2), width: CGFloat(size), height: CGFloat(size)))
    }
    
    static func pathForCircle(centerX: Double, centerY: Double, size: Double) -> Path {
        SwiftUI.Circle().path(in: CGRect(x: CGFloat(centerX - size/2), y: CGFloat(centerY - size/2), width: CGFloat(size), height: CGFloat(size)))
    }
    
    static func pathForDiamond(centerX: Double, centerY: Double, size: Double) -> Path {
        Path { path in
            path.move(to: CGPoint(x: size/2 + centerX, y: centerY))
            path.addLine(to: CGPoint(x: centerX, y: size/2 + centerY))
            path.addLine(to: CGPoint(x: -size/2 + centerX, y: centerY))
            path.addLine(to: CGPoint(x: centerX, y: -size/2 + centerY))
            path.closeSubpath()
        }        
    }
    
}
