//
//  main.swift
//  execShell
//
//  Created by Holger Banko on 14/12/19.
//  Copyright © 2019 Holger Banko. All rights reserved.
//

import Foundation

func matches(for regex: String, in text: String) -> [String] {

    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

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

let matched = matches(for: "\"(.*?)\"",in: output)
print(matched[1].replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil))

// Filter with Regex "(.*?)"


