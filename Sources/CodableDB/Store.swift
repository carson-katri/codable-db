import Foundation

public protocol Store: ObservableObject {
    associatedtype DB: Database
    func save() throws
    func load() throws
    var db: DB! { get set }
    var dbPublished: Published<DB?> { get }
    var dbPublisher: Published<DB?>.Publisher { get }
}
