//
//  NatsMessaging.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 19/08/25.
//

import SwiftyNats
import RxSwift

struct NatsMessage {
    let payload: String
    let subject: String
    let replySubject: String?
}

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
    
    func subscribe(to subject: String, debug: Bool = false) -> Observable<NatsMessage> {
        let pub = PublishSubject<NatsMessage>()
        
        // subscribe to a channel with a inline message handler.
        myClient.subscribe(to: subject) { message in
            if debug {
                print("payload: \(message.payload ?? "failed!")")
                print("size: \(message.byteCount ?? 0)")
                print("subject: \(message.subject.subject)")
                print("reply subject: \(message.replySubject?.subject ?? "none")")
            }
            
            let msg = NatsMessage(payload: message.payload ?? "Failed!", subject: message.subject.subject, replySubject: message.replySubject?.subject)
            pub.onNext(msg)
        }
        return pub.asObservable()
    }
    
    func publish(_ msg: String, to subject: String) {
        // publish an event onto the message strem into a subject
        myClient.publish(msg, to: subject)
    }
}
