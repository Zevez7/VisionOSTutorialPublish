//
//  ContentView.swift
//  GestureControl
//
//  Created by Dat Nguyen on 12/20/24.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ContentView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {
        VStack {

            Text("Hello, world!").font(.system(size: 60, weight: .bold))
        }
        .padding()
        .task {
            await openImmersiveSpace(id: "immersive")
        }

    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
