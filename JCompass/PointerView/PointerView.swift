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
    @ObservedObject var viewModel: PointerViewModel
    @State var showArrow: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear // This addition makes the image centered in the ZStack
                ArrowToggleView(showArrow: $showArrow)
                    .padding()
                ShoeprintView(size: geometry.size, showArrow: showArrow)
                    .rotationEffect(.radians(viewModel.angle ?? 0))
                    .environment(\.layoutDirection, .leftToRight) // RTL mirrored angle calculation
            }
        }
    }
    
    private struct ArrowToggleView: View {
        let showArrow: Binding<Bool>
        
        var body: some View {
            VStack(alignment: .center) {
                Spacer()
                HStack {
                    Spacer()
                    Toggle(isOn: showArrow) {
                        Text("pointer_show_arrow")
                            .foregroundColor(.goldPrimaryLight)
                    }
                    .tint(Color.goldPrimaryDark)
                    .fixedSize(horizontal: true, vertical: false)
                }
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
                .foregroundColor(.pointerPrimary)
                .frame(width: shoeSize, height: shoeSize)
            if showArrow {
                Image(systemName: "chevron.up")
                    .renderingMode(.template)
                    .resizable(resizingMode: .stretch)
                    .foregroundColor(.pointerPrimary)
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
