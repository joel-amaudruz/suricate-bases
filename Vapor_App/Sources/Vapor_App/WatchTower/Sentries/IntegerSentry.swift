//
//  IntegerSentry.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 21/08/25.
//

import RxSwift
import Foundation

struct IntegerSentry {
    let modulus: Int
    let integerSubject = "event.integer.mock"
    let bag = DisposeBag()
    var messenger: NatsMessagingService?
    
    init(modulus: Int) {
        self.modulus = modulus
    }
    
    mutating func start(with nats: NatsMessagingService) {
        messenger = nats
        nats.observable(for: integerSubject)
            .subscribe(onNext: { [self] msg in
                if let value = extractInteger(from: msg),
                    value.isMultiple(of: modulus) {
                    doSomethingWith(value)
                }
            })
            .disposed(by: bag)
    }
    
    internal func extractInteger(from msg: NatsMessage) -> Int? {
        let data = msg.payload.data(using: .utf8)!
        do {
            let integerMsg = try IntegerEvent.decoder
                .decode(IntegerEvent.self, from: data)
            return Int(integerMsg.value)
        } catch {
            return nil
        }
    }
    
    internal func doSomethingWith(_ value: Int) {
        guard let messenger = messenger else { return }
        let cry = SuricateCry(action: .emailNotification, message: "\(value) is a multiple of \(modulus)", destination: "someone@somewhere.com")
        guard let cryStr = try? cry.jsonString() else { return }
        
        messenger.publish(cryStr, to: SuricateCry.CryChannel)
    }
}
