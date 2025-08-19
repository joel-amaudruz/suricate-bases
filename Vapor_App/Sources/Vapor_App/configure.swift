import Vapor
import PostgresKit
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    try connectToDatabase(app)

    // register routes
    try routes(app)
}

private func connectToDatabase(_ app: Application) throws {
    app.databases.use(
        DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: "localhost",
        port: SQLPostgresConfiguration.ianaPortNumber,
        username: "app",
        password: "pwd",
        database: "appdb",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    print("db connected: \(app.databases.ids())")
}
