//
//  Day8.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 13/12/22.
//

import Foundation

struct Day8: Day {
  let number = 8
  let input = """
  30373
  25512
  65332
  33549
  35390
  """

  func solve() -> Int {
    let trees: [[Tree]] = input
      .split(separator: "\n")
      .map {
        $0.split(separator: "").map { Tree(height: Int($0)!) }
      }
    let n = trees.count

    var visibleCount = (n * 4) - 4 // trees at the edges

    for x in 1 ..< (n - 1) {
      for y in 1 ..< (n - 1) {
        let isVisible = checkVisibility((x, y), n, trees: trees)
        if isVisible {
          visibleCount += 1
        }
      }
    }
    return visibleCount
  }

  func checkVisibility(_ coordinates: (x: Int, y: Int), _ n: Int, trees: [[Tree]]) -> Bool {
    let tree = trees[coordinates.y][coordinates.x]
    for x in 0 ..< coordinates.x {
      if trees[coordinates.y][x].height >= tree.height {
        tree.visibility.left = false
        break
      }
    }
    for x in (coordinates.x + 1) ..< n {
      if trees[coordinates.y][x].height >= tree.height {
        tree.visibility.right = false
        break
      }
    }
    for y in 0 ..< coordinates.y {
      if trees[y][coordinates.x].height >= tree.height {
        tree.visibility.top = false
        break
      }
    }
    for y in (coordinates.y + 1) ..< n {
      if trees[y][coordinates.x].height >= tree.height {
        tree.visibility.bottom = false
        break
      }
    }
    return tree.isVisible()
  }
}

extension Day8 {
  class Tree {
    let height: Int
    var visibility: Visibility

    init(height: Int) {
      self.height = height
      visibility = Visibility()
    }

    func isVisible() -> Bool {
      return visibility.top || visibility.bottom || visibility.right || visibility.left
    }
  }

  struct Visibility {
    var top: Bool = true
    var bottom: Bool = true
    var right: Bool = true
    var left: Bool = true
  }
}
