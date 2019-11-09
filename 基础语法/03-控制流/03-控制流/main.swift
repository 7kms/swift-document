//
//  main.swift
//  03-控制流
//
//  Created by tangl on 2019/11/9  11:21 PM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

/**
 Swift 里面的流程控制
 while循环
 for-in循环
 break, continue语句
 if
 guard
 switch
 */

// 1. for-in循环
// 数组
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names{
    print(name)
}
for (index, name) in names.enumerated() {// 同时获取索引
    print("\(index) Hello, \(name)!")
}

// 字典
// 字典的每项元素会以 (key, value) 元组的形式返回
let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs")
}

// 数字范围

// 使用半开区间运算符（..<）来表示一个左闭右开的区间
// 闭区间操作符（...）表示左右都是闭合的区间
for index in 1...5 {
    // index 是一个每次循环遍历开始时被自动赋值的常量。这种情况下，index 在使用前不需要声明，只需要将它包含在循环的声明中，就可以对其进行隐式声明，而无需使用 let 关键字声明。
    print("\(index) times 5 is \(index * 5)")
}


// stride(from:to:by:) 函数跳过不需要的标记
let minutes = 60
let minuteInterval = 5
for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
    // 每5分钟渲染一个刻度线（0, 5, 10, 15 ... 45, 50, 55）
    print(tickMark)
}


let hours = 12
let hourInterval = 3
for tickMark in stride(from: 3, through: hours, by: hourInterval) {
    // 每3小时渲染一个刻度线（3, 6, 9, 12）
    print(tickMark)
}


// 2. while循环
/**
 语法:
 while condition {
     statements
 }
 */
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)
var square = 0
var diceRoll = 0
while square < finalSquare {
    // 掷骰子
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    // 根据点数移动
    square += diceRoll
    if square < board.count {
        // 如果玩家还在棋盘上，顺着梯子爬上去或者顺着蛇滑下去
        square += board[square]
    }
}
print("Game over!")

//3. Repeat-While
/**
 // 和 while 的区别是在判断循环条件之前，先执行一次循环的代码块。然后重复循环直到条件为 false
 // Swift 语言的 repeat-while 循环和其他语言中的 do-while 循环是类似的
 语法
 repeat {
     statements
 } while condition
 */

//4. if
var temperatureInFahrenheit = 30
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
}
//5. Switch
/**
 
 switch 语句必须是完备的 , 每一个可能的值都必须至少有一个 case 分支与之对应。如不可能涵盖所有值，使用默认（default）分支来涵盖，default必须在 switch 语句的最后面。
 
 
 与 C 和 Objective-C 中的 switch 语句不同，在 Swift 中，当匹配的 case 分支中的代码执行完毕后，程序会终止 switch 语句，而不会继续执行下一个 case 分支。这也就是说，不需要在 case 分支中显式地使用 break 语句
 */

let someCharacter: Character = "z"
switch someCharacter {
    case "a":
        print("The first letter of the alphabet")
    case "z":
        print("The last letter of the alphabet")
    default:
        print("Some other character")
}


let anotherCharacter: Character = "a"
switch anotherCharacter {
//case "a": // 无效，会引发编译错误, 这个分支下面没有语句
case "a", "A": //让单个 case 同时匹配 a 和 A
    print("The letter A")
default:
    print("Not the letter A")
}


// 区间匹配

let approximateCount = 62
let countedThings = "moons orbiting Saturn"
let naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")


// 元组

/**
 可以使用元组在同一个 switch 语句中测试多个值。元组中的元素可以是值，也可以是区间。另外，使用下划线（_）来匹配所有可能的值。
 */

/**
 Swift 允许多个 case 匹配同一个值。实际上，在这个例子中，点 (0, 0)可以匹配所有四个 case。但是，如果存在多个匹配，那么只会执行第一个被匹配到的 case 分支。考虑点 (0, 0)会首先匹配 case (0, 0)，因此剩下的能够匹配的分支都会被忽视掉
 */
let somePoint = (1, 1)
switch somePoint {
    case (0, 0):
        print("\(somePoint) is at the origin")
    case (_, 0):
        print("\(somePoint) is on the x-axis")
    case (0, _):
        print("\(somePoint) is on the y-axis")
    case (-2...2, -2...2):
        print("\(somePoint) is inside the box")
    default:
        print("\(somePoint) is outside of the box")
}

// 值绑定
// case 分支允许将匹配的值声明为临时常量或变量，并且在 case 分支体内使用

let anotherPoint = (2, 0)
switch anotherPoint {
    case (let x, 0):
        print("on the x-axis with an x value of \(x)")
    case (0, let y):
        print("on the y-axis with a y value of \(y)")
    case let (x, y):// 这里声明了一个可以匹配余下所有值的元组。这使得 switch 语句已经完备了，因此不需要再书写默认分支。
        print("somewhere else at (\(x), \(y))")
}

// Where
// case 分支的模式可以使用 where 语句来判断额外的条件, 当且仅当 where 语句的条件为 true 时，匹配到的 case 分支才会被执行。
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}

// 复合型 Cases
// 当多个条件可以使用同一种方法来处理时，可以将这几种可能放在同一个 case 后面，并且用逗号隔开
let someCharacter2: Character = "e"
switch someCharacter2 {
case "a", "e", "i", "o", "u":
    print("\(someCharacter2) is a vowel")
case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
     "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
    print("\(someCharacter2) is a consonant")
default:
    print("\(someCharacter2) is not a vowel or a consonant")
}

// 复合匹配同样可以包含值绑定

let stillAnotherPoint = (9, 0)
switch stillAnotherPoint {
case (let distance, 0), (0, let distance):
    print("On an axis, \(distance) from the origin")
default:
    print("Not on an axis")
}


// 4. 控制转移语句
/**
 continue
 break
 fallthrough
 return //用于函数
 throw //函数中抛出错误
 */

// continue 一个循环体立刻停止本次循环，重新开始下次循环
let puzzleInput = "great minds think alike"
var puzzleOutput = ""
for character in puzzleInput {
    switch character {
    case "a", "e", "i", "o", "u", " ":
        continue
    default:
        puzzleOutput.append(character)
    }
}
print(puzzleOutput)

// break

// break 语句会立刻结束整个控制流的执行。break 可以在 switch 或循环语句中使用，用来提前结束 switch 或循环语句。

let numberSymbol: Character = "三"  // 简体中文里的数字 3
var possibleIntegerValue: Int?
switch numberSymbol {
case "1", "١", "一", "๑":
    possibleIntegerValue = 1
case "2", "٢", "二", "๒":
    possibleIntegerValue = 2
case "3", "٣", "三", "๓":
    possibleIntegerValue = 3
case "4", "٤", "四", "๔":
    possibleIntegerValue = 4
default:
    break
}
if let integerValue = possibleIntegerValue {
    print("The integer value of \(numberSymbol) is \(integerValue).")
} else {
    print("An integer value could not be found for \(numberSymbol).")
}

// 5. Fallthrough 贯穿

// fallthrough 关键字不会检查它下一个将会落入执行的 case 中的匹配条件。fallthrough 简单地使代码继续连接到下一个 case 中的代码，这和 C 语言标准中的 switch 语句特性是一样的。
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer."
}
print(description)


// 6. 带标签的语句
/**
 当循环体h或者条件语句嵌套比较复杂的时候, 显式指明 break,continue想要影响哪一个循环体.
 类似于java里面的goto
 
 语法:
 label name: while condition {
     statements
 }
 */
// 7. guard 提前退出

// 像 if 语句一样，guard 的执行取决于一个表达式的布尔值。我们可以使用 guard 语句来要求条件必须为真时，以执行 guard 语句后的代码。不同于 if 语句，一个 guard 语句总是有一个 else 从句，如果条件不为真则执行 else 从句中的代码

/**
 相比于可以实现同样功能的 if 语句，按需使用 guard 语句会提升我们代码的可读性
 它可以使代码连贯的被执行而不需要将它包在 else 块中，它可以使你在紧邻条件判断的地方，处理违规的情况。
 
 */
func greet(_ person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    print("Hello \(name)")
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")
}
greet(["name": "John"])

greet(["name": "Jane", "location": "Cupertino"])

//8. 检测 API 可用性
/**
 
 Swift 内置支持检查 API 可用性，这可以确保我们不会在当前部署机器上，不小心地使用了不可用的 API。
 如果我们尝试使用一个不可用的 API，Swift 会在编译时报错。
 */
if #available(iOS 10, macOS 10.12, *) {// if 语句的代码块仅仅在 iOS 10 或 macOS 10.12 及更高版本才运行。最后一个参数，*，是必须的，用于指定在所有其它平台中，如果版本号高于你的设备指定的最低版本，if 语句的代码块将会运行。
    // 在 iOS 使用 iOS 10 的 API, 在 macOS 使用 macOS 10.12 的 API
} else {
    // 使用先前版本的 iOS 和 macOS 的 API
}

/**
 在它一般的形式中，可用性条件使用了一个平台名字和版本的列表。平台名字可以是 iOS，macOS，watchOS 和 tvOS——请访问声明属性来获取完整列表。
 除了指定像 iOS 8 或 macOS 10.10 的大版本号，也可以指定像 iOS 11.2.6 以及 macOS 10.13.3 的小版本号
 
 if #available(platform name version, ..., *) {
     APIs 可用，语句将执行
 } else {
     APIs 不可用，语句将不执行
 }
 
 */
