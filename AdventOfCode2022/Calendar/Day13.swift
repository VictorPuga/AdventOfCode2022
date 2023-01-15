//
//  Day13.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 18/12/22.
//

import Foundation

struct Day13: Day {
  let number = 13
  let input = """
  [1,1,3,1,1]
  [1,1,5,1,1]

  [[1],[2,3,4]]
  [[1],4]

  [9]
  [[8,7,6]]

  [[4,4],4,4]
  [[4,4],4,4,4]

  [7,7,7,7]
  [7,7,7]

  []
  [3]

  [[[]]]
  [[]]

  [1,[2,[3,[4,[5,6,7]]]],8,9]
  [1,[2,[3,[4,[5,6,0]]]],8,9]
  """

  func solve() -> Int {
    let pairs = input.split(separator: "\n\n").map {
      $0.split(separator: "\n").map { parseInput($0) }
    }
    var result = 0
    for i in 0 ..< pairs.count {
      let pair = pairs[i]
      let isOrdered = compareArrays(left: pair[0], right: pair[1])
      if isOrdered {
        result += (i + 1)
      }
    }
    return result
  }

  func parseInput(_ line: Substring) -> [Any] {
    let json = try! JSONSerialization.jsonObject(with: line.data(using: .utf8)!, options: []) as! [Any]
    return convertToArray(json)
  }

  func compareArrays(left: [Any], right: [Any]) -> Bool {
    let count = min(left.count, right.count)
    for i in 0 ..< count {
      if let l = left[i] as? Int, let r = right[i] as? Int { // Both Ints
        if l == r { continue }
        if l > r { return false }
      } else if let l = left[i] as? [Any], let r = right[i] as? Int { // Array and Int
        return compareArrays(left: l, right: [r])
      } else if let l = left[i] as? Int, let r = right[i] as? [Any] { // Int and Array
        return compareArrays(left: [l], right: r)
      } else if let l = left[i] as? [Any], let r = right[i] as? [Any] { // Both Arrays
        return compareArrays(left: l, right: r)
      }
    }

    let isLeftSide = count == left.count
    return isLeftSide
  }

  func convertToArray(_ array: [Any]) -> [Any] {
    var newArray = [Any]()
    for item in array {
      if let item = item as? [Any] {
        newArray.append(convertToArray(item))
      } else {
        newArray.append(item)
      }
    }

    return newArray
  }

  // TODO: Parse input manually
  func parseLine(_ line: Substring) -> [Any] {
    let array: [Any] = []
    let start = line.index(after: line.startIndex)
    let end = line.index(before: line.endIndex)
    print(line[start ..< end])
    for char in line[start ..< end].split(separator: ",") {
      print(char)
      // if char == "[]"
    }
    // print("..")
    return array
  }
}
