//
//  Day12.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 18/12/22.
//

import Foundation

struct Day12: Day {
  let number = 12
  let input = """
  Sabqponm
  abcryxxl
  accszExk
  acctuvwj
  abdefghi
  """

  func solve() -> Int {
    var position = Coordinate(row: 0, col: 0)
    var end = Coordinate(row: 0, col: 0)
    let elevations = input
      .split(separator: "\n").enumerated()
      .map { row, line in
        line.split(separator: "").enumerated()
          .map { col, tile in
            if tile == "S" {
              position = Coordinate(row: row, col: col)
              return -1
            } else if tile == "E" {
              end = Coordinate(row: row, col: col)
              return 26
            } else {
              return Int(tile.utf8.first!) - 97
            }
          }
      }

    let visitedCoordinates = Array(repeating: Array(repeating: false, count: 8), count: 5)
    return evaluatePath(
      position,
      end,
      elevations: elevations,
      visited: visitedCoordinates,
      moveCount: 0
    )
  }

  func evaluatePath(
    _ position: Coordinate,
    _ end: Coordinate,
    elevations: [[Int]],
    visited: [[Bool]],
    moveCount: Int
  ) -> Int {
    if position == end {
      return moveCount
    }

    var visited = visited
    let posibleMoves = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    let currentHeight = elevations[position.row][position.col]
    let values = posibleMoves.map { move in
      let newPosition = position + move
      if newPosition.isValid() {
        let newHeight = elevations[newPosition.row][newPosition.col]
        let canMove = (newHeight - currentHeight) <= 1 // height is equal or greater by one
        let isVisited = visited[newPosition.row][newPosition.col]
        if canMove, !isVisited {
          visited[newPosition.row][newPosition.col] = true
          return evaluatePath(newPosition, end, elevations: elevations, visited: visited, moveCount: moveCount + 1)
        } else {
          return Int.max
        }
      } else {
        return Int.max
      }
    }

    return values.min()!
  }
}

extension Day12 {
  struct Coordinate: Equatable {
    let row: Int
    let col: Int

    func isValid() -> Bool {
      let validRow = (0 ... 4).contains(row)
      let validCol = (0 ... 7).contains(col)
      return validRow && validCol
    }

    static func + (lhs: Coordinate, rhs: (row: Int, col: Int)) -> Coordinate {
      Coordinate(
        row: lhs.row + rhs.row,
        col: lhs.col + rhs.col
      )
    }

    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
      return lhs.row == rhs.row && lhs.col == rhs.col
    }
  }
}
