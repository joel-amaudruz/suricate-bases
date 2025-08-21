//
//  IntegrationTests.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 19/08/25.
//

@testable import Vapor_App
import VaporTesting
import Testing
import RxSwift

@Suite("Integration Tests")
struct IntegrationTests {
    @Test("Test Nats Connection")
    func natsMessagingConnectionTest() throws {
        let messenger = try? NatsMessagingService()
        
        #expect(messenger != nil)
    }
    
    @Test("Test Nats Messaging")
    func natsMessagingListeningTest() async throws {
        let messenger = try! NatsMessagingService()
        let dispose = DisposeBag()
        
        let pub = messenger.subscribe(to: "test")
        
        pub
            .subscribe(onNext: { msg in
                #expect(msg.payload == "bang!")
            })
            .disposed(by: dispose)
        
        messenger.publish("bang!", to: "test")
        messenger.publish("bang!", to: "test")
    }
}
