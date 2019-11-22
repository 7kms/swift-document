//
//  main.swift
//  18-扩展
//
//  Created by tangl on 2019/11/22  11:01 AM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation
/**
 扩展 就是为一个已有的类、结构体、枚举类型或者协议类型添加新功能。这包括在没有权限获取原始源代码的情况下扩展类型的能力（即 逆向建模 ）。
 扩展和 Objective-C 中的分类类似。（与 Objective-C 不同的是，Swift 的扩展没有名字。）
 
 Swift 中的扩展可以：
 添加计算型属性和计算型类型属性
 定义实例方法和类型方法
 提供新的构造器
 定义下标
 定义和使用新的嵌套类型
 使一个已有类型符合某个协议
 
 注: 扩展可以为一个类型添加新的功能，但是不能重写已有的功能。
 */


//1. 扩展语法
/**
 使用关键字extension来声明扩展
 
 extension SomeType {
     // 为 SomeType 添加的新功能写到这里
 }
 
 扩展一个已有类型，使其采纳一个或多个协议. 无论是类还是结构体，协议名字的书写方式完全一样：
 extension SomeType: SomeProtocol, AnotherProtocol {
    // 协议实现写到这里
 }
 注: 如果你通过扩展为一个已有类型添加新功能，那么新功能对该类型的所有已有实例都是可用的，即使它们是在这个扩展定义之前创建的。
 */
//2. 计算型属性
/**
 扩展可以为已有类型添加计算型实例属性和计算型类型属性
 */
extension Double {
    var km: Double { return self * 1_000.0 } // 这些属性是只读的计算型属性，为了更简洁，省略了 get 关键字。
    var m : Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")
let aMarathon = 42.km + 195.m
print("A marathon is \(aMarathon) meters long")
/**
 注: 扩展可以添加新的计算型属性，但是不可以添加存储型属性，也不可以为已有属性添加属性观察器。
 */
//3. 构造器
/**
 扩展可以为已有类型添加新的构造器
 扩展能为类添加新的便利构造器，但是它们不能为类添加新的指定构造器或析构器。指定构造器和析构器必须总是由原始的类实现来提供。
 
 注: 如果你使用扩展为一个值类型添加构造器，同时该值类型的原始实现中未定义任何定制的构造器且所有存储属性提供了默认值，那么我们就可以在扩展中的构造器里调用默认构造器和逐一成员构造器。 正如在值类型的构造器代理中描述的，如果你把定制的构造器写在值类型的原始实现中，上述规则将不再适用。
 */
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
/**
 因为结构体 Rect 未提供定制的构造器，因此它会获得一个逐一成员构造器。
 又因为它为所有存储型属性提供了默认值，它又会获得一个默认构造器。
 */
struct Rect {
    var origin = Point()
    var size = Size()
}
let defaultRect = Rect()
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))

// 可以提供一个额外的接受指定中心点和大小的构造器来扩展 Rect 结构体
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - size.width/2
        let originY = center.y - size.height/2
        self.init(origin: Point(x:originX, y:originY), size: size)
    }
}
let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))

//4. 方法
/**
 扩展可以为已有类型添加新的实例方法和类型方法。
 */

// Int 类型添加了一个名为 repetitions 的实例方法
extension Int {
    func repetitions(task: ()->Void) {
        for _ in 0 ..< self {
            task()
        }
    }
}
3.repetitions {
    print("hello")
}

//4.1 可变实例方法
/**
 通过扩展添加的实例方法也可以修改该实例本身
 
 结构体和枚举类型中修改 self 或其属性的方法必须将该实例方法标注为 mutating，正如来自原始实现的可变方法一样。
 */
extension Int {
    
    mutating func square() {
        self = self * self
    }
}

var someInt = 3
someInt.square()
print(someInt)

//5. 下标
/**
 扩展可以为已有类型添加新下标。
 */


/**
 为 Swift 内建类型 Int 添加了一个整型下标。该下标 [n] 返回十进制数字从右向左数的第 n 个数字：
 
 123456789[0] 返回 9
 123456789[1] 返回 8
 */
extension Int {
    subscript (digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex{
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

print(746381295[0])
print(746381295[1])
print(746381295[2])
print(746381295[8])
//如果超出范围, 根据subscript的实现, 会返回0
print(746381295[10])


//6. 嵌套类型
/**
 扩展可以为已有的类、结构体和枚举添加新的嵌套类型：
 */
extension Int {
    // Kind 的枚举表示特定整数的类型
    enum Kind {
        case negative, zero, positive
    }
    
    //计算型实例属性kind，用来根据整数返回适当的 Kind 枚举成员
    var kind: Kind{
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

func printIntegerKinds(_ numbers: Array<Int>) {
    for number in numbers {
        switch number.kind {
        case .negative:
             print("- ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        case .zero:
             print("0 ", terminator: "")
        }
    }
    print("")
}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
