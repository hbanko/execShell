//
//  main.swift
//  execShell
//
//  Created by Holger Banko on 14/12/19.
//  Copyright © 2019 Holger Banko. All rights reserved.
//

import Foundation

func runCommand(cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {

    var output : [String] = []
    var error : [String] = []

    let task = Process()
    task.launchPath = cmd
    task.arguments = args
    //task.arguments("vms list")
    let outpipe = Pipe()
    task.standardOutput = outpipe
    let errpipe = Pipe()
    task.standardError = errpipe

    task.launch()

    let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
    if var string = String(data: outdata, encoding: .utf8) {
        string = string.trimmingCharacters(in: .newlines)
        output = string.components(separatedBy: "\n")
    }

    let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
    if var string = String(data: errdata, encoding: .utf8) {
        string = string.trimmingCharacters(in: .newlines)
        error = string.components(separatedBy: "\n")
    }

    task.waitUntilExit()
    let status = task.terminationStatus

    return (output, error, status)
}

print("Hello, World!")
/*
let (output, error, status) = runCommand(cmd: "/usr/local/bin/VBoxManage", args: "")

print("program exited with status \(status)")
if output.count > 0 {
    print("program output:")
    print(output)
}
if error.count > 0 {
    print("error output:")
    print(error)
}
*/

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


