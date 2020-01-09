/*:
 # Generics
 
 This notebook follows the *Swift by Sundell* post ["Generics"](https://www.swiftbysundell.com/basics/generics/).
 */
 import UIKit
/*:
 Generic types, protocols, and functions are not tied to a specific type, but instead can be used by any type that meets a given set of criteria.
 For example, `Array` and `Dictionary` are both generics - they can store objects of any type.
 */
// Create and modify an array of type `[String]`.
var array = ["one", "two", "three"]
array.append("four")

// It is not possible to add an `Int` to `[String]`.
//array.append(5)  // Does not compile!

// We can extract each object in `array` and treat it like a `String`.
array[0].count
/*:
 Below is an example of creating a custom generic type.
 The  "type" `Value` will be assigned when an actual `Container` object is created.
 */
// A custom generic type.
struct Container<Value> {
    var value: Value
    var date: Date
}

// Passing a `String` for `Value`.
let stringContainer = Container(value: "Message", date: Date())
type(of: stringContainer.value)

// Passing an `Int` for `Value`.
let intContainer = Container(value: 7, date: Date())
type(of: intContainer.value)
/*:
 Generics are most useful when applied to code that should work for various types.
 Below is an example for caching any type of data using any type of key.
 This time, however, the key must conform to `Hashable` so it can be hashed.
 */
class Cache<Key: Hashable, Value> {
    private var values = [Key: Container<Value>]()
    
    func insert(_ value: Value, forKey key: Key) {
        let expirationDate = Date().addingTimeInterval(1000)
        values[key] = Container(
            value: value, date: expirationDate
        )
    }
    
    func value(forKey key: Key) -> Value? {
        guard let container = values[key] else { return nil }
        guard container.date > Date() else {
            values[key] = nil
            return nil
        }
        return container.value
    }
}
/*:
 Below are two example that use the new `Cache` class.
 The first assigns the `Key` type for `String` and `Value` as `Int`.
 The second assigns the `Value` to a custom type `Animal`.
 In both cases, the types must be specified because there is nothin else the compiler can use for type inference.
 */
let myCache = Cache<String, Int>()
myCache.insert(2, forKey: "Hello")
myCache.value(forKey: "Hello")

// A new type `Animal`.
struct Animal {
    let species: String
    let genus: String
}
let koala = Animal(species: "Phascolarctos", genus: "cinereus")

// Create another cache for `Animal` as the `Value` type.
let mySecondCache = Cache<String, Animal>()
mySecondCache.insert(koala, forKey: koala.species)
/*:
 Functions can be generic, too, regardless of where the functoin is defined.
 For example, below `String` - which is not a generic type - is extended to add the IDs of all elements of an array of  [`Identifiable`](https://developer.apple.com/documentation/swift/identifiable) type.
 */
extension String {
    mutating func appendIDs<T: Identifiable>(of values: [T]) {
        for value in values {
            append(" \(value.id)")
        }
    }
}
/*:
 Also, protocols can be generic.
 In fact, the `Identifiable` type is a generic: it has the *associated type* `ID`.
 From the Swift documentation on ["Generics"](https://docs.swift.org/swift-book/LanguageGuide/Generics.html):
 > An associated type gives a placeholder name to a type that is used as part of the protocol. The actual type to use for that associated type isn’t specified until the protocol is adopted. Associated types are specified with the associatedtype keyword.
 Here is an example of giving the `id` variable two different types for the`ID` associated type.
 */
// The `ID` type is given `UUID`.
struct Article: Identifiable {
    let id: UUID
    var title: String
    var body: String
}

// The `ID` type is given `Int`.
struct Tag: Identifiable {
    let id: Int
    var name: String
}

/*:
 (If you want more information on the `Identifiable` protocol, checkout the article ["Identifiable"](https://nshipster.com/identifiable/) from *NSHipster*.)
 */
