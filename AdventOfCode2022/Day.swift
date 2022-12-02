//
//  Day.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 02/12/22.
//

import Foundation

protocol Day {
  associatedtype InputType
  associatedtype OutputType

  var url: String { get }
  var number: Int { get }
  var input: InputType { get }

  func solve() -> OutputType
}

extension Day {
  var url: String {
    "https://adventofcode.com/2022/day/\(number)"
  }
}
