//
//  Day7.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 11/12/22.
//

import Foundation
import RegexBuilder

struct Day7: Day {
  let number = 7
  let input = """
  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k
  """

  func solve() -> Int {
    let commandRegex = Regex {
      "$ "
      TryCapture {
        ChoiceOf { "cd"; "ls" }
      } transform: { Command(rawValue: String($0)) }
      Optionally {
        One(.whitespace)
        TryCapture {
          ChoiceOf {
            OneOrMore(.word)
            ".."
            "/"
          }
        } transform: { String($0) }
      }
    }

    let lsRegex = Regex {
      TryCapture {
        ChoiceOf {
          "dir"
          OneOrMore(.digit)
        }
      } transform: { Int($0) }
      " "
      TryCapture {
        OneOrMore(.any)
      } transform: { String($0) }
    }

    let fileSystem = Node(directory: "/")
    var currentDir: Node = fileSystem

    for line in input.split(separator: "\n") {
      if line.first == "$" {
        let result = try! commandRegex.wholeMatch(in: line)
        let (_, command, fileName) = result!.output

        switch command {
        case .cd:
          handleCDCommand(fileName, &currentDir)
        case .ls:
          break
        }
      } else {
        guard let result = try! lsRegex.wholeMatch(in: line) else { continue }
        let (_, size, name) = result.output
        handleLSCommandResult(name, size, currentDir)
      }
    }

    let sizes = findSmallDirectories(fileSystem.children)

    return sizes
  }
}

extension Day7 {
  func handleCDCommand(
    _ fileName: String?,
    _ currentDir: inout Node
  ) {
    guard let name = fileName else { return }
    if name == "/" {}
    else if name == ".." {
      currentDir = currentDir.parent!
    } else {
      let newNode = Node(directory: name)
      currentDir.addChild(newNode)
      currentDir = newNode
    }
  }

  func handleLSCommandResult(
    _ name: String,
    _ size: Int,
    _ currentDir: Node
  ) {
    let newNode = Node(file: name, size)
    currentDir.addChild(newNode)
  }

  func findSmallDirectories(_ fileSystem: [Node]) -> Int {
    var result = 0
    for node in fileSystem {
      let size = node.getSize()
      if node.kind == .directory, size < 100_000 {
        result += size
        result += findSmallDirectories(node.children)
      }
    }
    return result
  }
}

extension Day7 {
  enum Command: String {
    case cd
    case ls
  }

  class Node {
    private(set) var name: String
    private(set) var kind: NodeKind
    private var size: Int
    private(set) var children: [Node]
    private(set) weak var parent: Node?

    init(directory name: String) {
      self.name = name
      kind = .directory
      children = []
      size = 0
      parent = nil
    }

    init(file name: String, _ size: Int) {
      self.name = name
      kind = .file
      children = []
      self.size = size
      parent = nil
    }

    func addChild(_ newNode: Node) {
      children.append(newNode)
      newNode.parent = self
    }

    func getSize() -> Int {
      switch kind {
      case .file:
        return size
      case .directory:
        return children.reduce(into: 0) { partialResult, node in
          partialResult += node.getSize()
        }
      }
    }

    enum NodeKind {
      case file
      case directory
    }
  }
}
