//
//  main.swift
//  12-构造过程
//
//  Created by tangl on 2019/11/15  11:05 AM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

/**
 构造过程是使用类、结构体或枚举类型的实例之前的准备过程。
 在新实例可用前必须执行这个过程，具体操作包括设置实例中每个存储型属性的初始值和执行其他必须的设置或初始化工作。
 通过定义构造器来实现构造过程，就像用来创建特定类型新实例的特殊方法。与 Objective-C 中的构造器不同，Swift 的构造器无需返回值，它们的主要任务是保证新实例在第一次使用前完成正确的初始化
 */

//1. 存储属性的初始赋值
/**
 类和结构体在创建实例时，必须为所有存储型属性设置合适的初始值
 你可以在构造器中为存储型属性赋初值，也可以在定义属性时为其设置默认值
 
 注: 当你为存储型属性设置默认值或者在构造器中为其赋值时，它们的值是被直接设置的，不会触发任何属性观察者。
 */
//1.1 构造器
/**
 构造器在创建某个特定类型的新实例时被调用。它的最简形式类似于一个不带任何参数的实例方法，以关键字 init 命名
 init(){
    
 }
 */
struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}
var f = Fahrenheit()
print("the default temperature is \(f.temperature)° Fahrenheit")

//1.2 默认属性值
/**
 在属性声明时为其设置默认值
 
 注: 如果一个属性总是使用相同的初始值，那么为其设置一个默认值比每次都在构造器中赋值要好。
 两种方法的效果是一样的，只不过使用默认值让属性的初始化和声明结合得更紧密, 且能通过默认值自动推导出属性的类型；同时，它也能让你充分利用默认构造器、构造器继承等特性。
 */
struct Fahrenheit2 {
    var temperature = 32.0
}
//2. 自定义构造过程
/**
 你可以通过输入参数和可选类型的属性来自定义构造过程，也可以在构造过程中给常量属性赋初值
 */
//2.1 构造参数
/**
 自定义构造过程时，可以在定义中提供构造参数，指定参数值的类型和名字。构造参数的功能和语法跟函数和方法的参数相同。
 */
struct Celsius {
    var tempertureInCelsisus: Double
    init(fromFahrenheit fahrenheit: Double) {
        tempertureInCelsisus = (fahrenheit - 32)/1.8
    }
    init(fromKelvin kelvin: Double) {
        tempertureInCelsisus = kelvin - 273.15
    }
}

let boilingPoinOfWater = Celsius(fromFahrenheit: 212.0)
print("boilingPointOfWater.temperatureInCelsius 是 \(boilingPoinOfWater.tempertureInCelsisus)")
let freezingPointOfWater = Celsius(fromKelvin: 273.15)
print("freezingPointOfWater.temperatureInCelsius 是 \(freezingPointOfWater.tempertureInCelsisus)")
//2.2 参数名和参数标签
/**
 跟函数和方法参数相同，构造参数也拥有一个在构造器内部使用的参数名和一个在调用构造器时使用的参数标签。
 
 如果没有为构造函数制定参数标签, Swift会为构造器的每个参数自动生成一个参数标签.
 */
struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    init(white: Double) {
        red = white
        green = white
        blue = white
    }
}

let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let halfGray = Color(white: 0.5)

//2.3 不带参数标签的构造器参数
// 可以使用下划线（_）来显式描述它的外部名

struct Celsius2 {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius: Double){
        temperatureInCelsius = celsius
    }
}
let bodyTemperature = Celsius2(37.0) //调用init(_ celsius: Double) 构造器, 无需加上参数标签

print("bodyTemperature.temperatureInCelsius 为 \(bodyTemperature.temperatureInCelsius)")

//2.3 可选属性类型
/**
可选类型的属性将自动初始化为 nil，表示这个属性是有意在初始化时设置为空的。
 */
class SurveyQuestion {
    var text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask(){
        print(text)
    }
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()
cheeseQuestion.response = "Yes, I do like cheese."

//2.4 构造过程中常量属性的赋值
/**
 你可以在构造过程中的任意时间点给常量属性指定一个值，只要在构造过程结束时是一个确定的值。一旦常量属性被赋值，它将永远不可更改。
 
 注: 对于类的实例来说，它的常量属性只能在定义它的类的构造过程中修改；不能在子类中修改。
 */

class SurveyQuestion2 {
    let text: String //用let声明属性,表示内容在实例创建之后不可更改
    var response: String?
    init(text: String) {
        self.text = text //在构造器中可以设置常量的值
    }
    func ask() {
        print(text)
    }
}
let beetsQuestion = SurveyQuestion(text: "How about beets?")
beetsQuestion.ask()
beetsQuestion.response = "I also like beets. (But not with cheese.)"

//3. 默认构造器
/**
 1. 结构体或类的所有属性都有默认值
 2. 同时没有自定义的构造器
 那么 Swift 会给这些结构体或类提供一个默认构造器（default initializers）
 
 这个默认构造器将简单地创建一个所有属性值都设置为默认值的实例。
 */

class ShoppingListItem2 {
    var name: String? //name 是可选字符串类型，它将默认设置为 nil
    var quantity = 1
    var purchased = false
}

var item = ShoppingListItem2()

//3.1 结构体的逐一成员构造器
/**
 1. 首先满足默认构造器的生成规则
 2. 如果结构体没有提供自定义的构造器，它们将自动获得一个逐一成员构造器（memberwise initializer），即使结构体的存储型属性没有默认值。
 */
struct Size2 {
    var width = 0.0, height = 0.0
}

let twoByTwo = Size2(width: 2.0, height: 2.0)

//4. 值类型的构造器代理
 /**
 构造器可以通过调用其它构造器来完成实例的部分构造过程。
 这一过程称为构造器代理，它能避免多个构造器间的代码重复。
 
 构造器代理的规则在值类型和类类型中是不同的.
 值类型（结构体和枚举类型）不支持继承，所以只能代理给自己的其它构造器
 类则不同，它可以继承自其他类，类有责任保证其所有继承的存储型属性在构造时也能正确的初始化
 
 对于值类型，你可以使用 self.init 在自定义的构造器中引用相同类型中的其它构造器。并且你只能在构造器内部调用 self.init
 
 
 
 如果你为某个值类型定义了一个自定义的构造器，你将无法访问到默认构造器（如果是结构体，还将无法访问逐一成员构造器）。
 
 注: 假如你希望默认构造器、逐一成员构造器以及你自己的自定义构造器都能用来创建实例，可以将自定义的构造器写到扩展（extension）中，而不是写在值类型的原始定义中
 
 */


struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    init() {}// 空函数,在功能上跟没有自定义构造器时自动获得的默认构造器是一样的

    init(origin: Point, size: Size) { // 在功能上跟结构体在没有自定义构造器时获得的逐一成员构造器是一样
        self.origin = origin
        self.size = size
    }

    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size) //调用(代理给) init(origin:size:) 构造器来将新
    }
}

//5 类的继承和构造过程
/**
 类里面的所有存储型属性——包括所有继承自父类的属性——都必须在构造过程中设置初始值。
 
 Swift 为类类型提供了两种构造器来确保实例中所有存储型属性都能获得初始值，它们分别是指定构造器和便利构造器。
 */
//5.1 指定构造器和便利构造器
/**
 
 指定构造器是类中最主要的构造器。一个指定构造器将初始化类中提供的所有属性，并根据父类链往上调用父类合适的构造器来实现父类的初始化。每一个类都必须至少拥有一个指定构造器
 
 便利构造器是类中比较次要的、辅助型的构造器。你可以定义便利构造器来调用同一个类中的指定构造器，并为其参数提供默认值。你也可以定义便利构造器来创建一个特殊用途或特定输入值的实例。你应当只在必要的时候为类提供便利构造器
 
 
 语法:
 1. 制定构造器
 
 指定构造器的写法跟值类型简单构造器一样：
 init(parameters) {
     statements
 }
 
 2. 便利构造器 在init关键字之前添加convenience关键字
 
 convenience init (parameters) {
    statements
 }
 */

//5.2 类的构造器代理规则

/**
 为了简化指定构造器和便利构造器之间的调用关系，Swift 采用以下三条规则来限制构造器之间的代理调用：
 1. 指定构造器必须调用其直接父类的的指定构造器。
 2. 便利构造器必须调用同类中定义的其它构造器。
 3. 便利构造器最后必须调用指定构造器。
 
 一个更方便记忆的方法是：
 指定构造器必须总是向上代理
 便利构造器必须总是横向代理
 */
//5.3 两段式构造过程 (Two-Phase Initialization)
/**
 1. 类中的每个存储型属性赋一个初始值
 2. 在新实例准备使用之前进一步定制它们的存储型属性
 
 两段式构造过程可以防止属性值在初始化之前被访问，也可以防止属性被另外一个构造器意外地赋予不同的值。
 Swift 编译器将执行 4 种有效的安全检查，以确保两段式构造过程不出错地完成:
 1. 定构造器必须保证它所在类的属性在它往上代理之前先完成初始化。
 2. 指定构造器必须在为继承的属性设置新值之前向上代理调用父类构造器，如果没这么做，指定构造器赋予的新值将被父类中的构造器所覆盖。
 3. 便利构造器必须为任意属性（包括同类中定义的）赋新值之前代理调用同一类中的其它构造器，如果没这么做，便利构造器赋予的新值将被同一类中其它指定构造器所覆盖
 4. 构造器在第一阶段构造完成之前，不能调用任何实例方法，不能读取任何实例属性的值，不能引用 self 作为一个值。
 */
//5.4 构造器的继承和重写
/**
 跟 Objective-C 中的子类不同，Swift 中的子类默认情况下不会继承父类的构造器。Swift 的这种机制可以防止一个父类的简单构造器被一个更精细的子类继承，并被错误地用来创建子类的实例。
 
 注: 当你重写一个父类的指定构造器时，你总是需要写 override 修饰符，即使是为了实现子类的便利构造器。
 */

class Vehicle {
    // 因为Vehicle没有提供自定义构造器,所以会获得一个默认构造器
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}
let vehicle = Vehicle()
print("Vehicle: \(vehicle.description)")

class Bicycle: Vehicle {
    override init() { // 自定义构造器init()与父类的指定构造器相匹配,所以需要加上override修饰符
        super.init()
        numberOfWheels = 2
        // 注: 子类可以在初始化时修改继承来的变量属性，但是不能修改继承来的常量属性。
    }
}
let bicycle = Bicycle()
print("Bicycle: \(bicycle.description)")

//5.5 构造器的自动继承
/**
 
 子类在默认情况下不会继承父类的构造器。但是如果满足特定条件，父类构造器是可以被自动继承的
 
 
 前提条件: 子类中引入的所有新属性都提供了默认值
 1. 如果子类没有定义任何指定构造器，它将自动继承父类所有的指定构造器。
 2. 如果子类提供了所有父类指定构造器的实现——无论是通过规则 1 继承过来的，还是提供了自定义实现——它将自动继承父类所有的便利构造器
 
 注: 即使你在子类中添加了更多的便利构造器，这两条规则仍然适用。
 对于规则 2，子类可以将父类的指定构造器实现为便利构造器。
 */
//3.3.6 指定构造器和便利构造器实践
class Food {
    var name: String
    init(name: String) {
        //Food 类没有父类，所以 init(name: String) 构造器不需要调用 super.init()
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}
let namedFood = Food(name: "Bacon")
let mysteryMeat = Food()


/**
 尽管 RecipeIngredient 将父类的指定构造器重写为了便利构造器，但是它依然提供了父类的所有指定构造器的实现。因此，RecipeIngredient 会自动继承父类的所有便利构造器(convenience init())。
 */
class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int){
        self.quantity = quantity
        super.init(name: name)
        
    }

    
    // 子类可以将父类的指定构造器实现为便利构造器。
    override convenience init(name: String) {
        //由于这个便利构造器重写了父类的指定构造器 init(name: String)，因此必须在前面使用 override 修饰符
        // override和convenience顺序不限
        self.init(name: name, quantity: 1)
    }
    
}
//这三种构造器都可以用来创建新的 RecipeIngredient 实例：

let oneMysteryItem = RecipeIngredient()
let oneBacon = RecipeIngredient(name: "Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)


/**
 由于它为自己引入的所有属性都提供了默认值，并且自己没有定义任何构造器，ShoppingListItem 将自动继承所有父类中的指定构造器和便利构造器。
 */
class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}

// 这里ShoppingListItem会有3种构造形式
var breakfastList = [
    ShoppingListItem(),
    ShoppingListItem(name: "Bacon"),
    ShoppingListItem(name: "Eggs", quantity: 6),
]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}

// 6. 可失败构造器
/**
 如果一个类、结构体或枚举类型的对象，在构造过程中有可能失败，则可以为其定义一个可失败的构造器
 
 在一个类，结构体或是枚举类型的定义中，添加一个或多个可失败构造器。
 语法: 在 init 关键字后面添加问号（init?）。通过 return nil 语句来表明可失败构造器“失败”。
 注: 严格来说，构造器都不支持返回值。因为构造器本身的作用，只是为了确保对象能被正确构造。因此你只是用 return nil 表明可失败构造器构造失败，而不要用关键字 return 来表明构造成功。

 注: 可失败构造器的参数名和参数类型，不能与其它非可失败构造器的参数名，及其参数类型相同。
 */

let wholeNumber = 12345.0
let pi = 3.14159
// 针对数字类型转换的可失败构造器。确保数字类型之间的转换能保持精确的值，使用这个 init(exactly:) 构造器。如果类型转换不能保持值不变，则这个构造器构造失败
if let valueMaintained = Int(exactly: wholeNumber) {
    print("\(wholeNumber) conversion to Int maintains value of \(valueMaintained)")
}
let valueChanged = Int(exactly: pi)
if valueChanged == nil {
    print("\(pi) conversion to Int does not maintain value")
}


struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty {
            return nil
        }
        self.species = species
    }
}

let someCreature = Animal(species: "Giraffe") //返回Animal?类型

if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}

let anonymousCreature = Animal(species: "")
if anonymousCreature == nil {
    print("The anonymous creature could not be initialized")
}

// 6.1 枚举类型的可失败构造器
/**
 你可以通过带参数(一个参数或者多个参数)的可失败构造器来获取枚举类型中特定的枚举成员。如果提供的参数无法匹配任何枚举成员，则构造失败。
 */
enum TemperatureUnit {
    case Kelvin, Celsius, Fahrenheit
    init?(symbol: Character) {
        switch symbol {
            case "K":
                self = .Kelvin
            case "C":
                self = .Celsius
            case "F":
                self = .Fahrenheit
            default:
                return nil
        }
    }
}
let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}
let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}

//6.2 带原始值的枚举类型的可失败构造器
/**
 带原始值的枚举类型会自带一个可失败构造器 init?(rawValue:)，该可失败构造器有一个名为 rawValue 的参数，其类型和枚举类型的原始值类型一致，如果该参数的值能够和某个枚举成员的原始值匹配，则该构造器会构造相应的枚举成员，否则构造失败。
 */

enum TemperatureUnit2: Character {
    case Kelvin = "K", Celsius = "C", Fahrenheit = "F"
}
let fahrenheitUnit2 = TemperatureUnit2(rawValue: "F")
if fahrenheitUnit2 != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}

let unknownUnit2 = TemperatureUnit2(rawValue: "X")
if unknownUnit2 == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}
//6.3 构造失败的传递
/**
 类，结构体，枚举的可失败构造器可以横向代理到同类型中的其他可失败构造器。类似的，子类的可失败构造器也能向上代理到父类的可失败构造器.
 
 无论是向上代理还是横向代理，如果你代理到的其他可失败构造器触发构造失败，整个构造过程将立即终止，接下来的任何构造代码不会再被执行。
 
 
 注: 可失败构造器也可以代理到其它的非可失败构造器。通过这种方式，你可以增加一个可能的失败状态到现有的构造过程中。
 */

class Product {
    let name: String
    init?(name: String){
        if name.isEmpty {
            return nil
        }
        self.name = name
    }
}

class CartItem: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 {
            // 若 quantity 值无效，则立即终止整个构造过程，返回失败结果，且不再执行余下代码
            return nil
        }
        self.quantity = quantity
        super.init(name: name)
    }
}
if let twoSocks = CartItem(name: "sock", quantity: 2) {
    print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
}
if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
    print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
} else {
    print("Unable to initialize zero shirts")
}
if let oneUnnamed = CartItem(name: "", quantity: 1) {
    print("Item: \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
} else {
    print("Unable to initialize one unnamed product")
}

//6.4 重写一个可失败构造器
/**
 如同其它的构造器，你可以在子类中重写父类的可失败构造器。或者你也可以用子类的非可失败构造器重写一个父类的可失败构造器。这使你可以定义一个不会构造失败的子类，即使父类的构造器允许构造失败。
 
 注: 当你用子类的非可失败构造器重写父类的可失败构造器时，向上代理到父类的可失败构造器的唯一方式是对父类的可失败构造器的返回值进行强制解包
 
 注: 你可以用非可失败构造器重写可失败构造器，但反过来却不行。
 */

class Document {
    var name: String?
    
    // 该构造器创建了一个 name 属性的值为 nil 的 document 实例
    init(){}
    
    // 该构造器创建了一个 name 属性的值为非空字符串的 document 实例
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}

class AutomaticallyNamedDocument: Document{
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    override init(name: String) { // 非可失败构造器 init(name:) 重写了父类的可失败构造器 init?(name:)
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        }else {
            self.name = name
        }
    }
}

// 在子类的非可失败构造器中使用强制解包来调用父类的可失败构造器
class UntitledDocument: Document {
    override init() {
        super.init(name: "[Untitled]")! //如果在调用父类的可失败构造器 init?(name:) 时传入的是空字符串，那么强制解包操作会引发运行时错误
    }
    
    override init!(name: String) {
        if name.isEmpty {
            super.init(name: "[Untitled]")!
        }else {
            super.init(name: name)!
        }
    }
}
let untitle = UntitledDocument(name: "")
print(untitle!)

//6.5 init!可失败构造器
/**
 通常来说我们通过在 init 关键字后添加问号的方式（init?）来定义一个可失败构造器，但你也可以通过在 init 后面添加惊叹号的方式来定义一个可失败构造器（init!），该可失败构造器将会构建一个对应类型的隐式解包可选类型的对象。
 
 你可以在 init? 中代理到 init!，反之亦然。你也可以用 init? 重写 init!，反之亦然。你还可以用 init 代理到 init!，不过，一旦 init! 构造失败，则会触发一个断言。
 */

//7. 必要构造器
/**
 在类的构造器前添加 required 修饰符表明所有该类的子类都必须实现该构造器：
 
 class SomeClass {
     required init() {
         // 构造器的实现代码
     }
 }
 
 在子类重写父类的必要构造器时，必须在子类的构造器前也添加 required 修饰符，表明该构造器要求也应用于继承链后面的子类。在重写父类中必要的指定构造器时，不需要添加 override 修饰符：
 class SomeSubclass: SomeClass {
     required init() {
         // 构造器的实现代码
     }
 }
 
 注: 如果子类继承的构造器能满足必要构造器的要求，则无须在子类中显式提供必要构造器的实现。
 */
//8. 通过闭包或函数设置属性的默认值
/**
每当某个属性所在类型的新实例被创建时，对应的闭包或函数会被调用，而它们的返回值会当做默认值赋值给这个属性。
 
 语法:
 class SomeClass {
     let someProperty: SomeType = {
         // 在这个闭包中给 someProperty 创建一个默认值
         // someValue 必须和 SomeType 类型相同
         return someValue
     }()
 }
 
 
 注: 如果你使用闭包来初始化属性，请记住在闭包执行时，实例的其它部分都还没有初始化。这意味着你不能在闭包里访问其它属性，即使这些属性有默认值。同样，你也不能使用隐式的 self 属性，或者调用任何实例方法。
 
 */

struct Chessboard {
    let boardColors:[Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...8{
            for j in 1...8{
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    
    func squareIsBlackAt(row: Int, column: Int) -> Bool {
        return boardColors[row * 8 + column]
    }
}
let board = Chessboard()
print(board.squareIsBlackAt(row: 0, column: 1))
print(board.squareIsBlackAt(row: 7, column: 7))
