//
//  Day9.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 13/12/22.
//

import Foundation
import RegexBuilder

struct Day9: Day {
  let number = 9
  let input = """
  R 4
  U 4
  L 3
  D 1
  R 4
  D 1
  L 5
  R 2
  """

  let printDebugBridge = false

  func solve() -> Int {
    let regex = Regex {
      TryCapture { One(.word) } transform: { Direction(rawValue: String($0)) }
      " "
      TryCapture { One(.digit) } transform: { Int($0) }
    }
    var bridge: [[Status]] = Array(repeating: Array(repeating: Status(), count: 6), count: 5)
    bridge[4][0] = .start

    let head = RopeEdge()
    let tail = RopeEdge()

    for step in input.split(separator: "\n") {
      let result = try! regex.wholeMatch(in: step)
      let (_, direction, times) = result!.output

      for _ in 0 ..< times {
        bridge[head.position.y][head.position.x].remove(.head)
        bridge[tail.position.y][tail.position.x].remove(.tail)

        move(head: head, to: direction)
        move(tail: tail, to: head)

        bridge[head.position.y][head.position.x].insert(.head)
        bridge[tail.position.y][tail.position.x].insert([.tail, .visited])

        if printDebugBridge {
          printBridge(bridge)
        }
      }
    }

    let visitedCount = bridge.reduce(into: 0) { partialResult, row in
      partialResult += row.reduce(into: 0) { rowSum, status in
        if status.contains(.visited) {
          rowSum += 1
        }
      }
    }

    return visitedCount
  }

  func move(head: RopeEdge, to direction: Direction) {
    switch direction {
    case .U:
      head.position.y -= 1
    case .D:
      head.position.y += 1
    case .L:
      head.position.x -= 1
    case .R:
      head.position.x += 1
    }
  }

  func move(tail: RopeEdge, to head: RopeEdge) {
    let direction = head.position - tail.position

    if abs(direction.x) == 2 || abs(direction.y) == 2 {
      tail.position.x += direction.x.signum()
      tail.position.y += direction.y.signum()
    }
  }
}

extension Day9 {
  enum Direction: String {
    case U
    case D
    case L
    case R
  }

  struct Status: OptionSet {
    let rawValue: Int

    // static let unvisited = Status([])
    static let start = Status(rawValue: 1 << 0)
    static let visited = Status(rawValue: 1 << 1)
    static let head = Status(rawValue: 1 << 2)
    static let tail = Status(rawValue: 1 << 3)
  }

  class RopeEdge {
    var position: Coodinate

    init() {
      position = Coodinate(x: 0, y: 4)
    }
  }

  struct Coodinate {
    var x: Int
    var y: Int

    static func - (lhs: Coodinate, rhs: Coodinate) -> Coodinate {
      let x = lhs.x - rhs.x
      let y = lhs.y - rhs.y

      return Coodinate(x: x, y: y)
    }

    static func == (lhs: Coodinate, rhs: (Int, Int)) -> Bool {
      return lhs.x == rhs.0 && lhs.y == rhs.1
    }
  }
}

// MARK: - Debugging

extension Day9 {
  func printBridge(_ bridge: [[Status]]) {
    for col in bridge {
      for tile in col {
        var character: Character?
        if tile.contains(.head) { character = "H" }
        else if tile.contains(.tail) { character = "T" }
        else if tile.contains(.start) { character = "s" }
        else if tile.contains(.visited) { character = "#" }
        else { character = "." }
        print(character!, terminator: "")
      }
      print("")
    }
    print("")
  }
}
