import Foundation

public protocol Database: Codable {}

public protocol Store: ObservableObject {
    associatedtype DB: Database
    func save() throws
    func load() throws
    var db: DB! { get set }
    var dbPublished: Published<DB?> { get }
    var dbPublisher: Published<DB?>.Publisher { get }
}

public final class MemoryStore<DB>: Store where DB: Database {
    @Published public var db: DB! {
        didSet { try? save() }
    }
    public var dbPublished: Published<DB?> { _db }
    public var dbPublisher: Published<DB?>.Publisher { $db }
    
    public init(_ initialState: DB) {
        db = initialState
    }
    
    public func save() throws {}
    
    public func load() throws {}
}

public final class FileStore<DB>: Store where DB: Database {
    @Published public var db: DB! = nil {
        didSet { try? save() }
    }
    public var dbPublished: Published<DB?> { _db }
    public var dbPublisher: Published<DB?>.Publisher { $db }
    
    public let file: URL
    public let decode: (Data) throws -> DB
    public let encode: (DB) throws -> Data
    
    public init(_ initialState: DB,
                file: URL = FileManager.default
                    .urls(for: .documentDirectory, in: .userDomainMask).first!
                    .appendingPathComponent("\(DB.self).json"),
                decode: @escaping (Data) throws -> DB = { try JSONDecoder().decode(DB.self, from: $0) },
                encode: @escaping (DB) throws -> Data = JSONEncoder().encode) throws {
        (self.file, self.decode, self.encode) = (file, decode, encode)
        if !FileManager.default.fileExists(atPath: file.path) {
            db = initialState
            try save()
        }
        try load()
    }
    
    public func save() throws {
        if db == nil {
            try load()
        }
        try encode(db).write(to: file)
    }
    
    public func load() throws {
        db = try decode(Data(contentsOf: file))
    }
}
