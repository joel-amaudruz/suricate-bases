//
//  MockEventGenerator.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 19/08/25.
//

import Foundation

actor MockEventGenerator {
    let messenger: NatsMessagingService
    var timer: Timer?
    
    init(messenger: NatsMessagingService) {
        self.messenger = messenger
        Task {
            await messenger.subscribe(to: "foo.bar")
        }
    }
    
    func start() {
        timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] timer in
            Task { [weak self] in
                print("inside timer")
                guard let self else { return }
                let randomNumber = Int.random(in: 1...1000)
                
                await self.messenger.publish("\(randomNumber)", to: "foo.bar")
            }
        }
        if let newTimer = timer {
            RunLoop.main.add(newTimer, forMode: .common)
        }
    }
}
