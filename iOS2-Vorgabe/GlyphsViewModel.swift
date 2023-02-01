//
//  GlyphsViewModel.swift
//  iOS2-Vorgabe
//
//  Created by Klaus Jung on 23.09.21.
//

import SwiftUI
import Combine

class GlyphsViewModel: ObservableObject {
    private var glyphs: [Glyph] = [Square(), Circle(), Diamond()] // the model: add your glyphs to the array
    
    var glyphsCount: Int {
        glyphs.count
    }
    
    func glyph(index: Int) -> Glyph {
        glyphs[index]
    }
    
    var objectWillChange = ObservableObjectPublisher()
        
    // MARK: - Intents
    
    // implement the intent methodes to update your model

    func glyph(index: Int, changedPositionX x: Double, positionY y: Double) {
        glyphs[index].center = Center(x: x, y: y)
    }
    
    func glyph(index: Int, changedType type: GlyphType) {
        let oldGlyph = glyphs[index]
        let oldCenter = glyphs[index].center
        let oldSize = glyphs[index].size
        let oldColor = glyphs[index].color
        let oldShow = glyphs[index].showDescription
        
        switch type {
        case .circle:
            glyphs[index] = Circle()
            glyphs[index].center = oldGlyph.center
            glyphs[index].size = oldSize
            glyphs[index].color = oldColor
            glyphs[index].showDescription = oldShow
        case .diamond:
            glyphs[index] = Diamond()
            glyphs[index].center = oldCenter
            glyphs[index].size = oldSize
            glyphs[index].color = oldColor
            glyphs[index].showDescription = oldShow
        case .square:
            glyphs[index] = Square()
            glyphs[index].center = oldCenter
            glyphs[index].size = oldSize
            glyphs[index].color = oldColor
            glyphs[index].showDescription = oldShow
        }
    }

    func glyph(index: Int, changedColor color: Color) {
        glyphs[index].color = color
    }
    
    func glyph(index: Int, changedSize size: Double) {
        glyphs[index].size = size
    }
    
    func glyph(index: Int, showDescription show: Bool) {
        glyphs[index].showDescription = show
    }
    
    // MARK: - Initializer
    
    init() {
        reset()
    }
    
    func reset(showDescription: Bool = false) {
        let size = [60.0, 70.0, 90.0, 80.0, 50.0, 70.0, 100.0]
        let colorIndex = [1, 3, 0, 2, 3, 0, 1]
        let centerX = [50.0, 150.0, 250.0, 200.0]
        let centerY = [250.0, 150.0, 200.0, 350.0, 450.0]
        for i in 0..<glyphs.count {
            glyph(index: i, changedType: GlyphType(rawValue: i % GlyphType.allCases.count) ?? .square)
            glyph(index: i, changedSize: size[i % size.count])
            glyph(index: i, changedColor: ColorPalette(rawValue: colorIndex[i % colorIndex.count])?.color ?? .black)
            glyph(index: i, changedPositionX: centerX[i % centerX.count], positionY: centerY[i % centerY.count])
            glyph(index: i, showDescription: showDescription)
        }
    }
}

// MARK: - Helper

enum GlyphType: Int, CaseIterable {
    case square, circle, diamond
    static let names = ["Square", "Circle", "Diamond"]
    var name: String {
        GlyphType.names[self.rawValue]
    }
    init?(name: String) {
        if let index = GlyphType.names.firstIndex(of: name), let type = GlyphType(rawValue: index) {
            self = type
        } else {
            return nil
        }
    }
}

enum ColorPalette: Int, CaseIterable {
    case red, green, blue, purple
    static let colors = [ 
        Color(red: 1,   green: 0, blue: 0), 
        Color(red: 0,   green: 1, blue: 0),
        Color(red: 0,   green: 0, blue: 1),
        Color(red: 0.5, green: 0, blue: 0.5)]
    static let names = ["Red", "Green", "Blue", "Purple"]
    var name: String {
        ColorPalette.names[self.rawValue]
    }
    init?(name: String) {
        if let index = ColorPalette.names.firstIndex(of: name), let type = ColorPalette(rawValue: index) {
            self = type
        } else {
            return nil
        }
    }
    var color: Color {
        ColorPalette.colors[self.rawValue]
    }
    init?(color: Color) {
        if let index = ColorPalette.colors.firstIndex(of: color), let type = ColorPalette(rawValue: index) {
            self = type
        } else {
            return nil
        }
    }
}    

