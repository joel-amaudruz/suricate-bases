//
//  NatsMessaging.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 19/08/25.
//

import SwiftyNats

struct NatsMessagingService {
    private let myClient: NatsClient
    
    init() throws {
        // register a new client
        myClient = NatsClient("nats://localhost:4222")
        
        // listen to an event
        myClient.on(.connected) { _ in
            print("Client connected")
        }
        
        // try to connect to the server
        try myClient.connect()
    }
    
    func subscribe(to subject: String) {
        // subscribe to a channel with a inline message handler.
        myClient.subscribe(to: subject) { message in
            print("payload: \(message.payload ?? "failed!")")
            print("size: \(message.byteCount ?? 0)")
            print("subject: \(message.subject.subject)")
            print("reply subject: \(message.replySubject?.subject ?? "none")")
        }
    }
    
    func publish(_ msg: String, to subject: String) {
        // publish an event onto the message strem into a subject
        myClient.publish(msg, to: subject)
    }
}
