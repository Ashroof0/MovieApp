//
//  NetworkMonitor.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 02/10/2024.
//

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor: NWPathMonitor
    private(set) var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            print("Network status changed: \(self?.isConnected == true ? "Connected" : "Disconnected")")
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func reset() {
        isConnected = false
    }
}
