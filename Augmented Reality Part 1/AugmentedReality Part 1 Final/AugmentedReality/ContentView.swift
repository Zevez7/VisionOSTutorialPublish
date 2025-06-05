//
//  ContentView.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 2/3/25.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {
        VStack {
            Text("Augmented Reality Tutorial")
                .font(.largeTitle)
                .onAppear{
                    Task {
                        await openImmersiveSpace(id:"immersive")
                    }
                }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
