//
//  ContentView.swift
//  iOS2-Vorgabe
//
//  Created by Klaus Jung on 23.09.21.
//

import SwiftUI

struct ContentView: View {
    var glyphsViewModel: GlyphsViewModel
    
    @State var currentIndex = 0
    @State var currentSize = 0.0
    @State var currentGlyphName = ""
    @State var currentColorName = ""
    @State var showAllDescriptions = false
    
    var body: some View {
        VStack {
            glyphArea
            pickers
            sizeController
        }
        .onAppear {
            currentIndex = glyphsViewModel.glyphsCount == 0 ? -1 : 0
            update()
        }
        .environmentObject(glyphsViewModel)
    }
    
    private var glyphArea: some View {
        ZStack {
            if glyphsViewModel.glyphsCount > 0 {
                ForEach(0..<glyphsViewModel.glyphsCount, id: \.self) { index in
                    GlyphView(glyphIndex: index)
                        .gesture(tapGesture(for: index))
                        .simultaneousGesture(dragGesture(for: index))
                }.clipped()
            } else {
                Color.clear
            }
        }
        .background(Color(white: 0.75, opacity: 1))
        .ignoresSafeArea()
        .gesture(toggleDescriptionGesture())
        .simultaneousGesture(resetGesture())
        .overlay(infoButton, alignment: Alignment(horizontal: .trailing, vertical: .bottom))
        
    }
    
    private var infoButton: some View {
        Button { 
            showAllDescriptions = !showAllDescriptions
            setDescriptions(hidden: !showAllDescriptions)
        } label: { 
            Image(systemName: "info.circle")
                .font(.title2)
        }
        .padding()
        .disabled(glyphsViewModel.glyphsCount == 0)
    }
    
    @ViewBuilder private var pickers: some View {
        if glyphsViewModel.glyphsCount == 0 {
            Text("No Glyphs in Model")
        } else {
            Picker("Glyph", selection: $currentIndex) {
                ForEach(0..<glyphsViewModel.glyphsCount, id: \.self) { index in
                    Text("Glyph \(index + 1)").tag(index)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: currentIndex) { index in
                update()
            }
        }
        
        Picker("Type", selection: $currentGlyphName) {
            ForEach(GlyphType.allCases, id: \.self) { type in
                Text(type.name).tag(type.name)
            }
        }
        .pickerStyle(.segmented)
        .disabled(glyphsViewModel.glyphsCount == 0)
        .onChange(of: currentGlyphName) { name in
            if let type = GlyphType(name: name), currentIndex >= 0 {
                glyphsViewModel.glyph(index: currentIndex, changedType: type)
                glyphsViewModel.objectWillChange.send()
            }
        }
        
        Picker("Color", selection: $currentColorName) {
            ForEach(ColorPalette.allCases, id: \.self) { color in
                Text(color.name).tag(color.name)
            }
        }
        .pickerStyle(.segmented)
        .disabled(glyphsViewModel.glyphsCount == 0)
        .onChange(of: currentColorName) { name in
            if let color = ColorPalette(name: name)?.color, currentIndex >= 0 {
                glyphsViewModel.glyph(index: currentIndex, changedColor: color)
                glyphsViewModel.objectWillChange.send()
            }
        }
        
    }
    
    private var sizeController: some View {
        HStack {
            Text("Size:")
            Slider(value: $currentSize, 
                   in: 30...200,
                   onEditingChanged: { editing in
                if currentIndex >= 0 {
                    glyphsViewModel.glyph(index: currentIndex, showDescription: editing || showAllDescriptions)
                    glyphsViewModel.objectWillChange.send()
                }
            })
                .disabled(glyphsViewModel.glyphsCount == 0)
                .onChange(of: currentSize) { value in
                    if currentIndex >= 0 {
                        glyphsViewModel.glyph(index: currentIndex, changedSize: value)
                        glyphsViewModel.objectWillChange.send()
                    }
            }
            Button { 
                showAllDescriptions = false
                glyphsViewModel.reset(showDescription: showAllDescriptions)
                update()
            } label: { 
                Text("Reset")
            }
            .disabled(glyphsViewModel.glyphsCount == 0)
        }
        .padding(.horizontal)
    }
    
    private func dragGesture(for index: Int) -> some Gesture {
        var startCenter: Point?
        return DragGesture(minimumDistance: 3)
            .onChanged { value in
                currentIndex = index
                if let center = startCenter {
                    glyphsViewModel.glyph(index: index, changedPositionX: center.x + value.translation.width, positionY: center.y + value.translation.height)                    
                } else  {
                    startCenter = glyphsViewModel.glyph(index: index).center
                }
                glyphsViewModel.glyph(index: index, showDescription: true)
                glyphsViewModel.objectWillChange.send()
            }
            .onEnded { _ in
                startCenter = nil
                glyphsViewModel.glyph(index: index, showDescription: showAllDescriptions)
                glyphsViewModel.objectWillChange.send()
            }
    }
    
    private func tapGesture(for index: Int) -> some Gesture {
        TapGesture()
            .onEnded {
                currentIndex = index
            }
    }

    private func toggleDescriptionGesture() -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                showAllDescriptions = !showAllDescriptions
                setDescriptions(hidden: !showAllDescriptions)
            }
    }
    
    private func resetGesture() -> some Gesture {
        LongPressGesture(minimumDuration: 2.0)
            .onEnded { _ in
                showAllDescriptions = true
                glyphsViewModel.reset(showDescription: showAllDescriptions)
                update()
            }
    }
    
    private func setDescriptions(hidden: Bool) {
        for i in 0..<glyphsViewModel.glyphsCount {
            glyphsViewModel.glyph(index: i, showDescription: !hidden)
        }
        glyphsViewModel.objectWillChange.send()
    }

    private func update() {
        guard currentIndex >= 0 else { return }
        currentSize = glyphsViewModel.glyph(index: currentIndex).size
        currentGlyphName = glyphsViewModel.glyph(index: currentIndex).name
        currentColorName = ColorPalette(color: glyphsViewModel.glyph(index: currentIndex).color)?.name ?? ""
        glyphsViewModel.objectWillChange.send()
    }    
}

extension Glyph {
    var name: String {
        String(describing: self).components(separatedBy: ".").last ?? "unknown"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(glyphsViewModel: GlyphsViewModel())
    }
}
