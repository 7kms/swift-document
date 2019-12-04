//
//  main.swift
//  22-自动引用计数
//
//  Created by tangl on 2019/12/4  11:36 AM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

/**
 Swift 使用自动引用计数（ARC）机制来跟踪和管理你的应用程序的内存。
 
 注: 引用计数仅仅应用于类的实例。结构体和枚举类型是值类型，不是引用类型，也不是通过引用的方式存储和传递。
 */

//1. 自动引用计数的工作机制
/**
 1). 当创建一个类的新的实例的时候，ARC 会分配一块内存来储存该实例信息。内存中会包含实例的类型信息，以及这个实例所有相关的存储型属性的值。
 2). 当实例不再被使用时，ARC 释放实例所占用的内存，并让释放的内存能挪作他用。这确保了不再被使用的实例，不会一直占用内存空间。
 3). 当 ARC 收回和释放了正在被使用中的实例，该实例的属性和方法将不能再被访问和调用. 如果你试图访问这个实例，应用程序很可能会崩溃。
 4). 为了确保使用中的实例不会被销毁，ARC 会跟踪和计算每一个实例正在被多少属性，常量和变量所引用。实例的引用数为大于0，ARC 都不会销毁这个实例
 5). 无论你将实例赋值给属性、常量或变量，它们都会创建此实例的强引用。之所以称之为“强”引用，是因为它会将实例牢牢地保持住，只要强引用还在，实例是不允许被销毁的。
 */

//2. 自动引用计数实践
/**
 ARC 会跟踪你所新创建的 Person 实例的引用数量，并且会在 Person 实例不再被需要时销毁它
 */
class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        //析构函数会在实例被销毁时调用
        print("\(name) is being deinitialized")
    }
}
var reference1: Person?
var reference2: Person?
var reference3: Person?
reference1 = Person(name: "John Appleseed") // Person实例被赋值给了 reference1 变量，所以 reference1 到 Person 类的新实例之间建立了一个强引用
reference2 = reference1 // 同一个 Person 实例赋值给其他变量，该实例就会多出一个强引用
reference3 = reference1
reference1 = nil
reference2 = nil
reference3 = nil // 是最后一个强引用被断开时，ARC 会销毁它
//3. 类实例之间的循环强引用
/**
 如果两个类实例互相持有对方的强引用，因而每个实例都让对方一直存在，就是这种情况。这就是所谓的循环强引用。
 
 可以通过定义类之间的关系为弱引用或无主引用，以替代强引用，从而解决循环强引用的问题
 */
print("-------------")
class Person2 {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person2?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person2?
var unit4A: Apartment?

john = Person2(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

// 将两个实例关联到一起
john?.apartment = unit4A
unit4A?.tenant = john

// 当你把这两个变量设为 nil 时，没有任何一个析构函数被调用。循环强引用会一直阻止 Person 和 Apartment 类实例的销毁，这就在你的应用程序中造成了内存泄漏
john = nil
unit4A = nil
//4. 解决实例之间的循环强引用
/**
 1). 弱引用（weak reference）
 2). 无主引用（unowned reference）
 弱引用和无主引用允许循环引用中的一个实例引用而另外一个实例不保持强引用
 */
//4.1 弱引用
/**
 弱引用不会对其引用的实例保持强引用，因而不会阻止 ARC 销毁被引用的实例
 语法: 声明属性或者变量，在前面加上 weak 关键字表明这是一个弱引用。
 1). 因为弱引用不会保持所引用的实例，即使引用存在，实例也有可能被销毁
 2). ARC 会在引用的实例被销毁后自动将其赋值为 nil
 3). 弱引用只能定义成可选类型变量(因为弱引用可以允许它们的值在运行时被赋值为 nil)
 
 注: 当 ARC 设置弱引用为 nil 时，属性观察不会被触发。
 */
var c = {
    class Person {
        let name: String
        init(name: String) { self.name = name }
        var apartment: Apartment?
        deinit { print("\(name) is being deinitialized") }
    }

    class Apartment {
        let unit: String
        init(unit: String) { self.unit = unit }
        weak var tenant: Person?
        deinit { print("Apartment \(unit) is being deinitialized") }
    }
    var john: Person?
    var unit4A: Apartment?

    john = Person(name: "John Appleseed")
    unit4A = Apartment(unit: "4A")

    john!.apartment = unit4A
    unit4A!.tenant = john
}
c()
/**
 注: 在使用垃圾收集的系统里，弱指针有时用来实现简单的缓冲机制，因为没有强引用的对象只会在内存压力触发垃圾收集时才被销毁。但是在 ARC 中，一旦值的最后一个强引用被移除，就会被立即销毁，这导致弱引用并不适合上面的用途。
 */
//4.2 无主引用
/**
 和弱引用类似，无主引用不会牢牢保持住引用的实例。和弱引用不同的是，无主引用在其他实例有相同或者更长的生命周期时使用
 语法: 在声明属性或者变量时，在前面加上关键字 unowned 表示这是一个无主引用
 
 无主引用通常都被期望拥有值。不过 ARC 无法在实例被销毁后将无主引用设为 nil，因为非可选类型的变量不允许被赋值为 nil
 
 注: 使用无主引用，你必须确保引用始终指向一个未销毁的实例。如果你试图在实例被销毁后，访问该实例的无主引用，会触发运行时错误。
 */
print("-------------")

let d = {
    class Customer {
        let name: String
        var card: CreditCard? // Customer 实例持有对 CreditCard 实例的强引用
        init(name: String) {
            self.name = name
        }
        deinit { print("\(name) is being deinitialized") }
    }
    
    class CreditCard {
        let number: UInt64 //CreditCard 类的 number 属性被定义为 UInt64 类型而不是 Int 类型，以确保 number 属性的存储量在 32 位和 64 位系统上都能足够容纳 16 位的卡号。
        unowned let customer: Customer //CreditCard 实例持有对 Customer 实例的无主引用
        init(number: UInt64, customer: Customer) {
            self.number = number
            self.customer = customer
        }
        deinit { print("Card #\(number) is being deinitialized") }
    }
    
    var john: Customer?
    john = Customer(name: "John Appleseed")
    john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
    
    // 断开 john 变量持有的强引用时，再也没有指向 Customer 实例的强引用了
    // 由于再也没有指向 Customer 实例的强引用，该实例被销毁了。其后，再也没有指向 CreditCard 实例的强引用，该实例也随之被销毁了：
    john = nil
    
    
    /**
     注:  上面的例子展示了如何使用安全的无主引用。对于需要禁用运行时的安全检查的情况（例如，出于性能方面的原因），Swift 还提供了不安全的无主引用。与所有不安全的操作一样，你需要负责检查代码以确保其安全性。 你可以通过 unowned(unsafe) 来声明不安全无主引用。如果你试图在实例被销毁后，访问该实例的不安全无主引用，你的程序会尝试访问该实例之前所在的内存地址，这是一个不安全的操作。
     */
}
d()

//4.2.1 无主引用和隐式解析可选属性
/**
 弱引用场景:
 Person 和 Apartment 的例子展示了两个属性的值都允许为 nil，并会潜在的产生循环强引用。这种场景最适合用弱引用来解决。

 无主引用场景:
 Customer 和 CreditCard 的例子展示了一个属性的值允许为 nil，而另一个属性的值不允许为 nil，这也可能会产生循环强引用。这种场景最适合通过无主引用来解决。
 
 
 存在着第三种场景，在这种场景中，两个属性都必须有值，并且初始化完成后永远不会为 nil。在这种场景中，需要一个类使用无主属性，而另外一个类使用隐式解析可选属性。
 */
print("-------------")
let e = {
    class Country {
        let name: String
        var capitalCity: City! // capitalCity 属性声明为隐式解析可选类型的属性, 默认值是nil
        init(name: String, capitalName: String) {
            
            
            //由于 capitalCity 默认值为 nil，一旦 Country 的实例在构造函数中给 name 属性赋值后，整个初始化过程就完成了
            self.name = name
            
            
            //一旦 name 属性被赋值后，Country 的构造函数就能引用并传递隐式的 self
            //Country 的构造函数在赋值 capitalCity 时，就能将 self 作为参数传递给 City 的构造函数。
            self.capitalCity = City(name: capitalName, country: self)
            
            //意义在于你可以通过一条语句同时创建 Country 和 City 的实例，而不产生循环强引用，并且 capitalCity 的属性能被直接访问，而不需要通过感叹号来展开它的可选值
        }
        deinit {
            print("country destory")
        }
    }
    
    class City {
        let name: String
        unowned let country: Country
        init(name: String, country: Country) {
            self.name = name
            self.country = country
        }
        deinit {
            print("city destory")
        }
    }
    
    var country: Country! = Country(name: "Canada", capitalName: "Ottawa")
    print("\(country!.name)'s capital city is called \(country!.capitalCity.name)")
    country = nil
}
e()
//5. 闭包引起的循环强引用
/**
 当你将一个闭包赋值给类实例的某个属性，并且这个闭包体中又使用了这个类实例时.
 这个闭包体中可能访问了实例的某个属性，例如 self.someProperty，或者闭包中调用了实例的某个方法，例如 self.someMethod()。这两种情况都导致了闭包“捕获”self，从而产生了循环强引用。
 */
print("-------------")
let f = {
    class HTMLElement {
        let name: String
        let text: String?
        
        /**
         asHTML 声明为 lazy 属性，因为只有当元素确实需要被处理为 HTML 输出的字符串时，才需要使用 asHTML。也就是说，在默认的闭包中可以使用 self，因为只有当初始化完成以及 self 确实存在后，才能访问 lazy 属性。
         */
        lazy var asHTML: () -> String = { // 实例的 asHTML 属性持有闭包的强引用
            
            // 闭包捕获了 self，这意味着闭包又反过来持有了 HTMLElement 实例的强引用。这样两个对象就产生了循环强引用。
            // 虽然闭包多次使用了 self，它只捕获 HTMLElement 实例的一个强引用。
            if let text = self.text {
                 return "<\(self.name)>\(text)</\(self.name)>"
            }else {
                return "<\(self.name) />"
            }
        }
        init(name: String, text: String? = nil) {
            self.name = name
            self.text = text
        }
        deinit {
            print("\(name) is being deinitialized")
        }
    }
    
    let heading = HTMLElement(name: "h1")
    let defaultText = "some default text"
    heading.asHTML = {
        return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
    }
    print(heading.asHTML())
    
    
    //  paragraph 变量定义为可选类型的 HTMLElement，因此我们可以赋值 nil 给它来演示循环强引用。
    var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
    print(paragraph!.asHTML())
    
    paragraph = nil //
}
f()

//6. 解决闭包引起的循环强引用
/**
 在定义闭包时同时定义捕获列表作为闭包的一部分，通过这种方式可以解决闭包和类实例之间的循环强引用
 跟解决两个类实例间的循环强引用一样，声明每个捕获的引用为弱引用或无主引用，而不是强引用。
 
 
 注: Swift 有如下要求：只要在闭包内使用 self 的成员，就要用 self.someProperty 或者 self.someMethod()（而不只是 someProperty 或 someMethod()）。这提醒你可能会一不小心就捕获了 self。
 */
//6.1 定义捕获列表
/**
 捕获列表中的每一项都由一对元素组成，一个元素是 weak 或 unowned 关键字，另一个元素是类实例的引用（例如 self）或初始化过的变量（如 delegate = self.delegate!）。这些项在方括号中用逗号分开。
 
 
 1. 如果闭包有参数列表和返回类型，把捕获列表放在它们前面：
 lazy var someClosure: (Int, String) -> String = {
     [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
     // 这里是闭包的函数体
 }
 
 2. 如果闭包没有指明参数列表或者返回类型，它们会通过上下文推断，那么可以把捕获列表和关键字 in 放在闭包最开始的地方：
 
 lazy var someClosure: Void -> String = {
     [unowned self, weak delegate = self.delegate!] in
     // 这里是闭包的函数体
 }
 */

//6.2 弱引用和无主引用
/**
 在闭包和捕获的实例总是互相引用并且总是同时销毁时，将闭包内的捕获定义为无主引用。
 在被捕获的引用可能会变为 nil 时，将闭包内的捕获定义为 弱引用。弱引用总是可选类型，并且当引用的实例被销毁后，弱引用的值会自动置为 nil。这使我们可以在闭包体内检查它们是否存在。
 
 注: 如果被捕获的引用绝对不会变为 nil，应该用无主引用，而不是弱引用。
 */
print("-----------")
let g = {
    class HTMLElement {

        let name: String
        let text: String?

        lazy var asHTML: () -> String = {
            // 这里，捕获列表是 [unowned self]，表示“将 self 捕获为无主引用而不是强引用”
            [unowned self] in
            if let text = self.text {
                return "<\(self.name)>\(text)</\(self.name)>"
            } else {
                return "<\(self.name) />"
            }
        }

        init(name: String, text: String? = nil) {
            self.name = name
            self.text = text
        }

        deinit {
            print("\(name) is being deinitialized")
        }

    }

    var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
    print(paragraph!.asHTML())
    paragraph = nil
}

g()
