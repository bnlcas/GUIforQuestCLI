//
//  ContentView.swift
//  GUIforQuestCLI
//
//  Created by Benjamin Lucas on 2/28/23.
//

import SwiftUI

struct ContentView: View {
    let speechURL = URL(fileURLWithPath: "/usr/bin/say")
    
    var body: some View {
        VStack {
            Text("Quest CLI → GUI")
            Button {
                
                try! Process.run(speechURL,
                                 arguments: ["Install Homebrew"],
                                     terminationHandler: nil)
            } label: {
                Text("Setup")
            }
            AdbCommandsView(revealTouchpadDropdown: false)
            ScrcpyConfigView(revealDropdown: false)
            Spacer()
        }
        .frame(maxWidth:300)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
