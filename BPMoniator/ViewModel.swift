//
//  ViewModel.swift
//  BPMoniator
//
//  Created by Yuki on 6/27/24.
//

import Foundation
import SwiftUI
import Combine

class ViewModel: ObservableObject {
    @Published public var respJson: String = ""
    var viewController: ViewController

    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    // 访问 IBOutlet 组件的方法
    func buttonText() {
        print("Hello, World!")
        self.respJson = viewController.getRespJson
    }
}
