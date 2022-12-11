//
//  Day4.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 11/12/22.
//

import Foundation
import RegexBuilder

struct Day4: Day {
  let number = 4
  let input = """
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
  """

  func solve() -> Int {
    let regex = Regex {
      TryCapture { One(.digit) } transform: { Int($0) }
      "-"
      TryCapture { One(.digit) } transform: { Int($0) }
      ","
      TryCapture { One(.digit) } transform: { Int($0) }
      "-"
      TryCapture { One(.digit) } transform: { Int($0) }
    }

    let containedPairs = input
      .split(separator: "\n")
      .reduce(into: 0) { partialResult, line in
        let result = try! regex.wholeMatch(in: line)
        let (_, start1, end1, start2, end2) = result!.output

        if (start1 >= start2 && end1 <= end2) ||
          (start1 <= start2 && end1 >= end2)
        {
          partialResult += 1
        }
      }
    return containedPairs
  }
}
