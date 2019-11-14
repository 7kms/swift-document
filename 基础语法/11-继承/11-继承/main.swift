//
//  main.swift
//  11-继承
//
//  Created by tangl on 2019/11/14  11:14 PM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

/**
 一个类可以继承另一个类的方法，属性和其它特性。当一个类继承其它类时，继承类叫子类，被继承类叫超类（或父类）。
 在 Swift 中，继承是区分「类」与其它类型的一个基本特征
 
 在 Swift 中，类可以调用和访问超类的方法、属性和下标，并且可以重写这些方法，属性和下标来优化或修改它们的行为。Swift 会检查你的重写定义在超类中是否有匹配的定义，以此确保你的重写行为是正确的。

 可以为类中继承来的属性添加属性观察器，这样一来，当属性值改变时，类就会被通知到。可以为任何属性添加属性观察器，无论它原本被定义为存储型属性还是计算型属性。
 */

//1. 定义一个基类
/**
 不继承于其它类的类，称之为基类。
 
 注:Swift 中的类并不是从一个通用的基类继承而来。如果你不为你定义的类指定一个超类的话，这个类就自动成为基类。
 */

class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
         // 什么也不做-因为车辆不一定会有噪音
    }
}

let someVehicle = Vehicle()
print(someVehicle)
print("Vehicle: \(someVehicle.description)")

//2. 子类生成
/**
 子类生成指的是在一个已有类的基础上创建一个新的类。子类继承超类的特性，并且可以进一步完善。你还可以为子类添加新的特性。
 
 语法:
 
 class SomeClass: SuperClass {
     // 这里是子类的定义
 }
 */


class Bicycle: Vehicle{
    var hasBasket = false
}

let bicycle = Bicycle()
bicycle.hasBasket = true
bicycle.currentSpeed = 15.0 //可以修改 Bicycle 实例所继承的 currentSpeed 属性
print("Bicycle: \(bicycle.description)")

//子类还可以继续被其它类继承
class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}
let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")
//3. 重写
/**
 子类可以为继承来的实例方法，类方法，实例属性，或下标提供自己定制的实现。我们把这种行为叫重写
 子类无法重写类属性(static 修饰的属性)
 
 语法: 在需要重写的类,属性,下标前面添加override关键字. 这表明了你是想提供一个重写版本，而非错误地提供了一个相同的定义. 任何缺少 override 关键字的重写都会在编译时被诊断为错误
 
 override 关键字会提醒 Swift 编译器去检查该类的超类（或其中一个父类）是否有匹配重写版本的声明。这个检查可以确保你的重写定义是正确的
 */

//3.1 访问超类的方法，属性及下标
/**
 在合适的地方，你可以通过使用 super 前缀来访问超类版本的方法，属性或下标
 
 在方法 someMethod() 的重写实现中，可以通过 super.someMethod() 来调用超类版本的 someMethod() 方法。
 在属性 someProperty 的 getter 或 setter 的重写实现中，可以通过 super.someProperty 来访问超类版本的 someProperty 属性。
 在下标的重写实现中，可以通过 super[someIndex] 来访问超类版本中的相同下标
 
 */

//3.2 重写方法
class Train: Vehicle {
    // 重写了从 Vehicle 类继承来的 makeNoise() 方法
    override func makeNoise() {
        print("Choo Choo")
    }
}

let train = Train()
train.makeNoise()

//3.3 重写属性
/**
 你可以重写继承来的实例属性或类型属性，提供自己定制的 getter 和 setter，或添加属性观察器使重写的属性可以观察属性值什么时候发生改变
 */
//3.3.1 重写属性的 Getters 和 Setters
/**
 可以提供getter或setter来重写任何属性(存储属性, 计算型属性).
 子类无法知道继承来的属性是什么类型(存储属性, 计算型属性),只知道继承属性名字和类型.
 
 在重写一个属性时，必需将它的名字和类型都写出来。这样才能使编译器去检查你重写的属性是与超类中同名同类型的属性相匹配的。
 
 可以将一个继承来的只读属性重写为一个读写属性，只需要在重写版本的属性里提供 getter 和 setter 即可。
 但是，你不可以将一个继承来的读写属性重写为一个只读属性
 */

/**
 注: 如果你在重写属性中提供了 setter，那么你也一定要提供 getter。如果你不想在重写版本中的 getter 里修改继承来的属性值，你可以直接通过 super.someProperty 来返回继承来的值
 */


class Car: Vehicle {
    var gear = 1
    override var description: String{
        return super.description + " in gear \(gear)"
    }
}
let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")


//3.3.2 重写属性观察器
/**
 你可以通过重写属性为一个继承来的属性添加属性观察器
 
 注: 你不可以为继承来的常量存储型属性或继承来的只读计算型属性添加属性观察器。这些属性的值是不可以被设置的，所以，为它们提供 willSet 或 didSet 实现是不恰当
 
 注: 你不可以同时提供重写的 setter 和重写的属性观察器。如果你想观察属性值的变化，并且你已经为那个属性提供了定制的 setter，那么你在 setter 中就可以观察到任何值变化了。
 */
class AutomaticCar: Car {
    override var currentSpeed: Double{
        didSet {
            gear = Int(currentSpeed/10.0) + 1
        }
    }
}

let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")

//4. 防止重写
/**
 只需要在声明关键字前加上 final 修饰符即可（例如：final var，final func，final class func，以及 final subscript）
 
 任何试图对带有 final 标记的方法、属性或下标进行重写，都会在编译时会报错。在类扩展中的方法，属性或下标也可以在扩展的定义里标记为 final 的
 
 你可以通过在关键字 class 前添加 final 修饰符（final class）来将整个类标记为 final 的。这样的类是不可被继承的，试图继承这样的类会导致编译报错
 */
