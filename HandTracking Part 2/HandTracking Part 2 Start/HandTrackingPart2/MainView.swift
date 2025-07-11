//
//  MainView.swift
//  HandTrackingPart1
//
//  Created by Dat Nguyen on 12/3/24.
//

import SwiftUI

@main
struct MainView: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        ImmersiveSpace(id:"HandView"){
            HandView()
        }
    }
}
