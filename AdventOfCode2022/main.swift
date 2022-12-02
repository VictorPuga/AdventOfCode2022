//
//  main.swift
//  AdventOfCode2022
//
//  Created by Víctor Manuel Puga Ruiz on 02/12/22.
//

import Foundation

let calendar: [any Day] = [
  Day1(),
  Day2()
]

for day in calendar {
  print(
    "\(day.number < 10 ? " ": "" )\(day.number)",
    day.solve()
  )
}
