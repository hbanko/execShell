//
//  main.swift
//  execShell
//
//  Created by Holger Banko on 14/12/19.
//  Copyright © 2019 Holger Banko. All rights reserved.
//

import Foundation

print("Hello, World!")

let task = Process()
task.executableURL = URL(fileURLWithPath: "/usr/local/bin/VBoxManage")
let option = "list"
let command = "vms"
task.arguments = [option, command]
let outputPipe = Pipe()
let errorPipe = Pipe()

task.standardOutput = outputPipe
task.standardError = errorPipe
try task.run()
let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
let output = String(decoding: outputData, as: UTF8.self)
let error = String(decoding: errorData, as: UTF8.self)

if output.count > 0 {
    print("program output:")
    print(output)
}
if error.count > 0 {
    print("error output:")
    print(error)
}

// Filter with Regex "(.*?)"


