//
// Copyright © 2021 An Tran. All rights reserved.
//

import Foundation

// Debouncer written instead of throtteling like here described: https://medium.com/@soxjke/property-wrappers-in-swift-5-1-297ae08fc7a0
// when using throtteling, if typing can’t fit in x seconds interval, two requests are fired to Github API and intermediate search results blink on screen
// to fix this behaviour, this can be done with debounce
class Debouncer<T> {
    private(set) var value: T?
    private var valueTimestamp = Date()
    private var interval: TimeInterval
    private var queue: DispatchQueue
    private var callbacks: [(T) -> Void] = []
    private var debounceWorkItem = DispatchWorkItem {}
    
    public init(_ interval: TimeInterval, on queue: DispatchQueue = .main) {
        self.interval = interval
        self.queue = queue
    }
    
    func receive(_ value: T) {
        self.value = value
        dispatchDebounce()
    }
    
    func on(throttled: @escaping (T) -> Void) {
        self.callbacks.append(throttled)
    }
    
    private func dispatchDebounce() {
        self.valueTimestamp = Date()
        self.debounceWorkItem.cancel()
        
        self.debounceWorkItem = DispatchWorkItem { [weak self] in
            self?.onDebounce()
        }
        
        queue.asyncAfter(deadline: .now() + interval, execute: debounceWorkItem)
    }
    
    private func onDebounce() {
        guard Date().timeIntervalSince(self.valueTimestamp) > interval else { return }
        sendValue()
    }
    
    private func sendValue() {
        guard let value = self.value else { return }
        callbacks.forEach { $0(value) }
    }
}
