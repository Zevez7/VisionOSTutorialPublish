//
//  AugmentedRealityApp.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 1/28/25.
//

import SwiftUI

@main
struct MainApp: App {

    @State private var arClass = ARClass()
    @State private var menuClass = MenuClass()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(arClass).environment(menuClass)
        }
        
        WindowGroup(id:"menu") {
            MenuView().environment(arClass).environment(menuClass)
        }
        
        ImmersiveSpace (id:"immersive"){
            ImmersiveView().environment(arClass).environment(menuClass)
            
        }

    }
}
