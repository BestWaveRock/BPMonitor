//
//  BPMoniatorApp.swift
//  BPMoniator
//
//  Created by Yuki on 6/27/24.
//

import SwiftUI

@main
struct BPMoniatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ViewModel(viewController: ViewController()))
        }
    }
}
