//
//  ContentView.swift
//  GUIforQuestCLI
//
//  Created by Benjamin Lucas on 2/28/23.
//

import SwiftUI

struct ContentView: View {
    @State var isEnvironmentConfigured = UserDefaults.standard.bool(forKey: "isConfigured") ?? false
    
    var body: some View {
        VStack {
            Text("Quest CLI → GUI")
            if(isEnvironmentConfigured){
                VStack {
                    AdbCommandsView(revealTouchpadDropdown: false)
                    ScrcpyConfigView(revealDropdown: false)
                    Spacer()
                }

            }
            else
            {
                InstallationView(isEnvironmentConfigured: $isEnvironmentConfigured)
            }
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
