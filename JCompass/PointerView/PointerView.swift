//
//  PointerView.swift
//  JCompass
//
//  Created by Eran Gutentag on 24/10/2022.
//  Copyright © 2022 Gutte. All rights reserved.
//

import SwiftUI
import os.log

struct PointerView: View {
    @ObservedObject var viewModel: PointerViewModel = PointerViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            Path() { path in path.addLines(pointerPath(size: geometry.size)) }
                .stroke(Color.green, lineWidth: 3)
                .rotationEffect(.radians(viewModel.angle ?? 0))
        }
    }
}

private extension PointerView {
    func pointerPath(size: CGSize) -> [CGPoint] {
        let length = min(size.width, size.height) / 2
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        return [
            center,
            CGPoint(x: center.x, y: center.y - length)
        ]
    }
}
