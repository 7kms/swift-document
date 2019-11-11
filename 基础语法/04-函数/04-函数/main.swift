//
//  main.swift
//  04-函数
//
//  Created by tangl on 2019/11/10  10:03 AM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

// 1. 函数的定义与调用
func greet(person: String) -> String {
//    let greeting = "Hello, " + person + "!"
//    return greeting
    return "Hello, " + person + "!" // 将问候消息的创建和返回写成一句
}
print(greet(person: "Anna")) // greet函数返回一个 String 类型的值，所以 greet 可以被包含在 print(_:separator:terminator:) 的调用中，用来输出这个函数的返回值
print(greet(person: "Brian"))
// 2. 函数参数与返回值
// 2.1 无参数函数
func sayHelloWorld() -> String{
    return "hello, world"
}
print(sayHelloWorld())
// 2.2 多参数函数
func printAndCount(string: String) -> Int {//定义了有返回值的函数必须返回一个值，如果在函数定义底部没有返回任何值，将导致编译时错误
    print(string)
    return string.count
}
func printWithoutCounting(string: String) {
    let _ = printAndCount(string: string)
}
printAndCount(string: "hello, world") //返回12 返回值可以被忽略
printWithoutCounting(string: "hello, world")

// 2.3 多重返回值函数
// 可以用元组（tuple）类型让多个值作为一个复合值从函数中返回
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    
    //元组的成员不需要在返回时命名，因为名字已经在函数返回类型中指定了
    return (currentMin, currentMax)
}

let bounds = minMax(array: [8, -6, 2, 109, 3, 71])
//因为元组的成员值已被命名，因此可以通过 . 语法来检索找到的最小值与最大值
print("min is \(bounds.min) and max is \(bounds.max)")

//2.4 可选元组返回类型
/**
 如 (Int, Int)? 或 (String, Int, Bool)?
 
 可选元组类型如 (Int, Int)? 与元组包含可选类型如 (Int?, Int?) 是不同的。可选的元组类型，整个元组是可选的，而不只是元组中的每个元素值
 */
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}

if let bounds = minMax(array: [8, -6, 2, 109, 3, 71]) {
    print("min is \(bounds.min) and max is \(bounds.max)")
}
//2.5 函数参数标签和参数名称
// 每个函数参数都有一个参数标签（argument label）以及一个参数名称（parameter name）
// 参数标签在调用函数的时候使用；调用的时候需要将函数的参数标签写在对应的参数前面
// 参数名称在函数的实现中使用
// 默认情况下，函数参数使用参数名称来作为它们的参数标签
func someFunction(firstParameterName: Int, secondParameterName: Int) {
    // 在函数体内，firstParameterName 和 secondParameterName 代表参数中的第一个和第二个参数值
}
someFunction(firstParameterName: 1, secondParameterName: 2)

//2.5.1 指定参数标签
// 以在参数名称前指定它的参数标签，中间以空格分隔
func someFunction(argumentLabel parameterName: Int) {
    // 在函数体内，parameterName 代表参数值
}

func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))
//2.5.2 忽略参数标签
//以使用一个下划线（_）来代替一个明确的参数标签
func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
     // 在函数体内，firstParameterName 和 secondParameterName 代表参数中的第一个和第二个参数值
}
someFunction(1, secondParameterName: 2)

//2.6 默认参数值
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    // 如果你在调用时候不传第二个参数，parameterWithDefault 会值为 12 传入到函数体中。
}
someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6) // parameterWithDefault = 6
someFunction(parameterWithoutDefault: 4)
//2.7 可变参数 variadic parameter
/**
 函数调用时表示参数的个数不确定
 语法:变量类型名后面加入（...）
 一个函数最多只能拥有一个可变参数。
 */
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
print(arithmeticMean(1, 2, 3, 4, 5))
print(arithmeticMean(3, 8.25, 18.75))

//2.8 输入输出参数 (In-Out Parameters)
/**
 函数参数默认是常量,试图在函数体中更改参数值将会导致编译错误.
 
 如果想要修改参数的值，应该把这个参数定义为输入输出参数.
 这些修改在函数调用结束后仍然存在
 
 语法:
 1.参数定义前加 inout 关键字
 2.传参时需要在参数名前加 & 符
 
 注: 输入输出参数有传入函数的值只能是变量(var修饰), 不能是常量或者字面量，这个值被函数修改，然后被传出函数，替换原来的值
 输入输出参数不能有默认值，而且可变参数不能用 inout 标记。
 */
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
/**
 输入输出参数和返回值是不一样的。
 上面的 swapTwoInts 函数并没有定义任何返回值，但仍然修改了 someInt 和 anotherInt 的值。输入输出参数是函数对函数体外产生影响的另一种方式
 */

//2.9 函数类型
/**
 每个函数都有种特定的函数类型，函数的类型由函数的参数类型和返回类型组成。
 
 如:
 func addTwoInts(_ a: Int, _ b: Int) -> Int {
     return a + b
 }
 这个函数的类型是(Int,Int)->Int, 可以解读为:“这个函数类型有两个 Int 型的参数并返回一个 Int 型的值”。
 
 如:
 func printHelloWorld() {
     print("hello, world")
 }
 这个函数的类型是：() -> Void，或者叫“没有参数，并返回 Void 类型的函数”。
 */

//2.10 使用函数类型

//”定义一个叫做 mathFunction 的变量，类型是‘一个有两个 Int 型的参数并返回一个 Int 型的值的函数’，并让这个新变量指向 addTwoInts 函数”
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
var mathFunction: (Int, Int) -> Int = addTwoInts
print("Result: \(mathFunction(2, 3))")
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}

// addTwoInts 和 mathFunction 有同样的类型，所以这个赋值过程在 Swift 类型检查（type-check）中是允许的
// 有相同匹配类型的不同函数可以被赋值给同一个变量，就像非函数类型的变量一样
mathFunction = multiplyTwoInts
print("Result: \(mathFunction(2, 3))")

// 就像其他类型一样，当赋值一个函数给常量或变量时，你可以让 Swift 来推断其函数类型：
let anotherMathFunction = addTwoInts

//2.11 函数类型作为参数类型
// 可以用 (Int, Int) -> Int 函数类型作为另一个函数的参数类型
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)

//2.12 函数类型作为返回类型

// 可以用函数类型作为另一个函数的返回类型,需要在返回箭头（->）后写一个完整的函数类型

func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}
var currentValue = 3
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
print(type(of: moveNearerToZero))
print("Counting to zero:")
// Counting to zero:
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")

//2.13 嵌套函数（nested functions）

/**
 定义在全局域中叫做全局函数（global functions）
 
 可以把函数定义在别的函数体中，称作嵌套函数（nested functions）
 */

func chooseStepFunction2(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
var currentValue2 = -4
let moveNearerToZero2 = chooseStepFunction2(backward: currentValue2 > 0)
// moveNearerToZero now refers to the nested stepForward() function
while currentValue2 != 0 {
    print("\(currentValue2)... ")
    currentValue2 = moveNearerToZero2(currentValue2)
}
print("zero!")
