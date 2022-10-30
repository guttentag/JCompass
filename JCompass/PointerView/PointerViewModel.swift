//
//  PointerViewModel.swift
//  JCompass
//
//  Created by Eran Gutentag on 24/10/2022.
//  Copyright © 2022 Gutte. All rights reserved.
//

import Combine
import os.log

class PointerViewModel: ObservableObject {
    @Published var angle: Double? = .none
    var locationCancellable: Cancellable?
    
    init(pointer: LocationPointer) {
        locationCancellable = pointer.pointer
            .sink { [weak self] in self?.angle = $0 }
    }
}
