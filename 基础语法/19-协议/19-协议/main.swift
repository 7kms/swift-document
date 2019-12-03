//
//  main.swift
//  19-协议
//
//  Created by tangl on 2019/11/30  2:25 PM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation
/**
 协议 定义了一个蓝图，规定了用来实现某一特定任务或者功能的方法、属性，以及其他需要的东西。
 类、结构体或枚举都可以遵循协议，并为协议定义的这些要求提供具体实现。
 某个类型能够满足某个协议的要求，就可以说该类型遵循这个协议。
 
 除了遵循协议的类型必须实现的要求外，还可以对协议进行扩展来实现一些附加功能，这样遵循协议的类型就能够使用这些功能。
 */

//1. 协议语法
/**
 
 // 定义
 protocol SomeProtocol {
  // 这里是协议的定义部分
 }
 
 // 实现 遵循多个协议时，各协议之间用逗号分隔
 struct SomeStructure: FirstProtocol, AnotherProtocol {
     // 这里是结构体的定义部分
 }
 
 // 拥有父类的类在遵循协议时，应该将父类名放在协议名之前，以逗号分隔：
 class SomeClass: SomeSuperClass, FirstProtocol, AnotherProtocol {
     // 这里是类的定义部分
 }
 
 */
//2. 属性要求
/**
 协议总是用 var 关键字来声明变量属性，在类型声明后加上 { set get } 来表示属性是可读可写的，可读属性则用 { get } 来表示
 
 protocol SomeProtocol {
     var mustBeSettable: Int { get set }
     var doesNotNeedToBeSettable: Int { get }
 }
 
 在协议中定义类型属性时，总是使用 static 关键字作为前缀。
 当类类型遵循协议时，除了 static 关键字，还可以使用 class 关键字来声明类型属性
 protocol AnotherProtocol {
     static var someTypeProperty: Int { get set }
 }
 */

/**
 这个协议表示，任何遵循 FullyNamed 的类型，都必须有一个可读的 String 类型的实例属性 fullName。
 */
protocol FullyNamed {
    var fullName: String{get}
}
struct Person: FullyNamed {
    var fullName: String
}
let john = Person(fullName: "Jhon Appleseed")
print(john.fullName)

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String{ //将FullyNamed协议中的fullName属性实现为只读的计算型属性
        return (prefix != nil ? prefix! + "" : "") + name
    }
}
var nnc1701 = Starship(name: "Enterprise", prefix: "USS")
print(nnc1701.fullName)

//3. 方法要求（Method Requirements）
/**
 在协议里可以定义实例方法和类方法. 遵循此协议的类型(结构体, 枚举, 类)必须实现协议中定义的方法
 
 // 在协议中定义类方法的时候，总是使用 static 关键字作为前缀
 // 当类类型遵循协议时，除了 static 关键字，还可以使用 class 关键字作为前缀：
 protocol SomeProtocol {
     static func someTypeMethod()
 }
 */

protocol RandomNumberGenerator{
   func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = (lastRandom * a + c).truncatingRemainder(dividingBy: m)
        return lastRandom/m
    }
}

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
print("And another one: \(generator.random())")


//4. Mutating 方法要求
/**
如果你在协议中定义了一个实例方法，该方法会改变遵循该协议的类型的实例，那么在定义协议时需要在方法前加 mutating 关键字。这使得结构体和枚举能够遵循此协议并满足此方法要求。
 
 注: 实现协议中的 mutating 方法时，若是类类型，则不用写 mutating 关键字。而对于结构体和枚举，则必须写 mutating 关键字。
 */
protocol Togglable {
    mutating func toggle()
}
enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .on:
            self = .off
        case .off:
            self = .on
        }
    }
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
print(lightSwitch)
//5. 构造器要求
/**
 协议可以要求遵循协议的类型实现指定的构造器
 
 语法: 在协议的定义里写下构造器的声明
 protocol SomeProtocol {
     init(someParameter: Int)
 }
 */

//5.1 协议构造器要求的类实现
/**
 在遵循协议的类中实现构造器，无论是作为指定构造器，还是作为便利构造器, 都必须为构造器实现标上 required 修饰符
 
 class SomeClass: SomeProtocol {
     required init(someParameter: Int) {
         // 这里是构造器的实现部分
     }
 }
 
 使用 required 修饰符可以确保所有子类也必须提供此构造器实现，从而也能符合协议。
 
 注: 如果类已经被标记为 final，那么不需要在协议构造器的实现中使用 required 修饰符，因为 final 类不能有子类
 */

/**
 如果一个子类重写了父类的指定构造器，并且该构造器满足了某个协议的要求，那么该构造器的实现需要同时标注required 和 override 修饰符：
 
 protocol SomeProtocol {
     init()
 }

 class SomeSuperClass {
     init() {
         // 这里是构造器的实现部分
     }
 }

 class SomeSubClass: SomeSuperClass, SomeProtocol {
     // 因为遵循协议，需要加上 required
     // 因为继承自父类，需要加上 override
     required override init() {
         // 这里是构造器的实现部分
     }
 }
 */
//5.2 可失败构造器要求
/**
 协议还可以为遵循协议的类型定义可失败构造器要求
 
 遵循协议的类型可以通过可失败构造器（init?）或非可失败构造器（init）来满足协议中定义的可失败构造器要求。
 协议中定义的非可失败构造器要求可以通过非可失败构造器（init）或隐式解包可失败构造器（init!）来满足。
 */
//6. 协议作为类型
/**
 协议可以像其他普通类型一样使用，使用场景如下：

 作为函数、方法或构造器中的参数类型或返回值类型
 作为常量、变量或属性的类型
 作为数组、字典或其他容器中的元素类型
 
 注: 协议是一种类型，因此协议类型的名称应与其他类型（例如 Int，Double，String）的写法相同，使用大写字母开头的驼峰式写法，例如（FullyNamed 和 RandomNumberGenerator）。
 */
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}
var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5{
    print("Random dice roll is \(d6.roll())")
}

//7. 委托（代理）模式
/**
 委托是一种设计模式，它允许类或结构体将一些需要它们负责的功能委托给其他类型的实例。
 实现：定义协议来封装那些需要被委托的功能，这样就能确保遵循协议的类型能提供这些功能。
 */

protocol DiceGame {
    var dice: Dice { get }
    func play()
}

protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
       board = [Int](repeating: 0, count: finalSquare + 1)
       board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
       board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()

//8. 通过扩展添加协议一致性
/**
 即便无法修改源代码，依然可以通过扩展令已有类型遵循并符合协议。扩展可以为已有类型添加属性、方法、下标以及构造器, 因此可以符合协议中的相应要求
 
 注: 通过扩展令已有类型遵循并符合协议时，该类型的所有实例也会随之获得协议中定义的各项功能。
 */
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
           return "A \(sides)-sided dice"
       }
}
// 现在所有 Dice 的实例都可以看做 TextRepresentable 类型
let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)

extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}

print(game.textualDescription)

//8.1 有条件地遵循协议
/**
 泛型类型可能只在某些情况下满足一个协议的要求.
 通过在扩展类型时列出限制让泛型类型有条件地遵循某协议。在你采纳协议的名字后面写泛型 where 分句。
 */
extension Array: TextRepresentable where Element: TextRepresentable{
    var textualDescription: String{
        let itemAsText = self.map { (item) -> String in
            return item.textualDescription
        }
        return "[" + itemAsText.joined(separator: ", ") + "]"
    }
}
let myDice = [d6, d12]
print(myDice.textualDescription)

//8.2 通过扩展遵循协议
/**
 当一个类型已经符合了某个协议中的所有要求，却还没有声明采纳该协议时，可以通过空扩展体的扩展采纳该协议：
 */
struct Hamster {
    var name: String
    var textualDescription: String{
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}

let simonTheHamster = Hamster(name: "Simon")
let somethingTextRepresentable: TextRepresentable = simonTheHamster
print(somethingTextRepresentable.textualDescription)
/**
 注: 即使满足了协议的所有要求，类型也不会自动遵循协议，必须显式地遵循协议。
 */
//9. 协议类型的集合
/**
 协议类型可以在数组或者字典这样的集合中使用
 */
let things: [TextRepresentable] = [game, d12, simonTheHamster]
for thing in things {
    print(thing.textualDescription)
}
//10. 协议的继承
/**
 协议能够继承一个或多个其他协议
 
 语法:多个被继承的协议间用逗号分隔：
 protocol InheritingProtocol: SomProtocol, AnotherProtocol{
  // 这里是协议的定义部分
 }
 */
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String{ get }
}

// 遵循PrettyTextRepresentable协议, 并且提供了必要的属性prettyTextualDescription
extension SnakesAndLadders: PrettyTextRepresentable{
    var prettyTextualDescription: String {
        var output = textualDescription + ": \n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "▲ "
            case let snake where snake < 0:
                output += "▼ "
            default:
                output += "○ "
            }
        }
        return output
    }
}

print(game.prettyTextualDescription)
//11. 类类型专属协议
/**
 你通过添加 AnyObject 关键字到协议的继承列表，就可以限制协议只能被类类型采纳（以及非结构体或者非枚举的类型）。
 
 protocol SomeClassOnlyProtocol: AnyObject, SomeInheritedProtocol {
     // 这里是类专属协议的定义部分
 }
 
 注: 当协议定义的要求需要遵循协议的类型必须是引用语义而非值语义时，应该采用类类型专属协议。
 */
//12. 协议合成
/**
 要求一个类型同时遵循多个协议是很有用的。
 你可以使用协议组合来复合多个协议到一个要求里。
 协议组合行为就和你定义的临时局部协议一样拥有构成中所有协议的需求。
 协议组合不定义任何新的协议类型。
 
 语法: SomeProtocol & AnotherProtocol
 */
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person2: Named, Aged {
    var name: String
    var age: Int
}

//wishHappyBirthday(to:) 函数的参数 celebrator 的类型为 Named & Aged， 这意味着“任何同时遵循 Named 和 Aged 的协议”。它不关心参数的具体类型，只要参数符合这两个协议即可。
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Person2(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)

class Location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}

// beginConcert(in:) 方法接受一个类型为 Location & Named 的参数，这意味着“任何 Location 的子类，并且遵循 Named 协议”
func beginConcert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}

let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
beginConcert(in: seattle)

//13. 检查协议一致性
/**
 可以使用 is 和 as 操作符来检查协议一致性，即是否符合某协议，并且可以转换到指定的协议类型。检查和转换到某个协议类型在语法上和类型的检查和转换完全相同：
 
 is 用来检查实例是否符合某个协议，若符合则返回 true，否则返回 false。
 as? 返回一个可选值，当实例符合某个协议时，返回类型为协议类型的可选值，否则返回 nil。
 as! 将实例强制向下转换到某个协议类型，如果强转失败，会引发运行时错误。
 */
protocol HasArea {
    var area: Double { get }
}

class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double{ return pi * radius * radius}
    init(radius: Double) {
        self.radius = radius
    }
}

class Country: HasArea {
    var area: Double
    init(area: Double) {
        self.area = area
    }
}

// Animal未遵循HasArea
class Animal {
    var legs: Int
    init(legs: Int) {
        self.legs = legs
    }
}

// Circle，Country，Animal 并没有一个共同的基类，尽管如此，它们都是类，它们的实例都可以作为 AnyObject 类型的值，存储在同一个数组中：
let objects:[AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]

for object in objects {
    if let objectWithArea = object as? HasArea {
         print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}
//14. 可选的协议要求
/**
 协议可以定义可选要求，遵循协议的类型可以选择是否实现这些要求。
 在协议中使用 optional 关键字作为前缀来定义可选要求。
 
 可选要求用在你需要和 Objective-C 打交道的代码中。协议和可选要求都必须带上 @objc 属性。
 标记 @objc 特性的协议只能被继承自 Objective-C 类的类,或者标记@objc的类所遵循，其他类以及结构体和枚举均不能遵循这种协议。
 */
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}
/**
 注: 严格来讲，CounterDataSource 协议中的方法和属性都是可选的，因此遵循协议的类可以不实现这些要求，尽管技术上允许这样做，不过最好不要这样写。
 */

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count){
            count += amount
        } else if let amount = dataSource?.fixedIncrement{
            count += amount
        }
    }
}

class ThreeSource: CounterDataSource {
    let fixedIncrement: Int = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

class TowardsZeroSource:NSObject, CounterDataSource {
    func increment(forCount count: Int) -> Int {
        if count == 0 {
            return 0
        }else if count < 0 {
            return 1
        }else {
            return -1
        }
    }
}

counter.count = -4
counter.dataSource = TowardsZeroSource()

for _ in 1...5 {
    counter.increment()
    print(counter.count)
}
//15. 协议扩展
/**
 协议可以通过扩展来为遵循协议的类型提供属性、方法以及下标的实现。通过这种方式，你可以基于协议本身来实现这些功能，而无需在每个遵循协议的类型中都重复同样的实现，也无需使用全局函数。
 */
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}
let generator2 = LinearCongruentialGenerator()
print("Here's a random number: \(generator2.random())")
print("And here's a random Boolean: \(generator2.randomBool())")

//15.1 提供默认实现
/**
 可以通过协议扩展来为协议要求的属性、方法以及下标提供默认的实现。
 如果遵循协议的类型为这些要求提供了自己的实现，那么这些自定义实现将会替代扩展中的默认实现被使用。
 
 注: 通过协议扩展为协议要求提供的默认实现和可选的协议要求不同。虽然在这两种情况下，遵循协议的类型都无需自己实现这些要求，但是通过扩展提供的默认实现可以直接调用，而无需使用可选链式调用。
 */

extension PrettyTextRepresentable {
    // PrettyTextRepresentable 协议继承自 TextRepresentable 协议，可以为其提供一个默认的 prettyTextualDescription 属性，只是简单地返回 textualDescription 属性的值：
    var prettyTextualDescription:String {
        return textualDescription
    }
}

//15.2 为协议扩展添加限制条件
/**
 在扩展协议的时候，可以指定一些限制条件，只有遵循协议的类型满足这些限制条件时，才能获得协议扩展提供的默认实现。这些限制条件写在协议名之后，使用 where 子句来描述
 */

extension Collection where Element: Equatable {
    
    func allEqual() -> Bool {
        for element in self {
            if element != self.first{
                return false
            }
        }
        return true
    }
}

// 由于数组遵循 Collection 而且整数遵循 Equatable，equalNumbers 和 differentNumbers 都可以使用 allEqual() 方法。
let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 200]
print(equalNumbers.allEqual())
print(differentNumbers.allEqual())
/**
 注:
 如果一个遵循的类型满足了为同一方法或属性提供实现的多个限制型扩展的要求， Swift 使用这个实现方法去匹配那个最特殊的限制。
 */
