//
//  MenuView.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 1/29/25.
//

import SwiftUI
import RealityKit

struct MenuView: View {
    @Environment(ARClass.self) var arClass
    @Environment(MenuClass.self) var menuClass

    public var body: some View {

        Text("MENU").padding(20).font(
            .system(size: 40))

        HStack {
            VStack {

                ButtonView(
                    title: "MODEL",
                    name: "MODEL")
                
                ButtonView(
                    title: "TOYBIPLANE",
                    name: "ToyBiplane",
                    arScale: 3,
                    menuScale: 0.8)
                
                ButtonView(
                    title: "TOYROCKET",
                    name: "ToyRocket",
                    arScale: 3,
                    menuScale: 0.6)
                
                ButtonView(
                    title: "DRUMKIT",
                    name: "DrumKit",
                    arScale: 0.5,
                    menuScale: 0.2)

                ButtonView(
                    title: "GUITAR",
                    name: "AcousticGuitar",
                    arScale: 0.7,
                    menuScale: 0.25)

                Spacer()
                if menuClass.selectedModel != "MODEL" {
                    let selectedModel = menuClass.selectedModel
                    HStack {
                        ScaleButton()
                    }

                    HStack {
                        RotateButton()
                    }
                }

            }.padding()
            
            VStack {

                Text(menuClass.selectedModel).padding(20).font(
                    .system(size: 80))
                Spacer()
                RealityView { content in
                    content.add(menuClass.rootEntity)
                }

            }.padding()
        }.padding()

    }

}

#Preview(windowStyle: .automatic) {
    MenuView().environment(ARClass()).environment(MenuClass())
}
