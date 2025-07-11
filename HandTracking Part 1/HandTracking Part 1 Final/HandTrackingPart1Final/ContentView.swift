//
//  ContentView.swift
//  HandTrackingPart1Final
//
//  Created by Dat Nguyen on 12/3/24.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ContentView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {

        Text("Hand Tracking Tutorial Part 1")
            .font(.largeTitle)
            .onAppear {
                Task {
                    await openImmersiveSpace(id: "HandView")
                }
            }
    }
}

//#Preview(windowStyle: .automatic) {
//    ContentView()
//}
