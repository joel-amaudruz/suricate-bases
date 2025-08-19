//
//  MockEventGenerator.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 19/08/25.
//

struct MockEventGenerator {
    let messenger: NatsMessagingService
    
    func start() {
        messenger.subscribe(to: "foo.bar")
        messenger.publish("this event happened", to: "foo.bar")
    }
}
