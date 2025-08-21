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
    
    init(modulus: Int) {
        self.modulus = modulus
    }
    
    func start(with nats: NatsMessagingService) {
        nats.observable(for: integerSubject)
            .subscribe(onNext: { [self] msg in
                if let value = extractIntegerFrom(msg),
                    value.isMultiple(of: modulus) {
                    doSomethingWith(value)
                }
            })
            .disposed(by: bag)
    }
    
    internal func extractIntegerFrom(_ msg: NatsMessage) -> Int? {
        let data = msg.payload.data(using: .utf8)!
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            return json["value"] as? Int
        } catch {
            return nil
        }
    }
    
    internal func doSomethingWith(_ value: Int) {
        print("bingo! \(value)")
    }
}
