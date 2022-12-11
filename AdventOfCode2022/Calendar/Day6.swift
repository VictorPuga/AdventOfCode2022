//
//  Day6.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 11/12/22.
//

import Foundation

struct Day6: Day {
  let number = 6
  let input = [ // multiple test cases
    "mjqjpqmgbljsphdztnvjfqwrcgsmlb",
    "bvwbjplbgvbhsrlpgdmjqwftvncz",
    "nppdvjthqldpwncqszvftbrmjlhg",
    "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg",
    "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw",
  ][0]

  func solve() -> Int {
    var i = 4
    var start = input.index(input.startIndex, offsetBy: 0)
    var end = input.index(start, offsetBy: 3)

    while end != input.endIndex {
      var characters = Set<Character>()

      input[start ... end].forEach { characters.insert($0) }

      if characters.count == 4 {
        return i
      }

      i += 1
      start = input.index(start, offsetBy: 1)
      end = input.index(end, offsetBy: 1)
    }

    return -1
  }
}
