import Foundation

public final class AnyStore<DB: Database>: Store {
    public func save() throws {
        try self.storeSave()
    }
    
    public func load() throws {
        try self.storeLoad()
    }
    
    let store: Any
    let storeSave: () throws -> Void
    let storeLoad: () throws -> Void
    
    @Published public var db: DB!
    public var dbPublished: Published<DB?> { _db }
    public var dbPublisher: Published<DB?>.Publisher { $db }
    
    public init<S>(erasing store: S) where S: Store, S.DB == DB {
        self.store = store
        self.storeSave = store.save
        self.storeLoad = store.load
        self.db = store.db
    }
    
    public convenience init<S>(_ store: S) where S: Store, S.DB == DB {
        self.init(erasing: store)
    }
}
