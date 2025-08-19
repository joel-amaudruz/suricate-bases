import Vapor
import Logging
import NIOCore
import NIOPosix
import SwiftyNats
import Fluent

@main
enum Entrypoint {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        
        let app = try await Application.make(env)

        // This attempts to install NIO as the Swift Concurrency global executor.
        // You can enable it if you'd like to reduce the amount of context switching between NIO and Swift Concurrency.
        // Note: this has caused issues with some libraries that use `.wait()` and cleanly shutting down.
        // If enabled, you should be careful about calling async functions before this point as it can cause assertion failures.
        // let executorTakeoverSuccess = NIOSingletons.unsafeTryInstallSingletonPosixEventLoopGroupAsConcurrencyGlobalExecutor()
        // app.logger.debug("Tried to install SwiftNIO's EventLoopGroup as Swift's global concurrency executor", metadata: ["success": .stringConvertible(executorTakeoverSuccess)])
        
        testNATS()
        do {
            try await configure(app)
            try await app.execute()
        } catch {
            app.logger.report(error: error)
            try? await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
}

private func testNATS() {
    // register a new client
//    let natsURL = URL(string: "nats://localhost:4222")!
    let client = NatsClient("nats://localhost:4222")
    
    // listen to an event
    client.on(.connected) { _ in
        print("Client connected")
    }
    
    // try to connect to the server
    try? client.connect()
    
    // subscribe to a channel with a inline message handler.
    client.subscribe(to: "foo.bar") { message in
        print("payload: \(message.payload ?? "failed!")")
        print("size: \(message.byteCount ?? 0)")
        print("subject: \(message.subject.subject)")
        print("reply subject: \(message.replySubject?.subject ?? "none")")
    }
    
    // publish an event onto the message strem into a subject
    client.publish("this event happened", to: "foo.bar")

}
