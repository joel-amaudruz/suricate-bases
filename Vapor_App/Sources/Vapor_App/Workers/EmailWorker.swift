//
//  EmailWorker.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 21/08/25.
//

import RxSwift

struct EmailWorker {
    let bag = DisposeBag()

    func start(with nats: NatsMessagingService) {
        nats.observable(for: SuricateCry.CryChannel)
            .subscribe(onNext: { msg in
                if let cry = extractCry(from: msg),
                   cry.action == .emailNotification {
                    pretendToSendEmail(to: cry)
                }
            })
            .disposed(by: bag)
    }
    
    private func extractCry(from msg: NatsMessage) -> SuricateCry? {
        do {
            let cry = try SuricateCry(with: msg.payload)
            return cry
        } catch {
            return nil
        }
    }
    
    private func pretendToSendEmail(to info: SuricateCry) {
        print("Would have sent an email now\n  to address: \(info.destination!)\n  with message: \(info.message!)")
    }

}
