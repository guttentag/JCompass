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
    @State var showArrow: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear // This addition makes the image centered in the ZStack
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Spacer()
                        Toggle(isOn: $showArrow) {
                            Text("Show Arrow")
                        }
                        .fixedSize(horizontal: true, vertical: false)
                    }
                }
                    .padding()
                ShoeprintView(size: geometry.size, showArrow: showArrow)
                    .rotationEffect(.radians(viewModel.angle ?? 0))
            }
        }
    }
    
    private struct ShoeprintView: View {
        let shoeSize: CGFloat
        let arrowSize: CGSize
        let showArrow: Bool
        
        init(size: CGSize, showArrow: Bool) {
            self.shoeSize = min(size.width, size.height) * 0.6
            arrowSize = .init(width: self.shoeSize * 0.7, height: self.shoeSize * 0.3)
            self.showArrow = showArrow
        }
        
        var body: some View {
            Image("shoe_print")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(.green)
                .frame(width: shoeSize, height: shoeSize)
            if showArrow {
                Image(systemName: "chevron.up")
                    .resizable(resizingMode: .stretch)
                    .frame(width: arrowSize.width, height: arrowSize.height)
                    .offset(y: -((shoeSize / 2) + arrowSize.height))
            }
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
