//
//  MainApp.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 2/3/25.
//

import SwiftUI


@main
struct MainApp: App {
    
    @State private var arClass = ARClass()
    var body: some Scene {
        WindowGroup {
            ContentView().environment(arClass)
        }
        
        ImmersiveSpace(id:"immersive"){
            ImmersiveView().environment(arClass)
        }
    }
}
