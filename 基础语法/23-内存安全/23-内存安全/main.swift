//
//  main.swift
//  23-内存安全
//
//  Created by tangl on 2019/12/5  12:17 AM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

/**
 这里访问冲突的讨论是在单线程的情境下讨论的，并没有使用并发或者多线程。

 如果你曾经在单线程代码里有访问冲突，Swift 可以保证你在编译或者运行时会得到错误。对于多线程的代码，可以使用 Thread Sanitizer 去帮助检测多线程的冲突。
 */

//1. 理解内存访问冲突

/**
 内存访问的冲突会发生在你的代码尝试同时访问同一个存储地址的时侯。同一个存储地址的多个访问同时发生会造成不可预计或不一致的行为。在 Swift 里，有很多修改值的行为都会持续好几行代码，在修改值的过程中进行访问是有可能发生的。
 */
let a = {
    // 向 one 所在的内存区域发起一次写操作
    let one = 1
    
    // 向 one 所在的内存区域发起一次读操作
    print("We're number \(one)!")

}
a()

//1.1 内存访问冲突的典型状况
/**
 内存访问冲突有三种典型的状况：访问是读还是写，访问的时长，以及被访问的存储地址
 
 当你有两个访问符合下列的情况：
 至少有一个是写访问
 它们访问的是同一个存储地址
 它们的访问在时间线上部分重叠
 
 读和写访问的区别很明显：一个写访问会改变存储地址，而读操作不会。存储地址会指向真正访问的位置(一个变量，常量或者属性)。内存访问的时长要么是瞬时的，要么是长期的。
 瞬时访问和长期访问的区别在于别的代码有没有可能在访问期间同时访问，也就是在时间线上的重叠。一个长期访问可以被别的长期访问或瞬时访问重叠。
 
 重叠的访问主要出现在使用 in-out 参数的函数和方法或者结构体的 mutating 方法里
 */


//2. In-Out 参数的访问冲突
/**
 一个函数会对它所有的 in-out 参数进行长期写访问。in-out 参数的写访问会在所有非 in-out 参数处理完之后开始，直到函数执行完毕为止。如果有多个 in-out 参数，则写访问开始的顺序与参数的顺序一致。
 */
let b = {
    var stepSize = 1
    // 长期访问的存在会造成一个结果，你不能在原变量以 in-out 形式传入后访问原变量，即使作用域原则和访问权限允许 —— 任何访问原变量的行为都会造成冲突。
    func increment(_ number: inout Int) {
        number += stepSize
    }
    // 运行时错误
    //increment(&stepSize) // Thread 1: Simultaneous accesses to 0x100002088, but modification requires exclusive access
    print(stepSize)
}()

let c = {
    var stepSize = 1

    func increment(_ number: inout Int) {
        number += stepSize
    }
    
    // 复制一份副本
    var copyOfStepSize = stepSize
    increment(&copyOfStepSize)

    // 更新原来的值
    stepSize = copyOfStepSize
    
    print(stepSize)
}()



let d = {
    // 长期写访问的存在还会造成另一种结果，往同一个函数的多个 in-out 参数里传入同一个变量也会产生冲突
    func balance(_ x: inout Int, _ y: inout Int) {
        let sum = x + y
        x = sum / 2
        y = sum - x
    }
    var playerOneScore = 42
    var playerTwoScore = 30
    balance(&playerOneScore, &playerTwoScore)  // 正常
    
    // 编译错误
    // 因为它会发起两个写访问，同时访问同一个的存储地址。
    // balance(&playerOneScore, &playerOneScore) //Inout arguments are not allowed to alias each other
    
    /**
     注: 因为操作符也是函数，它们也会对 in-out 参数进行长期访问。例如，假设 balance(_:_:) 是一个名为 <^> 的操作符函数，那么 playerOneScore <^> playerOneScore 也会造成像 balance(&playerOneScore, &playerOneScore) 一样的冲突。
     */
}
d()
//3. 函数里 self 的访问冲突
/**
 一个结构体的 mutating 方法会在调用期间对 self 进行写访问。
 */
struct Player {
    var name: String
    var health: Int
    var energy: Int

    static let maxHealth = 10
    
    // restoreHealth() 方法里，一个对于 self 的写访问会从方法开始直到方法 return
    // restoreHealth() 里的其它代码不可以对 Player 实例的属性发起重叠的访问
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}
func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}

extension Player {
    mutating func shareHealth(with teammate: inout Player) {
        // 在调用过程中会对teammate和self发起写访问(teammate作为inout参数传入, &health隐式访问self)
        // 只要teammate和self不是相同的内存地址(它们会访问内存的不同位置) 。即使两个写访问重叠了，它们也不会冲突。
        balance(&teammate.health, &health)
    }
}
var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)

// 调用 shareHealth(with:) 方法去把 oscar 玩家的血量分享给 maria 玩家并不会造成冲突
oscar.shareHealth(with: &maria)

//如果你将 oscar 作为参数传入 shareHealth(with:) 里，就会产生冲突
//oscar.shareHealth(with: &oscar) // Inout arguments are not allowed to alias each other
/**
 mutating 方法在调用期间需要对 self 发起写访问，而同时 in-out 参数也需要写访问。在方法里，self 和 teammate 都指向了同一个存储地址
 对于同一块内存同时进行两个写访问，并且它们重叠了，就此产生了冲突。
 */

//4. 属性的访问冲突
/**
 如结构体，元组和枚举的类型都是由多个独立的值组成的，例如结构体的属性或元组的元素。因为它们都是值类型，修改值的任何一部分都是对于整个值的修改，意味着其中一个属性的读或写访问都需要访问整一个值。例如，元组元素的写访问重叠会产生冲突：
 */
var playerInformation = (health: 10, energy: 20)
// 运行时错误 playerInformation 的属性访问冲突
// Thread 1: Simultaneous accesses to 0x1000030f8, but modification requires exclusive access
//balance(&playerInformation.health, &playerInformation.energy)
/**
 任何情况下，对于元组元素的写访问都需要对整个元组发起写访问。这意味着对于 playerInfomation 发起的两个写访问重叠了，造成冲突
 */

var holly = Player(name: "Holly", health: 10, energy: 10)
// 运行时错误 Thread 1: Simultaneous accesses to 0x100003108, but modification requires exclusive access
// 对于一个存储在全局变量里的结构体属性的写访问重叠了
// balance(&holly.health, &holly.energy)

// 在实践中，大多数对于结构体属性的访问都会安全的重叠
func someFunction() {
    var oscar = Player(name: "Oscar", health: 10, energy: 10)
    // oscar 的 health 和 energy 都作为 in-out 参数传入了 balance(_:_:) 里。编译器可以保证内存安全，因为两个存储属性任何情况下都不会相互影响
    balance(&oscar.health, &oscar.energy)  // 正常
}

someFunction()


/**
 限制结构体属性的重叠访问对于内存安全并不总是必要的。内存安全是必要的，但访问独占权的要求比内存安全还要更严格 —— 意味着即使有些代码违反了访问独占权的原则，也是内存安全的。如果编译器可以保证这种非专属的访问是安全的，那 Swift 就会允许这种内存安全的行为。特别是当你遵循下面的原则时，它可以保证结构体属性的重叠访问是安全的：
 
 你访问的是实例的存储属性，而不是计算属性或类的属性
 结构体是本地变量的值，而非全局变量
 结构体要么没有被闭包捕获，要么只被非逃逸闭包捕获了
 */
