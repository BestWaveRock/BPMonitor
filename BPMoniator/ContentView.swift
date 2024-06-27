//
//  ContentView.swift
//  BPMoniator
//
//  Created by Yuki on 6/27/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var text = "点击以加载数据"
    @State private var count: Int = 0
    @State private var showCountAlert = false
    @EnvironmentObject var viewModel: ViewModel
    
//    var modelText: some View{
//        Text(viewModel.respJson)
//    }
    
    var body: some View {
        VStack {
            Text(text).padding()
            Text("点击次数:\(count)").padding()
            Button("开始获取BPM数据") {
                self.text = viewModel.respJson
                
                self.count+=1
                self.showCountAlert = true
            }
            .alert(isPresented: $showCountAlert){
                Alert(title: Text("提示"),
                      message: Text("您已经点击了 \(self.count) 次。"),
                      primaryButton: .default(Text("好的"),  action: {
                    self.showCountAlert = false
                }),
                      secondaryButton: .default(Text("重置"), action: {
                    self.count = 0
                    self.showCountAlert = false
                }))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
