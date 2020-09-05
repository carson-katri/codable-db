import XCTest
@testable import CodableDB

struct User: Codable, Equatable {
    let id: Int
    let username: String
    let first: String
    let last: String
}

struct TestDB: Database {
    var users: [User]
    
    init(users: [User] = []) { self.users = users }
}

final class CodableDBTests: XCTestCase {
    func testMemoryStore() {
        let store = MemoryStore(TestDB())
        let me = User(id: 0, username: "carsonkatri", first: "Carson", last: "Katri")
        store.db.users = [me]
        XCTAssertEqual(store.db.users.first { $0.username == "carsonkatri" }, me)
    }
    
    func testFileStore() throws {
        let store = try FileStore(TestDB())
        let me = User(id: 0, username: "carsonkatri", first: "Carson", last: "Katri")
        store.db.users = [me]
        XCTAssertEqual(store.db.users.first { $0.username == "carsonkatri" }, me)
        try store.load()
        XCTAssertEqual(store.db.users.first { $0.username == "carsonkatri" }, me)
    }

    static var allTests = [
        ("testMemoryStore", testMemoryStore),
        ("testFileStore", testFileStore),
    ]
}
