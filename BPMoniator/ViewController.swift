//
//  ViewController.swift
//  BPMoniator
//
//  Created by Yuki on 6/27/24.
//

import Foundation
import SwiftUI
import Cocoa
import Foundation

class ViewController: NSViewController {
    @State public var respJson = ""
    @IBOutlet weak var responseTextView: NSTextView!
    @IBOutlet weak var currentTimeLabel: NSTextField!
    @IBOutlet weak var heartbeatLabel: NSTextField!

    var webSocketTask: URLSessionWebSocketTask?
    var lastHeartbeatTime: Date?
    var heartbeatTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectToWebSocket()
        setupHeartbeatTimer()
    }
    
//    var body: some View {
//        VStack {
//            Text(responseTextView.string)
//        }
//        .padding()
//    }
    
    var getRespJson: String {
        get {
            return self.respJson
        }
        // 如果需要，可以添加 set 访问器来定义属性的设置逻辑
    }

    func connectToWebSocket() {
        guard let url = URL(string: "wss://dev.pulsoid.net/api/v1/data/real_time?access_token=4b835c8d-e36e-4ccf-a1c4-bc51d1a3b0b5&response_mode=legacy_json") else {
            return
        }
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
        webSocketTask = session.webSocketTask(with: url)
        
        webSocketTask?.resume()
        
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket error: \(error)")
            case .success(let message):
                DispatchQueue.main.async {
                    self?.handleWebSocketMessage(message)
                }
            }
        }
    }
    
    func handleWebSocketMessage(_ message: URLSessionWebSocketTask.Message) {
        print(message)
        switch message {
        case .string(let text):
            responseTextView.string = text
            respJson += text
            // 根据实际的响应格式解析和更新 UI
        case .data(let data):
            // 如果消息是二进制数据，可能需要解析 JSON 或其他格式
            if let text = String(data: data, encoding: .utf8) {
                responseTextView.string = text
                respJson += text
            }
        @unknown default:
            fatalError()
        }
    }
    
    let handleWebSocketMessage: (String) -> URLSessionWebSocketTask.Message = { message in
        // 根据接收到的字符串消息返回某种处理结果
        return .string(message) // 假设我们只是简单地将字符串包装成 URLSessionWebSocketTask.Message
    }

    func setupHeartbeatTimer() {
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateHeartbeat()
        }
    }

    func updateHeartbeat() {
        let currentTime = Date()
        currentTimeLabel.stringValue = "\(currentTime)"
        if let lastHeartbeat = lastHeartbeatTime {
            let timeInterval = currentTime.timeIntervalSince(lastHeartbeat)
            heartbeatLabel.stringValue = String(format: "%.2f seconds", timeInterval)
        } else {
            heartbeatLabel.stringValue = "No heartbeat yet"
        }
        lastHeartbeatTime = currentTime
    }

    func disconnectWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    deinit {
        heartbeatTimer?.invalidate()
    }
}
