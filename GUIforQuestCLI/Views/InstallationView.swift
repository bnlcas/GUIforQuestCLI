//
//  InstallationView.swift
//  GUIforQuestCLI
//
//  Created by Benjamin Lucas on 3/7/23.
//

import SwiftUI

struct InstallationView: View {
    @Binding var isEnvironmentConfigured : Bool
            
    @State var outputMessage : String = "loading packages..."
    
    @State var isRunning = false

    let lsURL = URL(fileURLWithPath: "/bin/ls")
    let brewPath = "/opt/homebrew/bin/brew"
    let adbPath = "/opt/homebrew/bin/adb"
    let scrcpyPath = "/opt/homebrew/bin/scrcpy"
    
    func CheckInstallBrew()
    {
        outputMessage = "checking for homebrew..."
        let args = [brewPath]
        let task = Process()
        task.executableURL = lsURL
        task.arguments = args
        let connection = Pipe()
        task.standardOutput = connection
        task.terminationHandler = { _ in
            let outputData = connection.fileHandleForReading.readDataToEndOfFile()
            let output = String(decoding: outputData, as: UTF8.self)
            let outputTrim = output.trimmingCharacters(in: .whitespacesAndNewlines)
            print(outputTrim)
            let isHomebrewInstalled = (outputTrim == brewPath)
            if(!isHomebrewInstalled)
            {
                outputMessage = "installing homebrew..."
                InstallBrew()
            }
            else
            {
                CheckInstallADB()
            }
        }
        try! task.run()
    }
    
    func InstallBrew()
    {
        outputMessage = "installing homebrew..."
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "bin/bash")
        let args = ["-c", "\"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""]


        task.arguments = args
        let connection = Pipe()
        task.standardOutput = connection
        task.terminationHandler = { _ in
            let outputData = connection.fileHandleForReading.readDataToEndOfFile()
            let output = String(decoding: outputData, as: UTF8.self)
            print(output)

            outputMessage = "homebrew installed"
            CheckInstallADB()
        }
        try! task.run()
    }
    
    func CheckInstallADB()
    {
        outputMessage = "checking for adb..."
        let args = [adbPath]
        let task = Process()
        task.executableURL = lsURL
        task.arguments = args
        let connection = Pipe()
        task.standardOutput = connection
        task.terminationHandler = { _ in
            let outputData = connection.fileHandleForReading.readDataToEndOfFile()
            let output = String(decoding: outputData, as: UTF8.self)
            let outputTrim = output.trimmingCharacters(in: .whitespacesAndNewlines)
            let isADBInstalled = (outputTrim == adbPath)
            if(!isADBInstalled)
            {
                InstallADB()
            }
            else
            {
                CheckInstallScrcpy()
            }
        }
        try! task.run()
    }
    
    func InstallADB()
    {
        outputMessage = "installing adb..."
        
        let args = ["install", "android-platform-tools"]
        let task = Process()
        task.executableURL = URL(fileURLWithPath: brewPath)
        task.arguments = args
        let connection = Pipe()
        task.standardOutput = connection
        task.terminationHandler = { _ in
            let outputData = connection.fileHandleForReading.readDataToEndOfFile()
            let output = String(decoding: outputData, as: UTF8.self)
            print(output)

            outputMessage = "adb installed"
            CheckInstallScrcpy()
        }
        try! task.run()
    }
    
    func CheckInstallScrcpy(){
        outputMessage = "checking for scrcpy..."
        let args = [scrcpyPath]
        let task = Process()
        task.executableURL = lsURL
        task.arguments = args
        let connection = Pipe()
        task.standardOutput = connection
        task.terminationHandler = { _ in
            let outputData = connection.fileHandleForReading.readDataToEndOfFile()
            let output = String(decoding: outputData, as: UTF8.self)
            let outputTrim = output.trimmingCharacters(in: .whitespacesAndNewlines)
            let isScrpyInstalled = (outputTrim == scrcpyPath)
            if(!isScrpyInstalled)
            {
                outputMessage = "installing scrcpy..."
                InstallScrcpy()
            }
            else
            {
                FinalizeSetup()
            }
        }
        try! task.run()
    }
    
    func InstallScrcpy(){
        outputMessage = "installing scrcpy..."
        
        let args = ["install", "scrcpy"]
        let task = Process()
        task.executableURL = URL(fileURLWithPath: brewPath)
        task.arguments = args
        let connection = Pipe()
        task.standardOutput = connection
        task.terminationHandler = { _ in
            let outputData = connection.fileHandleForReading.readDataToEndOfFile()
            let output = String(decoding: outputData, as: UTF8.self)
            print(output)

            outputMessage = "scrcpy installed"
            FinalizeSetup()
        }
        try! task.run()
    }
   
    
    func SetupEnvironment()
    {
        self.isRunning = true
        CheckInstallBrew()
    }
    
    func FinalizeSetup(){
        self.isRunning = false
        self.isEnvironmentConfigured = true
        UserDefaults.standard.set(true, forKey: "isConfigured")
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5){
            Divider()
            Button {
                if(!self.isRunning)
                {
                    SetupEnvironment()
                }
            } label: {
                Image(systemName: "laptopcomputer.and.arrow.down")
                    .foregroundColor(self.isRunning ? .gray : .white)
                Text("Setup Environment")
                    .foregroundColor(self.isRunning ? .gray : .white)
            }
            
            if(self.isRunning)
            {
                Text(outputMessage)
                ProgressView()
            }
            Spacer()
        }
    }
}

struct InstallationView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationView(isEnvironmentConfigured: .constant(false))
    }
}
