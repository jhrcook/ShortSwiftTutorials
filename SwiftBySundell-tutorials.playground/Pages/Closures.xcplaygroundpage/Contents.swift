/*:
 # Closures
 
 This notebook follows the *Swift by Sundell* post ["Closures"](https://www.swiftbysundell.com/basics/closures/).
 */
import UIKit
/*:
 Closures are essentially a chunk of code that can be called as one unit.
 They can accept input and produce output.
 A closure can be a stored property, local variable, passed as an argument to a function, etc.
 */
struct IntToStringConverter {
    // A closure property that takes an `Int` and returns a `String`.
    var body: (Int) -> String
}

// A closure as a variable.
// It takes no input and returns the integer 7.
let intProvider: () -> Int = { return 7 }

intProvider()
/*:
 Here is an example of a use of a closure to extend the `String` type.
 It splits `self` into separate words and applies the provided closure to each before rejoining the results to be returned.
*/
extension String {
    func transformWords(using closure: (Substring) -> String) -> String {
        // Split `self` into separate words.
        let words = split(separator: " ")
        var results = [String]()
        
        // For each word, apply the closure.
        for word in words {
            results.append(closure(word))
        }
        
        // Re-join all of the separate pieces and return a `String`.
        return results.joined(separator: " ")
    }
}
/*:
 Now any closure can be applied to each word of a `String` as long as it accepts a `Substring` and returns a `String`.
 For example, here is an example that makes each word lowercase.
 The `in` keyword is used to separate the names of the input, `word` in this case, from the rest of the closure.´
 */
let myString = "Hello, world!"
myString.transformWords(using: { word in
    return word.lowercased()
})
/*:
 Here is another example that adds a koala 🐨 emoji after each word.
 */
myString.transformWords(using: { word in
    return word + "🐨"
})
/*:
 There are multiple shorthand methods available for use with closures in Swift:
 
 * *trailing closure*: If the last argument in a function call is a closure, the closure can be moved beyond the parantheses.
 * If it is the only argument, the function's  paranthesis can be completely removed.
 * *closure argument shorthand*: The arguments can be referred to positionally using `$0`.
 * As of Swift 5.1, the `return` keyword is not required for single-expression closures (or functions and computed properties).
 
 The following example also makes every word lowercase, but uses the above shothands.
 */
myString.transformWords { $0.lowercased() }
/*:
 Another useful property of closures is to save code to be run later.
 In the following example, the function `delay()` runs a closure after a specified time delay.
 
 Note that the closure is marked as `@escaping` because ...
 */
func delay(by seconds: TimeInterval,
           on queue: DispatchQueue = .main,
           closure: @escaping () -> Void) {
    queue.asyncAfter(deadline: .now() + seconds,
                     execute: closure)
}
/*:
 The  example below shows a view controller that, when the view will appear, presents the main image after a 2 second delay.
 An escaping closure must use `self` explicitly to reference a proprty or method within it.
 To avoid a memory leak from a strong reference cycle, we should make `self` weak and unwrap it in the closure.
 */
class ProfileViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delay(by: 2) { [weak self] in
            self?.showMainImage()
        }
    }
    
    private func showMainImage() {
        // Show the main profile image.
    }
}
/*:
 Finally, because Swift supports first class functions, a function can be passed in place of a closure (as long it is of the correct type; i.e. has the correct inputs and outputs).
 */
func capitalize(word: Substring) -> String {
    return word.capitalized
}

myString.transformWords(using: capitalize)
