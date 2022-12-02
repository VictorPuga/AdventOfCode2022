//
//  Day2.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 02/12/22.
//

import Foundation
import RegexBuilder

struct Day2: Day {
  let number = 20
  let input = """
  A Y
  B X
  C Z
  """

  enum Move: Int {
    case rock = 0
    case paper = 1
    case scissors = 2

    var extraPoints: Int {
      rawValue + 1
    }

    init? (from symbol: String) {
      switch symbol {
      case "A", "X":
        self = .rock
      case "B", "Y":
        self = .paper
      case "C", "Z":
        self = .scissors
      default:
        return nil
      }
    }
  }

  func solve() -> Int {
    let results = [
      [3, 6, 0],
      [0, 3, 6],
      [6, 0, 3],
    ]

    let regex = Regex {
      TryCapture {
        ChoiceOf { "A"; "B"; "C" }
      } transform: { Move(from: String($0)) }
      One(.whitespace)
      TryCapture {
        ChoiceOf { "X"; "Y"; "Z" }
      } transform: { Move(from: String($0)) }
    }

    var points = 0
    let rounds = input.split(separator: "\n")
    for round in rounds {
      let result = try! regex.wholeMatch(in: round)
      let elf = result!.1
      let me = result!.2
      
      points += results[elf.rawValue][me.rawValue]
      points += me.extraPoints
    }

    return points
  }
}
