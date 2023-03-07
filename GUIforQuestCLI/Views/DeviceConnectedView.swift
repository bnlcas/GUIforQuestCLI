//
//  DeviceConnectedView.swift
//  GUIforQuestCLI
//
//  Created by Benjamin Lucas on 2/28/23.
//

import SwiftUI

struct DeviceConnectedView: View {
    let adbURL = URL(fileURLWithPath: "/opt/homebrew/bin/adb")

    @State var isConnected : Bool = false;
    
    @State var isRunning : Bool = false;
    
    init()
    {
        self.CheckConnection()
    }
    
    func CheckConnection()
    {
        let args = ["devices"]
        let task = Process()
        task.executableURL = adbURL
        task.arguments = args
        let connection = Pipe()
        task.standardOutput = connection
        self.isRunning = true
        task.terminationHandler = { _ in
            self.isRunning = false
            
            let outputData = connection.fileHandleForReading.readDataToEndOfFile()
            let output = String(decoding: outputData, as: UTF8.self)
            self.isConnected = ((output.count) > 26)
        }
        try! task.run()
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .center, spacing: 5){
                Spacer().frame(width: 5, height: 5)
                Image(systemName: self.isConnected ? "bolt.fill" : "bolt.slash.fill")
                    .frame(width: 32.0, height: 32.0)
                    .scaledToFit()
                
                Text("Device \(self.isConnected ? "Connected" : "Disconnected")")
                if(self.isRunning)
                {
                    ProgressView()
                }
                Spacer()
            }
            Button {
                CheckConnection()
            } label: {
                    Text("Check Connection")
            }
        }
    }
}

struct DeviceConnectedView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceConnectedView()
    }
}
