//
//  TestMainReplacements.swift
//  SourceExtensionContainer
//
//  Created by Kasper T on 03/06/2017.
//  Copyright © 2017 R.swift.sourceExtensionContainer. All rights reserved.
//

import Foundation
import XCTest
@testable import SourceExtensionContainer

class TestMainReplacements: XCTestCase {

    func testUIImage() {
        let replacer = UIImageReplacement()
        XCTAssertEqual(replacer.performReplacement(text: ""), nil)
        XCTAssertEqual(replacer.performReplacement(text: "UIIMAGE"), nil)

        XCTAssertEqual(replacer.performReplacement(text: "UIImage named magic"), nil)
        XCTAssertEqual(replacer.performReplacement(text: "UIImage(named 'sad') "), nil)
        XCTAssertEqual(replacer.performReplacement(text: "UIImage(named : 'sad') "), nil)
        let before = "let settingsIcon = UIImage(named: \"settings-icon\")"
        let before2 = "let gradientBackground = UIImage(named: \"gradient.jpg\")"
        let after = "let settingsIcon = R.image.settingsIcon()"
        let after2 = "let gradientBackground = R.image.gradientJpg()"

        assertTransform(expected: after, toTransform: before, replacer: replacer)
        assertTransform(expected: after2, toTransform: before2, replacer: replacer)
    }

    func testUIFont() {
        let replacer = UIFontReplacement()
        XCTAssertEqual(replacer.performReplacement(text: ""), nil)
        XCTAssertEqual(replacer.performReplacement(text: "UIFont"), nil)

        let before = "let lightFontTitle = UIFont(name: \"Acme-Light\", size: 22)"
        let after = "let lightFontTitle = R.font.acmeLight(size: 22)"
        assertTransform(expected: after, toTransform: before, replacer: replacer)
    }

    func testNib() {
        let replacer = NibReplacement()
        XCTAssertEqual(replacer.performReplacement(text: ""), nil)
        XCTAssertEqual(replacer.performReplacement(text: "UINib"), nil)

        let before = "let customViewNib = UINib(nibName: \"CustomView\", bundle: nil)"
        let after = "let customViewNib = R.nib.customView()"
        assertTransform(expected: after, toTransform: before, replacer: replacer)
    }

    func testSegues() {
        let replacer = SegueReplacement()
        XCTAssertEqual(replacer.performReplacement(text: ""), nil)
        XCTAssertEqual(replacer.performReplacement(text: "performSegue"), nil)
        //we cannot "magically" figure out what controller this is. so we need this input.. :(
        let before = "performSegue(withIdentifier: \"openSettings\", sender: self)"
        let after = "performSegue(withIdentifier: R.segue.<#viewcontroller here#>.openSettings, sender: self)"
        assertTransform(expected: after, toTransform: before, replacer: replacer)
    }

    func testStoryBoard() {
        let replacer = StoryboardReplacement()
        XCTAssertEqual(replacer.performReplacement(text: ""), nil)
        XCTAssertEqual(replacer.performReplacement(text: "UIStoryboard"), nil)

        let before = "let storyboard = UIStoryboard(name: \"Main\", bundle: nil)"
        let after = "let storyboard = R.storyboard.main()"
        assertTransform(expected: after, toTransform: before, replacer: replacer)
    }

    func testNsLocalizedString() {
        let replacer = NSLocalizedStringReplacement()
        XCTAssertEqual(replacer.performReplacement(text: ""), nil)
        XCTAssertEqual(replacer.performReplacement(text: "NSLocalizedString"), nil)

        let before = "let welcomeMessage = NSLocalizedString(\"welcome.message\", comment: \"\")"
        let after = "let welcomeMessage = R.string.localizable.welcomeMessage()"
        assertTransform(expected: after, toTransform: before, replacer: replacer)
    }

    private func assertTransform(expected: String, toTransform: String, replacer: ReplacementProtocol) {
        let tryValue = replacer.performReplacement(text: toTransform as NSString)
        XCTAssertEqual(tryValue, expected)
    }
}
