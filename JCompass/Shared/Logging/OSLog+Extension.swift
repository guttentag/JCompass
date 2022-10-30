//
//  OSLog+Extension.swift
//  JCompass
//
//  Created by Eran Gutentag on 26/10/2022.
//  Copyright © 2022 Gutte. All rights reserved.
//

import os.log

extension OSLog {
    static let jcSubsystem = "me.gutte.JCompass"
    
    class func JCLog(category: String) -> OSLog {
        OSLog(subsystem: jcSubsystem, category: category)
    }
}
