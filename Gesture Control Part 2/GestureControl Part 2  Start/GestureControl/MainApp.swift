//
//  GestureControlApp.swift
//  GestureControl
//
//  Created by Dat Nguyen on 12/20/24.
//

import SwiftUI
			

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        ImmersiveSpace(id:"immersive"){
            ImmersiveView()
        }
    }
}
