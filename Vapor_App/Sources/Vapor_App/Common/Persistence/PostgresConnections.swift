//
//  PostgresConnections.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 20/08/25.
//

import PostgresNIO

enum PostgresConnections {
    // MARK: - PostgresNIO Connection (SQL oriented)
    static func createDevelopmentsConnectionUsingNIO() -> PostgresClient {
        return PostgresClient(
            configuration: .init(
                host: "localhost",
                username: "app",
                password: "pwd",
                database: "appdb",
                tls: .prefer(.clientDefault)
            )
        )
    }
    
    @discardableResult
    static func startPostgresClient(_ client: PostgresClient) -> Task<(), Never> {
        return Task {
            await client.run()
        }
    }
        
    static func stopPostgresClient(_ task: Task<(), Never>) {
        task.cancel()
    }
    
    // MARK: - Fluent Connection (Managed state oriented)
}
