//
//  ContentView.swift
//  JCompass
//
//  Created by Eran Gutentag on 24/10/2022.
//  Copyright © 2022 Gutte. All rights reserved.
//

import SwiftUI
import os.log

struct ContentView: View {
    let viewModel = AppViewModel()
    @State var showPointer: Bool = true
    
    var body: some View {
        Group {
            if showPointer {
                PointerView(viewModel: PointerViewModel(pointer: viewModel.jerusalemPointer))
            } else {
                NoPermissionsView()
            }
        }
        .onReceive(viewModel.userDeniedAuthorized) { permissionDenied in
            withAnimation { showPointer = !permissionDenied }
        }
    }
    
    private struct NoPermissionsView: View {
        var body: some View {
            VStack(alignment: .center, spacing: 16) {
                Spacer()
                Text("🤷")
                    .font(.system(size: 95))
                Text("location_permission_privilege_title")
                    .font(.largeTitle)
                Text("location_permission_privilege_body")
                    .font(.subheadline)
                Button("location_permission_privilege_cta") {
                    guard let url = URL(string: UIApplication.openSettingsURLString)
                    else {
                        os_log(.error, "could not create setting url")
                        return
                    }
                    
                    UIApplication.shared.open(url)
                }
                .font(.title)
                .foregroundColor(.black)
                .padding()
                .background(Color.goldPrimaryLight)
                .clipShape(Capsule())
                .padding(.top, 72)
                Spacer()
            }
            .multilineTextAlignment(.center)
        }
    }
}
