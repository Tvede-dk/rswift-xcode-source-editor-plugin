//
// Created by Kasper T on 03/06/2017.
// Copyright (c) 2017 R.swift.sourceExtensionContainer. All rights reserved.
//

import Foundation

extension Bool {
    func onTrue(action: () -> Void) {
        if self {
            action()
        }
    }
}
