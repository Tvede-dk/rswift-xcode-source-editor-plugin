//
// Created by Kasper T on 03/06/2017.
// Copyright (c) 2017 R.swift.sourceExtensionContainer. All rights reserved.
//

import Foundation

extension String {

    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    func loweredFirstLetter() -> String {
        let first = String(characters.prefix(1)).lowercased()
        let other = String(characters.dropFirst())
        return first + other
    }

    mutating func loweredFirstLetter() {
        self = self.loweredFirstLetter()
    }

    func removeAndUpperCaseNextChar(_ toStrip: Character) -> String {
        var upNextChar = false
        return String(self.characters.flatMap { char in
            if char == toStrip {
                upNextChar = true
                return nil
            }
            if upNextChar {
                upNextChar = false
                return char.toUpperCase()
            }
            return char
        })
    }

    func removeAll(_ toStrip: String) -> String {
        return replace(target: toStrip, withString: "")
    }

    func removeAll(_ toStrip: String...) -> String {
        return toStrip.reduce(self) { (result: String, stripValue: String) -> String in
            return result.replace(target: stripValue, withString: "")
        }
    }

    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString,
                options: NSString.CompareOptions.literal, range: nil)
    }
}

extension Character {
    func toUpperCase() -> Character {
        return Character(String(self).uppercased())
    }

    func toLowerCase() -> Character {
        return Character(String(self).lowercased())
    }
}

extension Array where Element == String? {

    func forEachWithIndex(action: (String?, Int) -> Void) {
        var index = 0
        forEach { element in
            action(element, index)
            index += 1
        }

    }

}
