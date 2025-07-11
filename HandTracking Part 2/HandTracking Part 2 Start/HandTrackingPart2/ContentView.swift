//
//  ContentView.swift
//  HandTrackingPart1
//
//  Created by Dat Nguyen on 12/3/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openImmersiveSpace)var openImmersiveSpace
    var body: some View {

        Text("Hand Tracking Tutorial Part 1")
            .font(.largeTitle)
            .onAppear{
                Task{
                    await openImmersiveSpace(id:"HandView")
                }
            }

    }

}
#Preview(windowStyle:.automatic) {
    ContentView()
}
