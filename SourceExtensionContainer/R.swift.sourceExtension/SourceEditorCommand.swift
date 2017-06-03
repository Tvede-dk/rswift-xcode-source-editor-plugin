//
//  SourceEditorCommand.swift
//  R.swift.sourceExtension
//
//  Created by Kasper T on 14/10/2016.
//  Copyright © 2016 R.swift.sourceExtensionContainer. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void) {
        // Implement your command here,
        //invoking the completion handler when done. Pass it nil on success, and an NSError on failure.

        let convertedLines = convertLines(invocation: invocation)

        let updatedLineIndexes: [Int] = performWork(orgStrings: convertedLines, invocation: invocation)

        if !updatedLineIndexes.isEmpty {
            calculateUpdate(updatedLineIndexes: updatedLineIndexes, invocation: invocation)
        }
        completionHandler(nil)
    }

    func convertLines(invocation: XCSourceEditorCommandInvocation) -> [String?] {
        return invocation.buffer.lines.flatMap { element in
            element as? String
        }
    }

    func performWork(orgStrings: [String?], invocation: XCSourceEditorCommandInvocation) -> [Int] {
        var result: [Int] = []
        orgStrings.forEachWithIndex { string, index in
            tryWorkOn(string, index, invocation).onTrue {
                result.append(index)
            }
        }
        return result
    }

    private func tryWorkOn(_ line: String?, _ lineIndex: Int, _ invocation: XCSourceEditorCommandInvocation) -> Bool {
        if let safeLine = MainReplacementHandler.processLine(line: line) {
            invocation.buffer.lines[lineIndex] = safeLine
            return true
        }
        return false
    }

    // If at least a line was changed, create an array of changes and pass it to the buffer selections
    func calculateUpdate(updatedLineIndexes: [Int], invocation: XCSourceEditorCommandInvocation) {
        let updatedSelections: [XCSourceTextRange] = updatedLineIndexes.map { lineIndex in
            let lineSelection = XCSourceTextRange()
            lineSelection.start = XCSourceTextPosition(line: lineIndex, column: 0)
            lineSelection.end = XCSourceTextPosition(line: lineIndex, column: 0)
            return lineSelection
        }
        invocation.buffer.selections.setArray(updatedSelections)
    }

}
