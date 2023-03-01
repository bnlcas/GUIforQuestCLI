//
//  AdbCommandsView.swift
//  GUIforQuestCLI
//
//  Created by Benjamin Lucas on 2/28/23.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct AdbCommandsView: View {
    @State var isRunning : Bool = false
    let adbURL = URL(fileURLWithPath: "/opt/homebrew/bin/adb")
    
    @State var touchX : Double = 0.0
    @State var touchY : Double = 0.0
    
    @State var apkFilename = "tmp.apk"
    let apkType = UTType("com.app.apk")
    
    @State var revealTouchDropdown : Bool = true
    @State private var isDropdownHighlighted : Bool = false

    func LaunchAPK()
    {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
       
        panel.allowedContentTypes = [apkType!]     //UTType. UTType.epub]
        //"com.android.package-archive"
        if panel.runModal() == .OK {
            self.apkFilename = panel.url!.path()
        }
        
        let args = ["install", "-r", self.apkFilename]
        
        let task = Process()
        task.executableURL = adbURL
        task.arguments = args

        let connection = Pipe()
        task.standardOutput = connection
        self.isRunning = true
        task.terminationHandler = { _ in self.isRunning = false}
        try! task.run()
    }
    
    func TapEvent()
    {
        try! Process.run(adbURL,
                         arguments: ["shell", "input", "tap", String(touchX), String(touchY)],
                             terminationHandler: nil)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Divider()
            DeviceConnectedView()
            Spacer().frame(width: 15, height: 5)

            HStack{
            Button {
                if(!self.isRunning)
                {
                    LaunchAPK()
                }
            } label: {
                    Text("Launch APK")
                }
                if(self.isRunning){
                    ProgressView()
                }
            }
            
            DisclosureGroup(isExpanded: $revealTouchDropdown, content: {
                VStack (alignment: .leading) {
                    Button {
                        if(!self.isRunning)
                        {
                            TapEvent()
                        }
                    } label: {
                        Text("Tap Event")
                    }
                    HStack(alignment: .center)
                    {
                        Text("Tap X: \(Int(touchX))")
                        Slider(value: $touchX, in: 0...1440)
                    }
                    HStack(alignment: .center)
                    {
                        Text("Tap Y: \(Int(touchY))")
                        Slider(value: $touchY, in: 0...1440)
                    }
                }
                 //   .tint(.blue)
                
            }, label: {
                HStack(alignment: .center, spacing: 5){
                    Spacer().frame(width: 5, height: 5)
                    Image(systemName: "hand.point.up")
                        .frame(width: 32.0, height: 32.0)
                        .foregroundColor(isDropdownHighlighted ? .blue : .none)
                        .scaledToFit()

                    Text("Touch Input")
                        .foregroundColor(isDropdownHighlighted ? .blue : .none)
                    Spacer()
                }
                .onHover(perform: { isHover in
                    isDropdownHighlighted = isHover})
            })
            .disclosureGroupStyle(LabelToggleDisclosureGroupStyle(arrowColor: isDropdownHighlighted ? .blue : .gray))
        }
    }
}

struct AdbCommandsView_Previews: PreviewProvider {
    static var previews: some View {
        AdbCommandsView()
    }
}

