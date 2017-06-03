//
// Created by Kasper T on 03/06/2017.
// Copyright (c) 2017 R.swift.sourceExtensionContainer. All rights reserved.
//

import Foundation

let uIImageRegExp = try! ReplacementHelper.createRegExpCodeForm(functionName: "UIImage", paramName: "named")

class UIImageReplacement: RegExpReplacementStrategy {
    init() {
        super.init(regExpWithNameGroup: uIImageRegExp, replacementValue: "R.image.")
    }

    override func processName(name: String) -> String {
        return name.removeAndUpperCaseNextChar(".").removeAndUpperCaseNextChar("-") + "()"
    }
}

class NibReplacement: RegExpReplacementStrategy {
    init() {
        try! super.init(regExpWithNameGroup: NSRegularExpression(pattern:
        ReplacementHelper.functionWithStringParameterSkipRest(functionName: "UINib",
                parameterName: "nibName")), replacementValue: "R.nib.")
    }

    override func processName(name: String) -> String {
        return name.loweredFirstLetter().removeAll("_", "-") + "()"
    }
}

class UIFontReplacement: RegExpReplacementStrategy {
    init() {
        try! super.init(regExpWithNameGroup: NSRegularExpression(pattern:
        ReplacementHelper.functionWithStringParameterAndOtherParameters(functionName: "UIFont", parameterName: "name"))
                , replacementValue: "R.font.")
    }

    override func processName(name: String) -> String {
        return name.loweredFirstLetter().removeAll("_", "-") + "("
    }
}

class NSLocalizedStringReplacement: RegExpReplacementStrategy {
    init() {
        try! super.init(regExpWithNameGroup: NSRegularExpression(pattern:
        ReplacementHelper.functionWithUnnamedParameterSkipRest(functionName: "NSLocalizedString"))
                , replacementValue: "R.string.localizable.")
    }

    override func processName(name: String) -> String {
        return name.loweredFirstLetter().removeAndUpperCaseNextChar(".") + "()"
    }
}

class StoryboardReplacement: RegExpReplacementStrategy {
    init() {
        try! super.init(regExpWithNameGroup: NSRegularExpression(pattern:
        ReplacementHelper.functionWithStringParameterSkipRest(functionName: "UIStoryboard", parameterName: "name"))
                , replacementValue: "R.storyboard.")
    }

    override func processName(name: String) -> String {
        return name.loweredFirstLetter() + "()"
    }
}

class SegueReplacement: RegExpReplacementStrategy {
    init() {
        try! super.init(regExpWithNameGroup: NSRegularExpression(pattern:
        ReplacementHelper.functionWithStringParameterAndOtherParameters(functionName: "performSegue", parameterName: "withIdentifier"))
                , replacementValue: "performSegue(withIdentifier: R.segue.<#viewcontroller here#>.")
    }

    override func processName(name: String) -> String {
        return name.loweredFirstLetter() + ", "
    }
}