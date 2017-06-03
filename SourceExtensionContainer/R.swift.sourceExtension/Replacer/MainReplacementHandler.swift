//
// Created by Kasper T on 03/06/2017.
// Copyright (c) 2017 R.swift.sourceExtensionContainer. All rights reserved.
//

import Foundation

class MainReplacementHandler {

    static let toProcess: [ReplacementProtocol] = [
        UIImageReplacement(),
        NibReplacement(),
        UIFontReplacement(),
        NSLocalizedStringReplacement(),
        StoryboardReplacement(),
        SegueReplacement()
    ]

    class func processLine(line: String?) -> String? {
        guard let line = line else {
            return nil
        }

        var currentLine = line as NSString
        var haveFoundOne = false
        for item in toProcess {
            if let newLine = item.performReplacement(text: currentLine) {
                currentLine = newLine as NSString
                haveFoundOne = true
            }
        }
        if haveFoundOne {
            return currentLine as String
        }
        return nil
    }
}
