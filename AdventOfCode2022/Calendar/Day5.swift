//
//  Day5.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 11/12/22.
//

import Foundation
import RegexBuilder

struct Day5: Day {
  let number = 5
  let input = """
      [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
  """

  func solve() -> String {
    let parts = input.split(separator: "\n\n", maxSplits: 1)
    let positions = parts[0]
    let moves = parts[1]

    var stacks = parsePositionIntoStacks(positions)
    moveItems(moves, stacks: &stacks)

    let result = stacks.reduce(into: "") { partialResult, stack in
      partialResult += stack.last!
    }
    
    return result
  }
}

extension Day5 {
  func parsePositionIntoStacks(_ string: Substring) -> [[String]] {
    var stacks = [[String](), [String](), [String]()]

    let stackRegex = Regex {
      ZeroOrMore(.whitespace)
      ChoiceOf { "   "; /\[(\w)\]/ }
      ZeroOrMore(.whitespace)
      ChoiceOf { "   "; /\[(\w)\]/ }
      ZeroOrMore(.whitespace)
      ChoiceOf { ""; "   "; /\[(\w)\]/ }
      ZeroOrMore(.whitespace) // Xcode removes trailing whitespaces
    }

    for line in string.split(separator: "\n").reversed() {
      if let result = try! stackRegex.wholeMatch(in: line) {
        let (_, item1, item2, item3) = result.output
        let items = [item1, item2, item3]
        for i in 0 ... 2 {
          if let item = items[i] {
            stacks[i].append(String(item))
          }
        }
      }
    }
    return stacks
  }

  func moveItems(_ moves: Substring, stacks: inout [[String]]) {
    let movesRegex = Regex {
      "move "
      TryCapture { One(.digit) } transform: { Int($0) }
      " from "
      TryCapture { One(.digit) } transform: { Int($0) }
      " to "
      TryCapture { One(.digit) } transform: { Int($0) }
    }

    for move in moves.split(separator: "\n") {
      let result = try! movesRegex.wholeMatch(in: move)
      let (_, quantity, origin, destination) = result!.output
      for _ in 0 ..< quantity {
        let item = stacks[origin - 1].popLast()!
        stacks[destination - 1].append(item)
      }
    }
  }
}
