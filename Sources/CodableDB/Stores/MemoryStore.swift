import Foundation

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
