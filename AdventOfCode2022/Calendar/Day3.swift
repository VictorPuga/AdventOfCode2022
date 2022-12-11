//
//  Day3.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 11/12/22.
//

import Foundation

struct Day3: Day {
  let number = 3
  let input = """
  vJrwpWtwJgWrhcsFMMfFFhFp
  jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
  PmmdzqPrVvPwwTWBwg
  wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
  ttgJtRGJQctTZtZT
  CrZsJsPPZsGzwwsLwLmpwMDw
  """

  func solve() -> Int {
    let values = input
      .split(separator: "\n")
      .reduce(into: 0) { totalSum, bags in
      var currentCharacters = Set<Character>()
      let (firstHalf, secondHalf) = splitStringInHalf(bags)
      firstHalf.forEach { currentCharacters.insert($0) }
        
      for char in secondHalf {
        if currentCharacters.contains(char) {
          totalSum += itemValue(char)
          break // the item can be repeated more than once
        }
      }
    }
    return values
  }
}

extension Day3 {
  func itemValue(_ char: Character) -> Int {
    let ascii = Int(char.asciiValue!)
    if ascii > 96 { // lowercase (1-26)
      return ascii - 96
    } else { // uppercase (27-52)
      return ascii - 38
    }
  }

  func splitStringInHalf(_ string: Substring) -> (firstHalf: Substring, secondHalf: Substring) {
    let start = string.startIndex
    let end = string.endIndex
    let half = string.index(start, offsetBy: string.count / 2)

    let firstHalf = string[start ..< half]
    let secondHalf = string[half ..< end]
    return (firstHalf, secondHalf)
  }
}
