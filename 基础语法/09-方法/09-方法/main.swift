//
//  main.swift
//  09-方法
//
//  Created by tangl on 2019/11/13  11:14 PM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation
/**
 方法是与某些特定类型相关联的函数
 类、结构体、枚举都可以定义实例方法和类型方法
 */

//1. 实例方法
/**
 实例方法能够隐式访问它所属类型的所有的其他实例方法和属性
 */
class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }
}

let counter = Counter()
counter.increment()
print(counter.count)
counter.increment(by: 5)
print(counter.count)
counter.reset()
print(counter.count)

//1.1 self 属性
/**
 类型的每一个实例都有一个隐含属性叫做 self, self 完全等同于该实例本身
 
 如 increment 方法还可以这样写
 func increment() {
    self.count += 1
 }
 
 只要在一个方法中使用一个已知的属性或者方法名称，如果你没有明确地写 self，Swift 假定你是指当前实例的属性或者方法
 */
struct Point {
    var x = 0.0, y = 0.0
    func isToTheRightOfX(_ x: Double) -> Bool {
        // 当参数名和实例属性重复时, 使用self关键字, 消除歧义
        return self.x > x
        
        //如果不使用 self 前缀，Swift 就认为两次使用的 x 都指的是名称为 x 的函数参数
    }
}
let somePoint = Point(x: 4.0, y: 5.0)

if somePoint.isToTheRightOfX(1.0) {
    print("This point is to the right of the line where x == 1.0")
}

//1.2 在实例方法中修改值类型

/**
 在某个特定的方法中修改结构体或者枚举的属性，需要为这个方法选择 可变（mutating）行为.
 
 
 方法还可以给它隐含的 self 属性赋予一个全新的实例，这个新实例在方法结束时会替换现存实例。
 */
struct Point2 {
    var x = 0.0, y = 0.0
    mutating func moveByX(_ deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

var sompoint2 = Point2(x: 1.0, y: 1) //使用var定义结构体才能调用mutating方法
sompoint2.moveByX(2.0, y: 3.0)
print("The point is now at (\(sompoint2.x), \(sompoint2.y))")

//不能在结构体类型的常量（a constant of structure type）上调用可变方法，因为其属性不能被改变，即使属性是变量属性

//let fixedPoint = Point2()
//fixedPoint.moveByX(0, y: 0)// 编译错误: Cannot use mutating member on immutable value: 'fixedPoint' is a 'let' constant

//1.3 在可变方法中给 self 赋值
/**
 可变方法能够赋给隐含属性 self 一个全新的实例
 */
struct Point3 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        //创建了一个新的结构体实例，它的 x 和 y 的值都被设定为目标值。调用这个版本的方法和调用上个版本的最终结果是一样的
        self = Point3(x: x + deltaX, y: y + deltaY)
    }
}



/**
 定义了一个三态开关的枚举。每次调用 next() 方法时，开关在不同的电源状态（Off，Low，High）之间循环切换。
 */
enum TriStateSwitch {
    case Off, Low, High
    mutating func next() {
        // 枚举的可变方法可以把 self 设置为同一枚举类型中不同的成员
        switch self {
            case .Off:
                self = .Low
            case .Low:
                self = .High
            case .High:
                self = .Off
        }
    }
}

var ovenLight = TriStateSwitch.Low
print(ovenLight)
ovenLight.next()
print(ovenLight)
ovenLight.next()
print(ovenLight)

//2. 类型方法
/**
 可以定义在类型本身上调用的方法，这种方法就叫做类型方法
 
 语法: 在方法的 func 关键字之前加上关键字 static
 
 类还可以用关键字 class 来允许子类重写父类的方法实现
 */
/**
 注: 在 Objective-C 中，你只能为 Objective-C 的类类型（classes）定义类型方法（type-level methods）。在 Swift 中，你可以为所有的类、结构体和枚举定义类型方法。每一个类型方法都被它所支持的类型显式包含
 */

class SomeClass {
    class func someTypeMethod() {
        // 在这里实现类型方法
    }
}
SomeClass.someTypeMethod()


struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1

    static func unlock(_ level: Int) {
        //在类型方法中可以直接通过类型属性的名称访问本类中的类型属性，而不需要前面加上类型名称。
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    }

    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }

    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player {
    var tracker = LevelTracker()
    let playerName: String
    func complete(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)
    }
    init(name: String) {
        playerName = name
    }
}

var player = Player(name: "Argyrios")
player.complete(level: 1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")

player = Player(name: "Beto")
if player.tracker.advance(to: 6) {
    print("player is now on level 6")
} else {
    print("level 6 has not yet been unlocked")
}
