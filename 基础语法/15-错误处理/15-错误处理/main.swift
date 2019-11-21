//
//  main.swift
//  15-错误处理 Error handling
//
//  Created by tangl on 2019/11/21  10:58 AM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation
/**
 错误处理（Error handling）是响应错误以及从错误中恢复的过程。Swift 提供了在运行时对可恢复错误的抛出、捕获、传递和操作的一等公民支持。
 
 注: Swift 中的错误处理涉及到错误处理模式，这会用到 Cocoa 和 Objective-C 中的 NSError。
 */


//1. 表示并抛出错误
/**
 在 Swift 中，错误用符合 Error 协议的类型的值来表示。这个空协议表明该类型可以用于错误处理。
 */

enum VendingMachineError: Error {
    case invalidSelection  //选择无效
    case insufficientFunds(coinsNeeded: Int)//金额不足
    case outOfStock//缺货
}

// 抛出一个错误可以让你表明有意外情况发生，导致正常的执行流程无法继续执行。
//throw VendingMechineError.insufficientFunds(coinsNeeded: 5)


//2. 处理错误
/**
 函数抛出错误时，程序流程会发生改变，所以重要的是你能迅速识别代码中会抛出错误的地方。
 为了标识出这些地方，在调用一个能抛出错误的函数、方法或者构造器之前，使用 do-catch 语句, 或者加上 try 关键字，或者 try? 或 try! 这种变体。这些关键字在下面的小节中有具体讲解。
 
 注: Swift 中的错误处理和其他语言中用 try，catch 和 throw 进行异常处理很像。和其他语言中（包括 Objective-C ）的异常处理不同的是，Swift 中的错误处理并不涉及解除调用栈，这是一个计算代价高昂的过程。就此而言，throw 语句的性能特性是可以和 return 语句相媲美的。
 */
// 2.1 用 throwing 函数传递错误
/**
 为了表示一个函数、方法或构造器可以抛出错误，在函数声明的参数列表之后加上 throws 关键字。一个标有 throws 关键字的函数被称作throwing 函数
 
 注: 只有 throwing 函数可以传递错误。任何在某个非 throwing 函数内部抛出的错误只能在函数内部处理。
 
 func canThrowErrors() throws -> String
 func cannotThorwErrors() -> String
 */


struct Item {
    var price: Int
    var count: Int
}
class VendingMachine {
    var inventory = [
       "Candy Bar": Item(price: 12, count: 7),
       "Chips": Item(price: 10, count: 4),
       "Pretzels": Item(price: 7, count: 11)
    ]
    
    var coinsDeposited = 0
    
    func dispenseSnack(snack: String) {
         print("Dispensing \(snack)")
    }
    
    func vend(itemNamed name: String) throws {
        
        // 使用了 guard 语句来提前退出方法
        guard let item = inventory[name] else {
            
            // throw 语句会立即退出方法，所以物品只有在所有条件都满足时才会被售出
            throw VendingMachineError.invalidSelection
        }
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("dispensing \(name)")
    }
}


let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]


// buyFavoriteSnack(person:vendingMachine:) 是一个 throwing 函数，任何由 vend(itemNamed:) 方法抛出的错误会继续向上抛出
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    
    // vend(itemNamed:) 方法会传递出它抛出的任何错误
    // 要么直接处理这些错误——使用 do-catch 语句，try? 或 try!；要么继续将这些错误传递下去
    try vendingMachine.vend(itemNamed: snackName)
}

struct PurchasedSnack {
    let name: String
    
    
    //throwing 构造器能像 throwing 函数一样传递错误
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}
//2.2 用 Do-Catch 处理错误
/**
 使用一个 do-catch 语句运行一段闭包代码来处理错误。如果在 do 子句中的代码抛出了一个错误，这个错误会与 catch 子句做匹配，从而决定哪条子句能处理它。
 语法:
 do {
     try <#expression#>
     <#statements#>
 } catch <#pattern 1#> {
     <#statements#>
 } catch <#parttern2#> where <#condition#> {
     <#statements#>
 } catch {
     <#statements#>
 }
 */


var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    // 在try 表达式中调用，因为buyFavoriteSnack()能抛出错误。如果错误被抛出，相应的执行会马上转移到 catch 子句中
    // 并判断这个错误是否要被继续传递下去。如果没有错误抛出，do 子句中余下的语句就会被执行。
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}



// 上面的例子可以改写成 如果不是VendingMachineError则交给调用方处理
func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("Invalid selection, out of stock, or not enough money.")
    }
}

do {
    try nourish(with: "Beet-Flavored Chips")
} catch {// 捕获nourish(with:)中抛出的异常
    print("Unexpected non-vending-machine-related error: \(error)")
}

//2.3 将错误转换成可选值
/**
 使用 try? 通过将错误转换成一个可选值来处理错误
 */
func someThrowingFunction() throws -> Int {
    return 0
}
let x = try? someThrowingFunction() //如果 someThrowingFunction() 抛出错误, x的值是nil. 否则是Int?类型
let y: Int?
do {
    try y = someThrowingFunction()
} catch {
    y = nil
}

/**
 func fetchData() -> Data? {
     if let data = try? fetchDataFromDisk() { return data }
     if let data = try? fetchDataFromServer() { return data }
     return nil //如果所有方式都失败了则返回 nil
 }
 */

//2.4 禁用错误传递
/**
  如果你知道某throwing函数实际上在运行时是不会抛出错误,这时可以在表达式前面写 try! 来禁用错误传递.
  这会把调用包装在一个不会有错误抛出的运行时断言中。如果真的抛出了错误，会得到一个运行时错误。
 
  如:
  let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg")
 */

let cc = try! someThrowingFunction()
print(cc) //此时是Int类型, 不是Optional(Int)


//3. 指定清理操作

/**
 
 defer 语句将代码的执行延迟到当前的作用域退出之前。该语句由 defer 关键字和要被延迟执行的语句组成。延迟执行的语句不能包含任何控制转移语句，例如 break、return 语句，或是抛出一个错误
 
 
 延迟执行的操作会按照它们声明的顺序从后往前执行——也就是说，第一条 defer 语句中的代码最后才执行，第二条 defer 语句中的代码倒数第二个执行，以此类推。最后一条语句会第一个执行。
 
 
 func processFile(filename: String) throws {
     if exists(filename) {
         let file = open(filename)
         defer {// defer 语句来确保 open(_:) 函数有一个相应的对 close(_:) 函数的调用。
             close(file)
         }
         while let line = try file.readline() {
             //// 处理文件。
         }
 
 
         // close(file) 会在这里被调用，即作用域的最后。
     }
 }
 */

func testDeffer () throws{
    print("start")
    
    //第一条 defer 语句中的代码最后才执行
    defer {
        print("deffer", 1)
    }
    
    
    
    // 最后一条defer语句会第一个执行。
    defer {
       print("deffer", 2)
    }
    
    print("end")
}

try testDeffer()
