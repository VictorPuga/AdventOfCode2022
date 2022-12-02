//
//  Day1.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 02/12/22.
//

import Foundation

struct Day1: Day {
  let number = 1
  let input = """
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  func solve() -> Int {
    let elves = input.split(separator: "\n\n")
    var maxCalories = 0

    for elf in elves {
      let calories = elf
        .split(separator: "\n")
        .reduce(into: 0) { partialResult, substr in
          partialResult += Int(substr)!
        }

      if calories > maxCalories {
        maxCalories = calories
      }
    }

    return maxCalories
  }
}
