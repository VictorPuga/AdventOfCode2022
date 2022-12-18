//
//  Day10.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 14/12/22.
//

import Foundation
import RegexBuilder

struct Day10: Day {
  let number = 10
  let input = """
  addx 15
  addx -11
  addx 6
  addx -3
  addx 5
  addx -1
  addx -8
  addx 13
  addx 4
  noop
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx -35
  addx 1
  addx 24
  addx -19
  addx 1
  addx 16
  addx -11
  noop
  noop
  addx 21
  addx -15
  noop
  noop
  addx -3
  addx 9
  addx 1
  addx -3
  addx 8
  addx 1
  addx 5
  noop
  noop
  noop
  noop
  noop
  addx -36
  noop
  addx 1
  addx 7
  noop
  noop
  noop
  addx 2
  addx 6
  noop
  noop
  noop
  noop
  noop
  addx 1
  noop
  noop
  addx 7
  addx 1
  noop
  addx -13
  addx 13
  addx 7
  noop
  addx 1
  addx -33
  noop
  noop
  noop
  addx 2
  noop
  noop
  noop
  addx 8
  noop
  addx -1
  addx 2
  addx 1
  noop
  addx 17
  addx -9
  addx 1
  addx 1
  addx -3
  addx 11
  noop
  noop
  addx 1
  noop
  addx 1
  noop
  noop
  addx -13
  addx -19
  addx 1
  addx 3
  addx 26
  addx -30
  addx 12
  addx -1
  addx 3
  addx 1
  noop
  noop
  noop
  addx -9
  addx 18
  addx 1
  addx 2
  noop
  noop
  addx 9
  noop
  noop
  noop
  addx -1
  addx 2
  addx -37
  addx 1
  addx 3
  noop
  addx 15
  addx -21
  addx 22
  addx -6
  addx 1
  noop
  addx 2
  addx 1
  noop
  addx -10
  noop
  noop
  addx 20
  addx 1
  addx 2
  addx 2
  addx -6
  addx -11
  noop
  noop
  noop
  """

  func solve() -> Int {
    let regex = Regex {
      TryCapture {
        ChoiceOf { "noop"; "addx" }
      } transform: { Instruction(rawValue: String($0)) }
      Optionally {
        " "
        TryCapture {
          Optionally("-")
          OneOrMore(.digit)
        } transform: { Int($0) }
      }
    }

    var cycles = 1
    var register = 1
    var strengths = 0

    for line in input.split(separator: "\n") {
      let result = try! regex.wholeMatch(in: line)
      let (_, instruction, value) = result!.output

      switch instruction {
      case .noop:
        cycles += 1
        strengths += checkStrength(cycles, register)
      case .addx:
        cycles += 1
        strengths += checkStrength(cycles, register)
        cycles += 1
        register += value!
        strengths += checkStrength(cycles, register)
      }
    }
    return strengths
  }

  func checkStrength(_ cycle: Int, _ register: Int) -> Int {
    switch cycle {
    case 20, 60, 100, 140, 180, 220:
      return cycle * register
    default:
      return 0
    }
  }
}

extension Day10 {
  enum Instruction: String {
    case noop
    case addx
  }
}
