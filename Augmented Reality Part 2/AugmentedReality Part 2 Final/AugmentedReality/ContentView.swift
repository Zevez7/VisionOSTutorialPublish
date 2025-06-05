//
//  ContentView.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 1/28/25.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(ARClass.self) var arClass
    @Environment(\.openWindow) var openWindow


    var body: some View {
        VStack {
            Text("Augmented Reality Tutorial").font(.largeTitle).onAppear{
                Task {
                    await openImmersiveSpace(id:"immersive")
                    openWindow(id: "menu")
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(ARClass())
}
