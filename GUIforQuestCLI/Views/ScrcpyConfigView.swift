//
//  ScrcpyConfigView.swift
//  GUIforQuestCLI
//
//  Created by Benjamin Lucas on 2/28/23.
//

import SwiftUI

struct ScrcpyConfigView: View {
    @State var revealDropdown = true

    @State private var isHighlighted : Bool = false
        
    let scrcpyURL = URL(fileURLWithPath: "/opt/homebrew/bin/scrcpy")
    let adbPath = "/opt/homebrew/bin/adb"

    @State private var maxfps : Double = 30
    @State private var bitRate : Double = 25
    @State private var cropMonocular : Bool = true
    
    //scrcpy -b 10M --crop 1360:1540:60:60 --max-fps 30
    
    
    func LaunchScreenCopy()
    {

        var args : [String] = ["-b", String(Int(bitRate)) + "M", "--max-fps", String(Int(maxfps))]
        if(cropMonocular){
            print("mono")
            args.append("--crop")
            args.append("1360:1540:60:60")
        }
        print(args)
        
        var task = Process()

        task.executableURL = scrcpyURL
        task.arguments = args
        task.environment = ["ADB": adbPath]


        let connection = Pipe()
        task.standardOutput = connection
        try! task.run()
        //try! Process.run(scrcpyURL,                                         arguments: args, terminationHandler: nil)
    }
    
    var body: some View {
        Divider()
        VStack(alignment: .leading, spacing: 5){
            Spacer().frame(width: 15, height: 5)
            Button {
                LaunchScreenCopy()
            } label: {
                Image(systemName: "play.display")
                Text("Start Scrcpy")
            }

            DisclosureGroup(isExpanded: $revealDropdown, content: {
                VStack (alignment: .leading) {
                    Text("Bit Rate (MBPS): \(Int(bitRate))")
                    Slider(value: $bitRate, in: 1...30)
                    Text("Frame Rate (FPS): \(Int(maxfps))")
                    Slider(value: $maxfps, in: 1...30)
                    Toggle("Crop Monocular", isOn: $cropMonocular).toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                 //   .tint(.blue)
                
            }, label: {
                HStack(alignment: .center, spacing: 5){
                    Spacer().frame(width: 5, height: 5)
                    Image(systemName: "play.display")
                        .frame(width: 32.0, height: 32.0)
                        .foregroundColor(isHighlighted ? .blue : .none)
                        .scaledToFit()

                    Text("Screen Copy (scrcpy) Settings")
                        .foregroundColor(isHighlighted ? .blue : .none)
                    Spacer()
                }
                .onHover(perform: { isHover in
                    isHighlighted = isHover})
            })
            .disclosureGroupStyle(LabelToggleDisclosureGroupStyle(arrowColor: isHighlighted ? .blue : .gray))
        }
    }
}

struct ScrcpyConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ScrcpyConfigView(revealDropdown: true)
    }
}


struct LabelToggleDisclosureGroupStyle: DisclosureGroupStyle {
    var arrowColor : Color
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        configuration.isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: configuration.isExpanded ? "chevron.down" : "chevron.right").frame(width:8, height: 8)
                }.buttonStyle(.plain).font(.footnote).fontWeight(.semibold).foregroundColor(arrowColor)
                configuration.label.onTapGesture {
                    withAnimation {
                        configuration.isExpanded.toggle()
                    }
                }
                Spacer()
            }
            if configuration.isExpanded {
                configuration.content
            }
        }
    }
}
