//
//  GlyphsApp.swift
//  iOS2-Vorgabe
//
//  Created by Klaus Jung on 23.09.21.
//

import SwiftUI

@main
struct GlyphsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(glyphsViewModel: GlyphsViewModel())
        }
    }
}
