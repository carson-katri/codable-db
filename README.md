# CodableDB

A simple database using `Codable`.

1. Declare your models

```swift
struct User: Codable, Equatable {
  let id: Int
  let username: String
  let first: String
  let last: String
}
```

2. Create a `Database`

```swift
struct TestDB: Database {
  var users: [User]
  
  init(users: [User] = []) { self.users = users }
}
```

3. Use a `Store` to read/write the data

```swift
// MemoryStore does not persist between app runs.
let store = MemoryStore(TestDB())
store.db.users // [User]

// FileStore keeps the data in a file (defaults to <documentDirectory>/<Database type name>.json)
let store = FileStore(TestDB())
store.db.users // [User]
```

You can also specify the file URL, decoder, and encoder of `FileStore`:

```swift
FileStore(
  TestDB(),
  file: URL("myFile.json"),
  decode: { try XMLDecoder().decode(TestDB.self, from: $0) },
  encode: XMLEncoder().encode
)
```
