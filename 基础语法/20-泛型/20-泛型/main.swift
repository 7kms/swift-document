//
//  main.swift
//  20-泛型
//
//  Created by tangl on 2019/12/2  11:32 PM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation
//1. 泛型所解决的问题
/**
泛型代码让你能够根据自定义的需求，编写出适用于任意类型、灵活可重用的函数及类型。
它能让你避免代码的重复，用一种清晰和抽象的方式来表达代码的意图。
*/

//2. 泛型函数

// 泛型函数名（swapTwoValues(_:_:)）后面跟着占位类型名（T），并用尖括号括起来（<T>）
// 这个尖括号告诉 Swift 那个 T 是 swapTwoValues(_:_:) 函数定义内的一个占位类型名，因此 Swift 不会去查找名为 T 的实际类型
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)
print(someInt, anotherInt)
var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)
/**
 注:
 上面定义的 swapTwoValues(_:_:) 函数是受 swap(_:_:) 函数启发而实现的。后者存在于 Swift 标准库，你可以在你的应用程序中使用它。如果你在代码中需要类似 swapTwoValues(_:_:) 函数的功能，你可以使用已存在的 swap(_:_:) 函数
 */

//3. 类型参数
/**
 类型参数指定并命名一个占位类型，并且紧随在函数名后面，使用一对尖括号括起来（例如 <T>）
 */
//4. 命名类型参数
/**
 1) 当泛型参数有实际意义时, 可以写一个成描述性名字. 例如 Dictionary<Key, Value> 中的 Key 和 Value，以及 Array<Element> 中的 Element，这可以告诉阅读代码的人这些类型参数和泛型函数之间的关系。
 2) 没有有意义的关系时，通常使用单个字母来命名，例如 T、U、V，正如上面演示的 swapTwoValues(_:_:) 函数中的 T 一样
 */
//5. 泛型类型
/**
 除了泛型函数，Swift 还允许你定义泛型类型。这些自定义类、结构体和枚举可以适用于任何类型，类似于 Array 和 Dictionary。
 */
struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element{
        return items.removeLast()
    }
}
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
print(stackOfStrings.items)
let fromTheTop = stackOfStrings.pop()
print(fromTheTop)
//6. 扩展一个泛型类型
/**
当扩展一个泛型类型时, 原始类型定义中声明的类型参数列表在扩展中可以直接使用，并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用。
 */
extension Stack {
    // Stack 类型已有的类型参数名称 Element，被用在扩展中来表示计算型属性 topItem 的可选类型。
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \(topItem).")
}

//7. 类型约束
/**
 类型约束可以指定一个类型参数必须继承自指定类，或者符合一个特定的协议或协议组合。
 */
//7.1 类型约束语法
/**
 
 第一个类型参数 T，有一个要求 T 必须是 SomeClass 子类的类型约束；
 第二个类型参数 U，有一个要求 U 必须符合 SomeProtocol 协议的类型约束。
 func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
     // 这里是泛型函数的函数体部分
 }
 */
//7.2 类型约束实践

// findIndex(of:in:) 唯一的类型参数写做 T: Equatable，也就意味着“任何符合 Equatable 协议的类型 T”。
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
print(doubleIndex as Any)
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
print(stringIndex as Any)
//8. 关联类型
/**
 定义一个协议时，有的时候声明一个或多个关联类型作为协议定义的一部分将会非常有用。
 关联类型为协议中的某个类型提供了一个占位名（或者说别名），其代表的实际类型在协议被采纳时才会被指定。
 语法: 通过 associatedtype 关键字来指定关联类型。
 */
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript (i: Int) -> Item { get }
}

struct Stack2<Element>: Container{
//    typealias Item = Element //此处可以删除typealias, 可以通过append(_)进行类型推断
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
      return items.removeLast()
    }
    mutating func append(_ item: Element) {
        items.append(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}
//8.1 通过扩展一个存在的类型来指定关联类型
/**
 利用扩展让一个已存在的类型符合一个协议(包括使用了关联类型的协议)。
 需要添加一个遵循该协议的空扩展
 */

/**
 Swift 的 Array 类型已经提供 append(_:) 方法，一个 count 属性，以及一个接受 Int 类型索引值的下标用以检索其元素。这三个功能都符合 Container 协议的要求，也就意味着你只需简单地声明 Array 采纳该协议就可以扩展 Array，使其遵从 Container 协议
 */
extension Array: Container {}
//8.2 给关联类型添加约束
/**
 可以给协议里的关联类型添加类型注释，让遵守协议的类型必须遵循这个约束条件
 */
protocol Container2 {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
//为了遵守了 Container2 协议，Item 类型也必须遵守 Equatable 协议。

//8.2 在关联类型约束里使用协议
/**
 协议可以作为它自身的要求出现。例如，有一个协议细化了 Container 协议，添加了一个 suffix(_:) 方法。
 suffix(_:) 方法返回容器中从后往前给定数量的元素，把它们存储在一个 Suffix 类型的实例里。
 */
protocol SuffixableContainer: Container2 {
    
    // Suffix 是一个关联类型, 它必须遵循 SuffixableContainer 协议（就是当前定义的协议），以及它的 Item 类型必须是和容器里的 Item 类型相同
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
    
}
struct Stack3<Element:Equatable>: Container2{
//    typealias Item = Element //此处可以删除typealias, 可以通过append(_)进行类型推断
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
      return items.removeLast()
    }
    mutating func append(_ item: Element) {
        items.append(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}
extension Stack3: SuffixableContainer{
    func suffix(_ size: Int) -> Stack3 {
        var result = Stack3()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
}
var stackOfInts = Stack3<Int>()
stackOfInts.append(10)
stackOfInts.append(20)
stackOfInts.append(30)
let suffix = stackOfInts.suffix(2)
print(suffix)

//9. 泛型 Where 语句
/**
 你可以在参数列表中通过 where 子句为关联类型定义约束
 */

func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.Item == C2.Item, C1.Item: Equatable {
    
    // 检查两个容器含有相同数量的元素
    if someContainer.count != anotherContainer.count {
        return false
    }
    
    // 检查每一对元素是否相等
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    
    // 所有元素都匹配，返回 true
    return true
}

var stackOfStrings2 = Stack2<String>()
stackOfStrings2.push("uno")
stackOfStrings2.push("dos")
stackOfStrings2.push("tres")
var arrayOfStrings = ["uno", "dos", "tres"]

// 即使栈和数组是不同的类型，但它们都遵从 Container 协议，而且它们都包含相同类型的值
if allItemsMatch(stackOfStrings2, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}
//10. 具有泛型 where 子句的扩展
/**
 10.1可以使用泛型 where 子句作为扩展的一部分
 */
// 使用泛型 where 子句可以为扩展添加新的条件，因此只有当栈中的元素符合 Equatable 协议时，扩展才会添加 isTop(_:) 方法
extension Stack where Element: Equatable{
    func isTop(_ element: Element) -> Bool {
        // 首先检查这个栈是不是空
        guard let topItem = items.last else {
            return false
        }
        return topItem == element
    }
}
if stackOfStrings.isTop("tres") {
     print("Top element is tres.")
} else {
    print("Top element is something else.")
}

struct NotEquatable {}

var notEquatableStack = Stack<NotEquatable>()
let notEquatableValue = NotEquatable()
notEquatableStack.push(notEquatableValue)

//notEquatableStack.isTop(notEquatableValue) //编译报错:Argument type 'NotEquatable' does not conform to expected type 'Equatable'
/**
 10.2 可以使用泛型 where 子句去扩展一个协议
 */

// 泛型 where 子句要求 Item 符合协议
extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}

if [9, 9, 9].startsWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")
}

// 泛型 where 子句去要求 Item 为特定类型(如有多个条件, 需用逗号分隔)
extension Container where Item == Double {
    
    func average() -> Double {
       var sum = 0.0
       for index in 0..<count {
           sum += self[index]
       }
       return sum / Double(count)
    }
}
print([1260.0, 1200.0, 98.6, 37.0].average())

//11. 具有泛型 Where 子句的关联类型
/**
 可以在关联类型后面加上具有泛型 where 的字句
 */

// 建立一个包含迭代器（Iterator）的容器，就像是标准库中使用的 Sequence 协议那样:
protocol Container3 {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int {get}
    subscript (i: Int) -> Item {get}
    
    // 无论迭代器是什么类型，迭代器中的元素类型，必须和容器项目的类型保持一致
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    
    //提供了容器的迭代器的访问接口
    func makeIterator() -> Iterator
}

// 一个协议继承了另一个协议，通过在协议声明的时候，包含泛型 where 子句，来添加了一个约束到被继承协议的关联类型
protocol ComparableContainer: Container where Item: Comparable {
    
}

//12. 泛型下标
/**
 下标能够是泛型的，他们能够包含泛型 where 子句。
 语法:
 把占位符类型的名称写在 subscript 后面的尖括号
 在下标代码体开始的标志的花括号之前写下泛型 where 子句
 */

extension Container {
    
    // 1.在尖括号中的泛型参数 Indices，必须是符合标准库中的 Sequence 协议的类型。
    // 2.下标使用的单一的参数，indices，必须是 Indices 的实例。
    // 3. 泛型 where 子句要求 Sequence（Indices）的迭代器，其所有的元素都是 Int 类型。这样就能确保在序列（Sequence）中的索引和容器（Container）里面的索引类型是一致的。
    subscript<Indices: Sequence> (indices: Indices) -> [Item] where Indices.Iterator.Element == Int {
        // 这些约束意味着，传入到 indices 下标，是一个整型的序列
        var result = [Item]()
        for index in indices {
            result.append(self[index])
        }
        return result
    }
}
