//
//  main.swift
//  06-枚举(enum)
//
//  Created by tangl on 2019/11/12  1:14 AM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

/**
 枚举为一组相关的值定义了一个共同的类型，可以在代码中以类型安全的方式来使用这些值。
 
 在 Swift 中，枚举类型是一等（first-class）类型。它们采用了很多在传统上只被类（class）所支持的特性，例如计算属性（computed properties），用于提供枚举值的附加信息，实例方法（instance methods），用于提供和枚举值相关联的功能。枚举也可以定义构造函数（initializers）来提供一个初始值；可以在原始实现的基础上扩展它们的功能；还可以遵循协议（protocols）来提供标准的功能。
 */

//1. 枚举语法
/**
 enum SomeEnumeration {
     // 枚举定义放在这里
 }
 
 每个枚举定义了一个全新的类型。像 Swift 中其他类型一样，它们的名字（例如 CompassPoint 和 Planet）应该以一个大写字母开头。给枚举类型起一个单数名字而不是复数名字
 */
enum CompassPoint {
    case north
    case south
    case east
    case west
}
// 注: 与 C 和 Objective-C 不同，Swift 的枚举成员在被创建时不会被赋予一个默认的整型值。在上面的 CompassPoint 例子中，north，south，east 和 west 不会被隐式地赋值为 0，1，2 和 3。相反，这些枚举成员本身就是完备的值，这些值的类型是已经明确定义好的 CompassPoint 类型。

enum Planet {
    //多个成员值可以出现在同一行上，用逗号隔开：
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

var directionToHead = CompassPoint.west // directionToHead 的类型可以在它被 CompassPoint 的某个值初始化时推断出来
directionToHead = .east //当directionToHead 的类型已知时，再次为其赋值可以省略枚举类型名

//2. 使用 Switch 语句匹配枚举值
directionToHead = .south

//在判断一个枚举类型的值时，switch 语句必须穷举所有情况
switch directionToHead {
    case .north:
        print("Lots of planets have a north")
    case .south:
        print("Watch out for penguins")
    case .east:
        print("Where the sun rises")
    case .west:
        print("Where the skies are blue")
}

let somePlanet = Planet.earth
switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default://提供一个 default 分支来涵盖所有未明确处理的枚举成员
        print("Not a safe place for humans")
}
//3. 基于cases的迭代器
/**
将枚举下所有的case包含到一个集合中来.
 语法: 在枚举名称后面添加CaseIterable. swift会暴露一个allCases属性, 包含所有case的集合
 */
enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print(Beverage.allCases, "\(numberOfChoices) beverages available")
for beverage in Beverage.allCases {
    print(beverage)
}

//4. 关联值
/**
 定义一个名为 Barcode 的枚举类型，它的一个成员值是具有 (Int，Int，Int，Int) 类型关联值的 upc，另一个成员值是具有 String 类型关联值的 qrCode
 
 这个定义不提供任何 Int 或 String 类型的关联值，它只是定义了枚举成员(Barcode.upc, Barcode.qrCode)可以存储的关联值的类型。
 */
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
//以使用任意一种条形码类型创建新的条形码
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP") // 同一个商品可以被分配一个不同类型的条形码


/**
 使用一个 switch 语句来检查不同的条形码类型, 同时关联值可以被提取出来作为 switch 语句的一部分
 
 在 switch 的 case 分支代码中提取每个关联值作为一个常量（用 let 前缀）或者作为一个变量（用 var 前缀）
 */
switch productBarcode {
    case .upc(let numberSystem, let manufacturer, let product, let check):
        print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
    case .qrCode(let productCode):
        print("QR code: \(productCode).")
}

//如果一个枚举成员的所有关联值都被提取为常量，或者都被提取为变量，为了简洁，你可以只在成员名称前标注一个 let 或者 var

switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}
//5. 原始值 (Raw Values)
/**
 举成员可以被默认值（称为原始值）预填充，这些原始值的类型必须相同
 
 原始值可以是字符串、字符，或者任意整型值或浮点型值。每个原始值在枚举声明中必须是唯一的
 */
enum ASCIIControlCharacter: Character { // 枚举类型 ASCIIControlCharacter 的原始值类型被定义为 Character
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
//    case test = "\t"
}

/**
 注: 原始值和关联值是不同的。原始值是在定义枚举时被预先填充的值，像上述三个 ASCII 码。对于一个特定的枚举成员，它的原始值始终不变。关联值是创建一个基于枚举成员的常量或变量时才设置的值，枚举成员的关联值可以变化。
 */

// 5.1 原始值的隐式赋值
/**
 在使用原始值为整数或者字符串类型的枚举时，不需要显式地为每一个枚举成员设置原始值，Swift 将会自动为你赋值
 */
// 当使用整数作为原始值时，隐式赋值的值依次递增 1。如果第一个枚举成员没有设置原始值，其原始值将为 0
enum Planet2: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
print(Planet2.mercury.rawValue, Planet2.venus.rawValue) //使用枚举成员的 rawValue 属性可以访问该枚举成员的原始值

// 当使用字符串作为枚举类型的原始值时，每个枚举成员的隐式原始值为该枚举成员的名称。
enum CompassPoint2: String {
    case north, south, east, west
}
print(CompassPoint2.north.rawValue)
// 5.2 使用原始值初始化枚举实例
/**
 如果在定义枚举类型的时候使用了原始值，那么将会自动获得一个初始化方法，这个方法接收一个叫做 rawValue 的参数，参数类型即为原始值类型，返回值则是枚举成员或 nil
 */
let possiblePlanet = Planet2(rawValue: 7)
print(possiblePlanet as Any) //possiblePlanet 类型为可选类型 Planet? 值为 Planet.uranus
// 注: 原始值构造器是一个可失败构造器，因为并不是每一个原始值都有与之对应的枚举成员
let positionToFind = 11
if let somePlanet = Planet2(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")
}

//6 .递归枚举
/**
 递归枚举是一种枚举类型，它有一个或多个枚举成员使用该枚举类型的实例作为关联值。使用递归枚举时，编译器会插入一个间接层。你可以在枚举成员前加上 indirect 来表示该成员可递归。
 */
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

//也可以在枚举类型开头加上 indirect 关键字来表明它的所有成员都是可递归的

indirect enum ArithmeticExpression2 {
    case number(Int)
    case addition(ArithmeticExpression2, ArithmeticExpression2)
    case multiplication(ArithmeticExpression2, ArithmeticExpression2)
}

//下面的代码展示了使用 ArithmeticExpression 这个递归枚举 创建表达式 (5 + 4) * 2
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four) // ArithmeticExpression类型
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2)) // ArithmeticExpression类型


//要操作具有递归性质的数据结构，使用递归函数是一种直截了当的方式
func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
        case .number(let value):
            return value
        case let .addition(left, right):
            return evaluate(left) + evaluate(right)
        case .multiplication(let left, let right):
            return evaluate(left) * evaluate(right)
    }
}

print(evaluate(product))
