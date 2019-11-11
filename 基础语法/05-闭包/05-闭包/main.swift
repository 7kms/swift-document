//
//  main.swift
//  05-闭包
//
//  Created by tangl on 2019/11/10  9:02 PM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

/**
 闭包是自包含的函数代码块，可以在代码中被传递和使用。Swift 中的闭包与 C 和 Objective-C 中的代码块（blocks）以及其他一些编程语言中的匿名函数比较相似。
 
 
 闭包可以捕获和存储其所在上下文中任意常量和变量的引用。被称为包裹常量和变量。 Swift 会为你管理在捕获过程中涉及到的所有内存操作。
 
 全局函数是一个有名字但不会捕获任何值的闭包
 嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
 闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常量值的匿名闭包
 */

//1. 闭包表达式
var names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backward(_ s1:String, _ s2:String) -> Bool {
    return s1 > s2
}
names.sort(by: backward)//sorted(by:) 方法接受一个闭包，该闭包函数需要传入与数组元素类型相同的两个值，并返回一个布尔类型值来表明排序规则


//1.1 闭包表达式语法
/**
 { (parameters) -> return type in
     statements
 }
 */

/**
 联闭包参数和返回值类型声明与 backward(_:_:) 函数类型声明相同.
 都是(s1: String, s2: String) -> Bool
 
 在内联闭包表达式中，函数和返回值类型都写在大括号内，而不是大括号外
 闭包的函数体部分由关键字 in 引入
 */
var reversedNames = names.sorted (by: { (s1:String, s2:String) -> Bool in
     return s1 > s2
})

//1.2 根据上下文推断类型
/**
 因为排序闭包函数是作为 sorted(by:) 方法的参数传入的，Swift 可以推断其参数和返回值的类型
 
 sorted(by:) 方法被一个字符串数组调用，因此其参数必须是 (String, String) -> Bool 类型
 
 所以(String, String) 和 Bool 类型并不需要作为闭包表达式定义的一部分
 
 所有的类型都可以被正确推断，返回箭头（->）和参数周围的括号也可以被省略
 
 */

reversedNames = names.sorted(by: { s1, s2 in return s1>s2})
/**
 内联闭包表达式作为函数的参数时，总是能够推断出闭包的参数和返回值类型
 这意味着闭包作为函数或者方法的参数时，几乎不需要利用完整格式构造内联闭包.
 */
print(reversedNames)



//1.3 单行表达式闭包隐式返回
/**
 单行表达式闭包可以通过省略 return 关键字来隐式返回单行表达式的结果
 */
reversedNames = names.sorted(by: {s1,s2 in s1>s2})
print(reversedNames)

//1.4 参数名称缩写
/**
 Swift 自动为内联闭包提供了参数名称缩写功能，你可以直接通过 $0，$1，$2 来顺序调用闭包的参数,以此类推
 
 
 如果在闭包表达式中使用参数名称缩写，可以在闭包定义中省略参数列表，并且对应参数名称缩写的类型会通过函数类型进行推断。in 关键字也同样可以被省略，因为此时闭包表达式完全由闭包函数体构成：
 */

reversedNames = names.sorted(by: {$0 > $1})
print(reversedNames)

//1.5 运算符方法
/**
 wift 的 String 类型定义了关于大于号（>）的字符串实现，其作为一个函数接受两个 String 类型的参数并返回 Bool 类型的值。而这正好与 sorted(by:) 方法的参数需要的函数类型相符合
 
 因此，可以简单地传递一个大于号，Swift 可以自动推断出你想使用大于号的字符串函数实现
 */
reversedNames = names.sorted(by: >)


//2 尾随闭包
/**
 尾随闭包是一个书写在函数括号之后的闭包表达式，函数支持将其作为最后一个参数调用。在使用尾随闭包时，你不用写出它的参数
 
 
 当闭包非常长以至于不能在一行中进行书写时，尾随闭包变得非常有用
 */
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // 函数体部分
}

// 以下是不使用尾随闭包进行函数调用
someFunctionThatTakesAClosure (closure: {
    // 闭包主体部分
})

// 以下是使用尾随闭包进行函数调用
someFunctionThatTakesAClosure() {
    // 闭包主体部分
}

reversedNames = names.sorted(){$0 > $1}

//如果闭包表达式是函数或方法的唯一参数，则当你使用尾随闭包时，你甚至可以把 () 省略掉：
reversedNames = names.sorted{$0 > $1}

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]

let numbers = [16, 58, 510]

// 闭包表达式指定了返回类型为 String , 故strings 常量被推断为字符串类型数组，即 [String]
let strings = numbers.map { (number) -> String in
    var number = number // 局部变量 number 的值由闭包中的 number 参数获得，因此可以在闭包函数体内对其进行修改，(闭包或者函数的参数总是常量)
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output // 由于可以确定 number % 10 总是 digitNames 字典的有效下标，因此!可以用于强制解包（force-unwrap）
        number /= 10
    } while number > 0
    
    return output
}
print(strings)

//3. 值捕获
/**
 闭包可以在其被定义的上下文中捕获常量或变量。即使定义这些常量和变量的原作用域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值。
 
 
 Swift 中，可以捕获值的闭包的最简单形式是嵌套函数。被嵌套函数可以捕获其外部函数所有的参数以及定义的常量和变量。
 
 */

func makeIncrementer(forIncrement amount: Int) -> () -> Int {// 返回类型为 () -> Int。这意味着其返回的是一个函数
    var runningTotal = 0
    func incrementer() -> Int {
        /**
         在函数体内访问了 runningTotal 和 amount 变量。因为从外围函数捕获了 runningTotal 和 amount 变量的引用
         
         捕获引用保证了 runningTotal 和 amount 变量在调用完 makeIncrementer 后不会消失，并且保证了在下一次执行 incrementer 函数时，runningTotal 依旧存在
         */
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
/**
 为了优化，如果一个值不会被闭包改变，或者在闭包创建后不会改变，Swift 可能会改为捕获并保存一份对值的拷贝。

 Swift 也会负责被捕获变量的所有内存管理工作，包括释放不再需要的变量。
 */

let incrementByTen = makeIncrementer(forIncrement: 10)
print(incrementByTen())
print(incrementByTen())
print(incrementByTen())

let incrementBySeven = makeIncrementer(forIncrement: 7)
print(incrementBySeven())// 创建了另一个 incrementer，它会有属于自己的引用，指向一个全新、独立的 runningTotal 变量

/**
 注:
 如果你将闭包赋值给一个类实例的属性，并且该闭包通过访问该实例或其成员而捕获了该实例，你将在闭包和该实例间创建一个循环强引用。Swift 使用捕获列表来打破这种循环强引用
 */

//4. 闭包是引用类型
/**
 上面的例子中，incrementBySeven 和 incrementByTen 都是常量，但是这些常量指向的闭包仍然可以增加其捕获的变量的值。这是因为函数和闭包都是引用类型
 
 将函数或闭包赋值给一个常量或变量，实际上是将常量或变量的值设置为对应函数或闭包的引用。
 上面的例子中，指向闭包的引用 incrementByTen 是一个常量，而并非闭包内容本身
 
 这也意味着如果你将闭包赋值给了两个不同的常量或变量，两个值都会指向同一个闭包
 */

let alsoIncrementByTen = incrementByTen
print(alsoIncrementByTen())

//5. 逃逸闭包
/**
 当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。
 
 当定义接受闭包作为参数的函数时，可以在参数名之前标注@escaping，用来指明这个闭包是允许“逃逸”出这个函数的。
 */

var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}
class SomeClass {
    var x = 10
    func doSomething() {
        
        //将一个闭包标记为 @escaping 意味着必须在闭包中显式地引用 self
        someFunctionWithEscapingClosure { self.x = 100 }
        
        //非逃逸闭包，这意味着它可以隐式引用 self
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)

completionHandlers.first?()
print(instance.x)

//6. 自动闭包
/**
 自动闭包是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。这种闭包不接受任何参数，当它被调用的时候，会返回被包装在其中的表达式的值。这种便利语法让你能够省略闭包的花括号，用一个普通的表达式来代替显式的闭包。
 */

var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)


// customerProvider 的类型不是 String，而是 () -> String
let customerProvider = {
    //在闭包被调用之前，这个元素是不会被移除的
    //如果这个闭包永远不被调用，那么在闭包里面的表达式将永远不会执行
    customersInLine.remove(at: 0)
}

print(customersInLine.count)

print("Now serving \(customerProvider())!")
print(customersInLine.count)



//函数接受一个返回顾客名字的显式的闭包
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )


//通过将参数标记为 @autoclosure 来接收一个自动闭包
//可以将该函数当作接受 String 类型参数（而非闭包）的函数来调用
func serve(customer customerProvider: @autoclosure () -> String) {//customerProvider 参数将自动转化为一个闭包，因为该参数被标记了 @autoclosure 特性
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
/**
 过度使用 autoclosures 会让你的代码变得难以理解。上下文和函数名应该能够清晰地表明求值是被延迟执行的。
 */



//如果想让一个自动闭包可以“逃逸”，则应该同时使用 @autoclosure 和 @escaping 属性
var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
}
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))

print("Collected \(customerProviders.count) closures.")
// 打印 "Collected 2 closures."
for customerProvider in customerProviders {
    print("Now serving \(customerProvider())!")
}
