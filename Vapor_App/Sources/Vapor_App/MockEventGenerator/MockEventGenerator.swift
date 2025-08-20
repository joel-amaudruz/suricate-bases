//
//  MockEventGenerator.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 19/08/25.
//

import Foundation

actor MockEventGenerator {
    let messenger: NatsMessagingService
    let subject = "event.integer.mock"
    var timer: Timer?
    
    init(messenger: NatsMessagingService) {
        self.messenger = messenger
        Task {
            await messenger.subscribe(to: "foo.bar")
        }
    }
    
    private func createAndSendMockEvent() async {
        let randomNumber = Int.random(in: 1...1000)
        let event = IntegerEvent(value: randomNumber)
        
        do {
            let message = try event.jsonString()
            await messenger.publish(message, to: subject)
        } catch {
            print("Error in creating mock event message: \(error)")
        }
        
    }

    func start() {
        guard timer == nil else { return }
        timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] timer in
            Task { [weak self] in
                guard let self else { return }
                await self.createAndSendMockEvent()
            }
        }
        if let newTimer = timer {
            RunLoop.main.add(newTimer, forMode: .common)
        }
    }
    
    func stop() {
        timer?.invalidate()
    }
}
