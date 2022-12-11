//
//  main.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 02/12/22.
//

import Foundation

var currentDay: Int?

let calendar: [any Day] = [
  Day1(),
  Day2(),
  Day3()
]

// currentDay = 3

if let day = currentDay {
  print(calendar[day - 1].solve())
} else {
  for day in calendar {
    print(
      "\(day.number < 10 ? " " : "")\(day.number)",
      day.solve()
    )
  }
}
