//
//  main.swift
//  08-属性
//
//  Created by tangl on 2019/11/12  2:12 PM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

/**
 属性将值跟特定的类、结构体或枚举关联
 */

//1. 存储属性
/**
一个存储属性就是存储在特定类或结构体实例里的一个常量或变量
 存储属性可以是变量存储属性（用关键字 var 定义），也可以是常量存储属性（用关键字 let 定义）
 */
struct FixedLengthRange {
    var firstValue: Int
    let length: Int //常量存储属性，初始化之后无法修改它的值
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
print(rangeOfThreeItems.firstValue)

//1.1 常量结构体的存储属性
// 将结构体的实例赋值给一个常量，则无法修改该实例的任何属性，即使有属性被声明为变量也不行
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
//rangeOfFourItems.firstValue = 6 编译错误
//由于结构体（struct）属于值类型。当值类型的实例被声明为常量的时候，它的所有属性也就成了常量。

//1.2 延迟存储属性
/**
 
 在属性声明前使用 lazy 来标示一个延迟存储属性,当第一次被调用的时候才会计算其初始值的属性
 
 必须将延迟存储属性声明成变量（使用 var 关键字），因为属性的初始值可能在实例构造完成之后才会得到。而常量属性在构造过程完成之前必须要有初始值，因此无法声明成延迟属性
 
 
 注: 如果一个被标记为 lazy 的属性在没有初始化时就同时被多个线程访问，则无法保证该属性只会被初始化一次
 */

class DataImporter {
    /*
    DataImporter 是一个负责将外部文件中的数据导入的类。
    这个类的初始化会消耗不少时间。
    */
    var fileName = "data.txt"
    // 这里会提供数据导入功能
    
    init() {
        print("DataImporter init")
    }
}

class DataManager {
    lazy var importer = DataImporter() //使用lazy，importer 属性只有在第一次被访问的时候才被创建
    var data = [String]()
    // 这里会提供数据管理功能
}
let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
// DataImporter 实例的 importer 属性还没有被创建
print(manager.importer.fileName)

//1.3 存储属性和实例变量
/**
 Swift 中的属性没有对应的实例变量，属性的后端存储也无法直接访问。这就避免了不同场景下访问方式的困扰，同时也将属性的定义简化成一个语句。属性的全部信息——包括命名、类型和内存管理特征——作为类型定义的一部分，都定义在一个地方。
 */

//2. 计算属性
/**
 类、结构体和枚举可以定义计算属性。计算属性不直接存储值，而是提供一个 getter 和一个可选的 setter，来间接获取和设置其他属性或变量的值
 */

struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0),
    size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")

//2.1 简化 Setter 声明

// 如果计算属性的 setter 没有定义表示新值的参数名，则可以使用默认名称 newValue
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

//1.2 只读计算属性
/**
 只有 getter 没有 setter 的计算属性就是只读计算属性, 只能取值, 不能赋值
 
 注: 必须使用 var 关键字定义计算属性，包括只读计算属性，因为它们的值不是固定的。let 关键字只用来声明常量属性，表示初始化后再也无法修改的值
 */
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double{ //只读计算属性的声明可以去掉 get 关键字
       return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")

//3. 属性观察器
/**
 属性观察器监控和响应属性值的变化，每次属性被设置值的时候都会调用属性观察器，即使新值和当前值相同的时候也不例外
 
 willSet 在新的值被设置之前调用
 didSet 在新的值被设置之后立即调用
 
 父类的属性在子类的构造器中被赋值时，它在父类中的 willSet 和 didSet 观察器会被调用，随后才会调用子类的观察器。在父类初始化方法调用之前，子类给属性赋值时，观察器不会被调用
 */

class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {// didSet 没有为旧值提供自定义名称，所以默认值 oldValue 表示旧值的参数名
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
stepCounter.totalSteps = 360
stepCounter.totalSteps = 896

/**
 如果将属性通过 in-out 方式传入函数，willSet 和 didSet 也会调用。这是因为 in-out 参数采用了拷入拷出模式：即在函数内部使用的是参数的 copy，函数结束后，又对参数重新赋值
 */
func changeSteps(_ step: inout Int) {
    step += 1
}
changeSteps(&stepCounter.totalSteps)

//5. 包装属性(Property Wrappers)

/**
 定义包装属性:
 创建一个 structure, enumeration, 或 class 并在其中定义一个wrappedValue的属性
 */

// 定义包装属性
@propertyWrapper
struct TwelveOrLess {
    private var number = 0 // private关键字, 表示该属性只能在TwelveOrLess内部访问
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}

//应用包装属性
struct SmallRectangle {
   @TwelveOrLess var height: Int
   @TwelveOrLess var width: Int
}


var rectangle = SmallRectangle()
print(rectangle.height)

rectangle.height = 10
print(rectangle.height)

rectangle.height = 24
print(rectangle.height)

/**
 当在属性上使用包装器时, 编译器会合成该属性的存储和访问代码
 如果不使用属性包装器@TwelveOrLess, 则用如下代码表示
 */
struct SmallRectangle2 {
    private var _height = TwelveOrLess()
    private var _width = TwelveOrLess()
    var height: Int {
        get { return _height.wrappedValue }
        set { _height.wrappedValue = newValue }
    }
    var width: Int {
        get { return _width.wrappedValue }
        set { _width.wrappedValue = newValue }
    }
}

//5.1 包装属性的初始值(Setting Initial Values for Wrapped Properties)
@propertyWrapper
struct SmallNumber {
    private var maximum: Int
    private var number: Int

    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, maximum) }
    }

    init() {
        maximum = 12
        number = 1
    }
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
    }
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
    }
}
//


// 当使用包装器并且未提供初始值时,Swift使用init()构造函数为包装器设置初始值
// (此语法(@SmallNumbervar height: Int)在xcode11.2beta上编译报错, 直接用swift命令行运行是ok的)
struct ZeroRectangle {
    @SmallNumber() var height: Int // @SmallNumber支持设置初始值
    @SmallNumber(wrappedValue: 2) var width: Int
}

var zeroRectangle = ZeroRectangle()
print(zeroRectangle.height, zeroRectangle.width)


struct UnitRectangle {
    @SmallNumber var height: Int = 1// @SmallNumber支持设置初始值
    @SmallNumber var width: Int = 1 //转换为调用init(wrappedValue:) initializer
}
var unitRectangle = UnitRectangle()
print(unitRectangle.height, unitRectangle.width)


struct NarrowRectangle {
    @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
    @SmallNumber(wrappedValue: 3, maximum: 4) var width: Int
}
var narrowRectangle = NarrowRectangle()
print(narrowRectangle.height, narrowRectangle.width)


narrowRectangle.height = 100
narrowRectangle.width = 100
print(narrowRectangle.height, narrowRectangle.width)


/**
 使用包装器时, 也可以同时指定初始值
 */
struct MixedRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber(maximum: 9) var width: Int = 120 // 指定的初始值(这里是120)将被视为wrappedValue, 连同maximum: 9, 找到对应的构造器init(wrappedValue: Int, maximum: Int)
}
/**
 其中height属性的实际创建方式:  SmallNumber(wrappedValue: 1)
 其中width属性的实际创建方式:   SmallNumber(wrappedValue: 120, maximum: 9)
 */
var mixedRectangle = MixedRectangle()
print(mixedRectangle.height,mixedRectangle.width)

// 5.1 包装属性的投影(Projecting a Value From a Property Wrapper)
/**
 除了被包装的属性, 包装器还可以定义投影属性.
 语法:
    1. 定义: 在包装器的定义里面添加projectedValue属性
    2. 访问: 在被包装的属性前面添加$符号
 */
@propertyWrapper
struct SmallNumber3 {
    private var number = 0
    var projectedValue = false //记录包装属性是否被调整过
    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }
}
struct SomeStructure3 {
    @SmallNumber3 var someNumber: Int
}
var someStructure3 = SomeStructure3()

someStructure3.someNumber = 4
print(someStructure3.$someNumber) //$someNumber可以访问投影属性 projectedValue
// Prints "false"

someStructure3.someNumber = 55
print(someStructure3.$someNumber)

/**
 
 包装器可以返回任意类型的投影属性, 当需要返回的信息量越大时, 可以返回其他类型的实例.
 也可以返回self
 */

enum Size2 {
    case small, large
}

/**
 属性包装器, 是针对属性的setter和getter的语法糖
 访问height,width属性同访问其他属性一样
 */
struct SizedRectangle {
    @SmallNumber3 var height: Int
    @SmallNumber3 var width: Int

    mutating func resize(to size: Size2) -> Bool {
        switch size {
        case .small:
            height = 10
            width = 20
        case .large:
            height = 100
            width = 100
        }
        return $height || $width
    }
}


//6. 全局变量和局部变量
/**
 计算属性和属性观察器所描述的功能也可以用于全局变量和局部变量
 全局变量: 是在函数、方法、闭包或任何类型之外定义的变量。
 局部变量: 是在函数、方法或闭包内部定义的变量。
 
 
 注: 全局的常量或变量都是延迟计算的，跟延迟存储属性相似，不同的地方在于，全局的常量或变量不需要标记 lazy 修饰符
 局部范围的常量或变量从不延迟计算
 局部范围的常量或变量从不延迟计算
 */


//7. 类型属性
/**
为类型本身定义属性，无论创建了多少个该类型的实例，这些属性都只有唯一一份。这种属性就是类型属性
 
 
存储型类型属性可以是变量或常量，计算型类型属性跟实例的计算型属性一样只能定义成变量属性
 
 注: 跟实例的存储型属性不同，必须给存储型类型属性指定默认值，因为类型本身没有构造器，也就无法在初始化过程中使用构造器给类型属性赋值
 存储型类型属性是延迟初始化的，它们只有在第一次被访问的时候才会被初始化。即使它们被多个线程同时访问，系统也保证只会对其进行一次初始化，并且不需要对其使用 lazy 修饰符
 */
//7.1 类型属性语法
/**
 在 C 或 Objective-C 中，与某个类型关联的静态常量和静态变量，是作为全局（global）静态变量定义的
 
 在 Swift 中，类型属性是作为类型定义的一部分写在类型最外层的花括号内，因此它的作用范围也就在类型支持的范围内。
 
 使用关键字 static 来定义类型属性。
 在为类定义计算型类型属性时，可以改用关键字 class 来支持子类对父类的实现进行重写
 */


struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}

enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}

class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
// 注: 例子中的计算型类型属性是只读的，但也可以定义可读可写的计算型类型属性，跟计算型实例属性的语法相同。

//7.1 获取和设置类型属性的值


print(SomeStructure.storedTypeProperty) //类型属性是通过类型本身来访问，而不是通过实例
SomeStructure.storedTypeProperty = "Another value."
print(SomeStructure.storedTypeProperty)


print(SomeEnumeration.computedTypeProperty)
print(SomeClass.computedTypeProperty)



struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            
            if currentLevel > AudioChannel.thresholdLevel {
                //didSet 属性观察器将 currentLevel 设置成了不同的值，但这不会造成属性观察器被再次调用。
                currentLevel = AudioChannel.thresholdLevel// 将当前音量限制在阈值之内
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                
                AudioChannel.maxInputLevelForAllChannels = currentLevel
                // 存储当前音量作为新的最大输入音量
            }
        }
    }
}

var leftChannel = AudioChannel()
var rightChannel = AudioChannel()
leftChannel.currentLevel = 7
print(leftChannel.currentLevel)
print(AudioChannel.maxInputLevelForAllChannels)

rightChannel.currentLevel = 11
print(rightChannel.currentLevel)
print(AudioChannel.maxInputLevelForAllChannels)
