//
//  main.swift
//  07-类和结构体
//
//  Created by tangl on 2019/11/12  12:43 PM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

//1. 类和结构体对比
/**
 Swift 中类和结构体有很多共同点。共同处在于:
 定义属性用于存储值
 定义方法用于提供功能
 定义下标操作通过下标语法可以访问它们的值
 定义构造器用于生成初始化值
 通过扩展以增加默认实现的功能
 遵循协议以提供某种标准功能
 
 
 与结构体相比，类还有如下的附加功能：
 继承允许一个类继承另一个类的特征
 类型转换允许在运行时检查和解释一个类实例的类型
 析构器允许一个类实例释放任何其所被分配的资源
 引用计数允许对一个类的多次引用
 
 结构体总是通过被复制的方式在代码中传递，不使用引用计数。
 */
//1.1 定义语法
/**
 通过关键字 class 和 struct 来分别表示类和结构体
 
 class SomeClass {
     // 在这里定义类
 }
 
 struct SomeStructure {
     // 在这里定义结构体
 }
 
 在你每次定义一个新类或者结构体的时候，实际上你是定义了一个新的 Swift 类型。因此请使用 UpperCamelCase 这种方式来命名（如 SomeClass 和 SomeStructure 等），以便符合标准 Swift 类型的大写命名风格（如 String，Int 和 Bool）。相反的，请使用 lowerCamelCase 这种方式为属性和方法命名（如 framerate 和 incrementCount），以便和类型名区分
 */

struct Resolution {
    var width = 0 // 属性被初始化为整数 0 的时候, 会被推断为 Int 类型
    var height = 0
}

class VideoMode {
    var resolution = Resolution() //类型被推断为 Resolution
    var interlaced = false
    var frameRate = 0.0
    var name: String? //可选类型属性会被自动赋予一个默认值 nil
}
//1.2 类和结构体实例
/**
 结构体和类都使用构造器语法来生成新的实例
 构造器语法的最简单形式是在结构体或者类的类型名称后跟随一对空括号，如 Resolution() 或 VideoMode()
 通过这种方式所创建的类或者结构体实例，其属性均会被初始化为默认值
 */
let someResolution = Resolution()
let someVideoMode = VideoMode()

//1.3 属性访问
//通过点语法来取值和赋值

print("The width of someResolution is \(someResolution.width)")
print("The width of someVideoMode is \(someVideoMode.resolution.width)")


someVideoMode.resolution.width = 1280
print("The width of someVideoMode is now \(someVideoMode.resolution.width)")

//注: 与 Objective-C 语言不同的是，Swift 允许直接设置结构体属性的子属性。上面的最后一个例子，就是直接设置了 someVideoMode 中 resolution 属性的 width 这个子属性，以上操作并不需要重新为整个 resolution 属性设置新值

//1.4 结构体类型的成员逐一构造器
/**
 所有结构体都有一个自动生成的成员逐一构造器，用于初始化新结构体实例中成员的属性
 实例中各个属性的初始值可以通过属性的名称传递到成员逐一构造器之中：
 */
let vga = Resolution(width: 640, height: 480)
//注: 与结构体不同，类实例没有默认的成员逐一构造器

//2. 结构体和枚举是值类型
/**
 值类型被赋予给一个变量、常量或者被传递给一个函数的时候，其值会被拷贝
 
 在 Swift 中，所有的基本类型：整数（Integers）、浮点数（floating-point numbers）、布尔值（Booleans）、字符串（strings)、数组（arrays）和字典（dictionaries），都是值类型，并且在底层都是以结构体的形式所实现
 
 在 Swift 中，所有的结构体和枚举类型都是值类型。这意味着它们的实例，以及实例中所包含的任何值类型属性，在代码中传递的时候都会被复制。
 */
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd //cinema 的值其实是 hd 的一个拷贝副本，而不是 hd 本身, 它们是两个完全不同的实例
cinema.width = 2048

print("cinema is now \(cinema.width) pixels wide")
print("hd is still \(hd.width) pixels wide")

// 枚举也是拷贝赋值
enum CompassPoint {
    case North, South, East, West
}
var currentDirection = CompassPoint.West
let rememberedDirection = currentDirection
currentDirection = .East
if rememberedDirection == .West {
    print("The remembered direction is still .West")
}

//3. 类是引用类型
/**
 引用类型在被赋予到一个变量、常量或者被传递到一个函数时，其值不会被拷贝。因此，引用的是已存在的实例本身而不是其拷贝
 */
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty //类是引用类型，所以 tenEight 和 alsoTenEight 实际上引用的是相同的 VideoMode 实例
alsoTenEighty.frameRate = 30.0

print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")
// 注: tenEighty 和 alsoTenEighty 被声明为常量而不是变量。然而可以改变 tenEighty.frameRate 和 alsoTenEighty.frameRate，因为 tenEighty 和 alsoTenEighty 这两个常量的值并未改变。它们并不“存储”这个 VideoMode 实例，而仅仅是对 VideoMode 实例的引用。所以，改变的是被引用的 VideoMode 的 frameRate 属性，而不是引用 VideoMode 的常量的值

//3.1 恒等运算符
/**
 等价于（===）
 不等价于（!==）
 运用这两个运算符检测两个常量或者变量是否引用同一个实例
 */

if tenEighty === alsoTenEighty {
     print("tenEighty and alsoTenEighty refer to the same Resolution instance.")
}
/**
 “等价于”（用三个等号表示，===）与“等于”（用两个等号表示，==）的不同：
 “等价于”表示两个类类型（class type）的常量或者变量引用同一个类实例。
 “等于”表示两个实例的值“相等”或“相同”，判定时要遵照设计者定义的评判标准. 自定义"=="的实现需要遵循Equatable协议
 */

//3.2 指针
/**
 一个引用某个引用类型实例的 Swift 常量或者变量，与 C 语言中的指针类似，但是并不直接指向某个内存地址，也不要求你使用星号（*）来表明你在创建一个引用。Swift 中的这些引用与其它的常量或变量的定义方式相同
 */

//4. 类和结构体的选择
/**
 按照通用的准则，当符合一条或多条以下条件时，请考虑构建结构体：

 该数据结构的主要目的是用来封装少量相关简单数据值。
 有理由预计该数据结构的实例在被赋值或传递时，封装的数据将会被拷贝而不是被引用。
 该数据结构中储存的值类型属性，也应该被拷贝，而不是被引用。
 该数据结构不需要去继承另一个既有类型的属性或者行为。
 举例来说，以下情境中适合使用结构体：

 几何形状的大小，封装一个 width 属性和 height 属性，两者均为 Double 类型。
 一定范围内的路径，封装一个 start 属性和 length 属性，两者均为 Int 类型。
 三维坐标系内一点，封装 x，y 和 z 属性，三者均为 Double 类型。
 在所有其它案例中，定义一个类，生成一个它的实例，并通过引用来管理和传递。实际中，这意味着绝大部分的自定义数据构造都应该是类，而非结构体。
 
 
 */
//5. 字符串、数组、和字典类型的赋值与复制行为

/**
 Swift 中，许多基本类型，诸如 String，Array 和 Dictionary 类型均以结构体的形式实现。这意味着被赋值给新的常量或变量，或者被传入函数或方法中时，它们的值会被拷贝。

 Objective-C 中 NSString，NSArray 和 NSDictionary 类型均以类的形式实现，而并非结构体。它们在被赋值或者被传入函数或方法时，不会发生值拷贝，而是传递现有实例的引用
 */

/**
 注:
 以上是对字符串、数组、字典的“拷贝”行为的描述。在你的代码中，拷贝行为看起来似乎总会发生。然而，Swift 在幕后只在绝对必要时才执行实际的拷贝。Swift 管理所有的值拷贝以确保性能最优化，所以你没必要去回避赋值来保证性能最优化。
 */
