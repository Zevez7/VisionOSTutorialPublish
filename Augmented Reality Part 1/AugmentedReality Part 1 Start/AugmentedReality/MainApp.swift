//
//  MainApp.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 2/3/25.
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
