//
//  Glyph.swift
//  iOS2-Vorgabe
//
//  Created by Klaus Jung on 23.09.21.
//

import SwiftUI

protocol Glyph {
    var size: Double { get set }
    var color: Color { get set }
    var center: Point { get set }
    var showDescription: Bool { get set }
    
    func path() -> Path
    
    var area: Double { get }
    var perimeter: Double { get }
}

protocol Point {
    var x: Double { get set }
    var y: Double { get set }
}

struct Center: Point {
    var x = 0.0
    var y = 0.0
    init() {}
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

class BaseGlyph: Glyph {
    var center: Point
    
    var size = 0.0
    var color = Color.blue
    var showDescription = false
    
    init() {
        center = Center(x: 0.0, y: 0.0)
    }
    func path() -> Path {
        return DrawHelper.pathForCircle(centerX: 0.0, centerY: 0.0, size: 0.0)
    }
    
    var area: Double {
        return 0.0
    }
    
    var perimeter: Double {
        return 0.0
    }
}

class Square: BaseGlyph {
    override var area: Double {
        return size * size
    }
    
    override var perimeter: Double {
        return size * 4
    }
    
    override func path() -> Path {
        return DrawHelper.pathForSquare(centerX: self.center.x, centerY: self.center.y, size: self.size)
    }
}

class Circle: BaseGlyph {
    override var area: Double {
        return (size / 2) * (size / 2) * Double.pi
    }
    
    override var perimeter: Double {
        return 2 * (size / 2) * Double.pi
    }
    
    override func path() -> Path {
        return DrawHelper.pathForCircle(centerX: center.x, centerY: center.y, size: size)
    }
}

class Diamond: BaseGlyph {
    override var area: Double {
        return pow(size, 2) / 2
    }
    
    override var perimeter: Double {
        return (pow((size / 2), 2) * 2).squareRoot() * 4
    }
    
    override func path() -> Path {
        return DrawHelper.pathForDiamond(centerX: center.x, centerY: center.y, size: size)
    }
}
