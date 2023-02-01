//
//  GlyphView.swift
//  iOS2-Vorgabe
//
//  Created by Klaus Jung on 23.09.21.
//

import SwiftUI

struct GlyphView: View {
    @EnvironmentObject var glyphsViewModel: GlyphsViewModel
    
    var glyphIndex = 0
    
    var glyph: Glyph {
        glyphsViewModel.glyph(index: glyphIndex)
    }

    var body: some View {
        if glyph.path().isEmpty {
            ZStack {
                Color.clear
                Text("Cannot draw \"\(glyph.name)\".\nPath is empty.")
                    .multilineTextAlignment(.center)
            }
        } else {
            ZStack {
                glyph.path()
                    .fill()
                    .foregroundColor(glyph.color)
                    .opacity(0.75)
                Text("\(glyphIndex + 1)")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .position(x: glyph.center.x, y: glyph.center.y)
                    .font(.title2)
                if glyph.showDescription {
                    Text(String(format: "P = %.1lf\nA = %.1lf", glyph.perimeter, glyph.area))
                        .multilineTextAlignment(.center)
                        .position(x: glyph.center.x, y: glyph.center.y - glyph.size/2 - 20)
                        .font(.footnote)
                }
            }
        }
    }
}


struct GlyphView_Previews: PreviewProvider {
    static let viewModel = GlyphsViewModel()
    static var previews: some View {
        if viewModel.glyphsCount > 0 {
            GlyphView(glyphIndex: 0).environmentObject(viewModel)
        } else {
            Text("No Glyphs in Model")
        }
    }
}
