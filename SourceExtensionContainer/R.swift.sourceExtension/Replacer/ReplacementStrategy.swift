//
// Created by Kasper T on 03/06/2017.
// Copyright (c) 2017 R.swift.sourceExtensionContainer. All rights reserved.
//

import Foundation

protocol ReplacementProtocol {
    func performReplacement(text: NSString) -> String?
}

class RegExpReplacementStrategy: ReplacementProtocol {

    let regExpWithNameGroup: NSRegularExpression

    let replacementValue: String

    init(regExpWithNameGroup: NSRegularExpression, replacementValue: String) {
        self.regExpWithNameGroup = regExpWithNameGroup
        self.replacementValue = replacementValue
    }

    func performReplacement(text: NSString) -> String? {
        let range = NSRange(0..<text.length)
        let results = self.regExpWithNameGroup.matches(in: text as String, options: .reportProgress, range: range)

        if results.count > 0, results[0].numberOfRanges > 0 {
            let result = results[0]
            let firstGroup = result.range
            let firstGroupStart = firstGroup.location

            let name = text.substring(with: result.rangeAt(1))
            var lastString = ""
            if result.numberOfRanges > 2 {
                lastString = text.substring(from: result.rangeAt(2).location)
            }
            return text.substring(to: firstGroupStart)
                    + replacementValue + processName(name: name) + lastString
        }
        return nil
    }

    func processName(name: String) -> String {
        return name
    }
}

class ReplacementHelper {

    public class func createRegExpCodeForm(functionName: String, paramName: String) throws -> NSRegularExpression {
        return try NSRegularExpression(pattern: functionName + "\\s*\\(\\s*" + paramName + "\\s*:\\s*\"(.*)\"\\s*\\)",
                options: .caseInsensitive)
    }

    static let AnyWhiteSpace = "\\s*"

    static let startParan = "\\("
    static let endParan = "\\)"
    static let anythingCapture = "(.*?)"
    static let anything = "(.*?)"

    static let stringGroupInQuotes = "\"\(anythingCapture)\""

    static func stringParameter(parameterName: String) -> String {
        return AnyWhiteSpace + parameterName + AnyWhiteSpace + ":" + AnyWhiteSpace + stringGroupInQuotes
    }

    static func functionWithStringParam(functionName: String, parameterName: String) -> String {
        return AnyWhiteSpace + functionName + AnyWhiteSpace + startParan + AnyWhiteSpace //"func("
                + stringParameter(parameterName: parameterName) + AnyWhiteSpace // "x:"qwe"
                + endParan
    }

    static func functionWithStringParameterAndOtherParameters(functionName: String,
                                                              parameterName: String) -> String {
        return functionName + AnyWhiteSpace + startParan + AnyWhiteSpace //"func("
                + stringParameter(parameterName: parameterName) + AnyWhiteSpace // "x:"qwe"
                + "," + AnyWhiteSpace
                + anythingCapture + AnyWhiteSpace + endParan
    }

    static func functionWithStringParameterSkipRest(functionName: String,
                                                    parameterName: String) -> String {
        return functionName + AnyWhiteSpace + startParan + AnyWhiteSpace //"func("
                + stringParameter(parameterName: parameterName)
    }

    static func functionWithUnnamedParameterSkipRest(functionName: String) -> String {
        return functionName + AnyWhiteSpace + startParan + AnyWhiteSpace //"func("
                + stringGroupInQuotes  // "someString"
    }

}
