//
//  main.swift
//  02-集合类型
//
//  Created by tangl on 2019/11/8.
//  Copyright © 2019 km7. All rights reserved.
//

import Foundation

/**
 Swift 提供 Arrays, Sets, Dictionaries 三种基本的集合类型
 Arrays: 有序数据的集
 Sets: 无序无重复数据的集
 Dictionaries: 无序的键值对的集
 
 */

/**
 
 1. 数组(Array)
 数组使用有序列表存储同一类型的多个值,相同的值可以重复出现
 Swift 的 Array 类型被桥接到 Foundation 中的 NSArray 类
 
 语法: Array<Element> 或者 [Element]
 其中 Element 是这个数组中唯一允许存在的数据类型
 */
print("----------------数组(Array)---------------------")
// 1.1 创建一个空数组
var someInts = [Int]() //通过构造函数的类型，someInts 的值类型被推断为 [Int]。
print("someInts is of type [Int] with \(someInts.count) items.")
someInts.append(3)
print(someInts)
someInts = [] //如果代码上下文中已经提供了类型信息,比如此处上文已经提供了[Int]类型, 可以直接使用[]创建一个空数组
print(someInts)
var anotherInts = Array<Int>()
anotherInts.append(4)
print(anotherInts)

// 1.2 创建一个带有默认值的数组
var threeDoubles = Array(repeating: 0.0, count: 3)
print(threeDoubles)
// 1.3 通过两个数组相加创建一个数组
var anotherThreeDoubles = Array(repeating: 2.5, count: 3) //被推断为 [Double]，等价于 [2.5, 2.5, 2.5]
var sixDoubles = threeDoubles + anotherThreeDoubles // sixDoubles 被推断为 [Double]，等价于 [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]
print(sixDoubles)
// 1.4 用数组字面量构造数组
// 用一个或者多个数值构造数组最简单的方法
var shoppingList: [String] = ["Eggs", "Milk"] //shoppingList 已经被构造并且拥有两个初始项。
// shoppingList 数组被声明为变量（var 关键字创建）而不是常量（let 创建）是因为以后可能会有更多的数据项被插入其中

// 由于 Swift 的类型推断机制，当我们用字面量构造只拥有相同类型值数组的时候，我们不必把数组的类型定义清楚。

var shoppingList2 = ["Eggs", "Milk"]
print(shoppingList2)

// 1.5 访问和修改数组

print("The shopping list contains \(shoppingList.count) items.")

if shoppingList.isEmpty {
    print("The shopping list is empty.")
} else {
    print("The shopping list is not empty.")
}

// 添加数据项: 1. append(_:) 2. += 3. insert(_: at:)
shoppingList.append("Flour")
shoppingList += ["Baking Powder"]
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
print(shoppingList, shoppingList.count)
// insert(_:at:) 方法来在某个具体索引值之前添加数据项
shoppingList.insert("Maple Syrup", at: 1) // 新数据项插入列表，并且使用 1 作为索引值
print(shoppingList, shoppingList.count)

// 访问数据项: 下标语法访问
print(shoppingList[0])
// 修改数据项: 下标语法修改
shoppingList[0] = "Six eggs"
print(shoppingList[0])
// 下标来一次改变一系列数据值,即使新数据和原有数据的数量是不一样的
shoppingList[3...5] = ["Bananas", "Apples", "hha", "faf1", "faf2", "faf3"]
print(shoppingList, shoppingList.count)

// 删除数据项: 1. remove(at:) 2.removeLast() 等
shoppingList.remove(at: 0)
print(shoppingList, shoppingList.count)
shoppingList.removeLast();
print(shoppingList, shoppingList.count)

// 1.6 数组的遍历

// for-in
for item in shoppingList {
    print(item)
}
// 如果同时需要每个数据项的值和索引值，可以使用 enumerated() 方法来进行数组遍历
// enumerated() 返回一个由每一个数据项索引值和数据值组成的元组
for (index, value) in shoppingList.enumerated() {
    print("Item \(index + 1): \(value)")
}

/**
 2. 集合Set
 用来存储相同类型并且没有确定顺序的值
 */

print("----------------集合(Set)---------------------")
//2.1 集合类型的哈希值
// 一个类型为了存储在集合中，该类型必须是可哈希化的(该类型必须提供一个方法来计算它的hash值), hash值是Int类型的,相等的对象hash值必须相同. 比如a==b, 则必须 a.hashValue == b.hashValue
// Swift 的所有基本类型（比如 String,Int,Double 和 Bool）默认都是可哈希化的，可以作为集合的值的类型或者字典的键的类型。没有关联值的枚举成员值（在枚举有讲述）默认也是可哈希化的。
// hashable 协议符合 Equatable 协议. 所以遵循该协议的类型也必须提供一个“是否相等”运算符（==）的实现.这个 Equatable 协议要求任何符合 == 实现的实例间都是一种相等的关系

// 对于 a,b,c 三个值来说，== 的实现必须满足下面三种情况：1. a == a(自反性) 2. a == b 意味着 b == a(对称性) 3. a == b && b == c 意味着 a == c(传递性)
//2.2 集合类型语法
// Set 类型被写为 Set<Element>，这里的 Element 表示 Set 中允许存储的类型，和数组不同的是，集合没有等价的简化形式
//2.3 创建和构造一个空的集合
var letters = Set<Character>() // 通过构造器，这里的 letters 变量的类型被推断为 Set<Character>
print("letters is of type Set<Character> with \(letters.count) items.")
letters.insert("a")
print(letters)
letters = [] // 如果上下文提供了类型信息，可以通过一个空的数组字面量创建一个空的 Set：
print(letters)

//2.4 用数组字面量创建集合
// 一个 Set 类型不能从数组字面量中被单独推断出来，因此 Set 类型必须显式声明
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"] // favoriteGenres 被声明为一个变量（拥有 var 标示符）而不是一个常量（拥有 let 标示符）,它里面的元素可以被被增加或者移除
// 由于 Swift 的类型推断，当用数组字面量构造一个 Set,  且数组字面量中的所有元素类型相同，则无须写出 Set 的具体类型
var favoriteGenres2: Set = ["Rock", "Classical", "Hip hop"]
print(favoriteGenres2)

//2.5 访问和修改一个集合
// 只读属性count查询Set集合的数量
print("I have \(favoriteGenres.count) favorite music genres.")
// isEmpty 一个缩写形式去检查 count 属性是否为 0
if favoriteGenres.isEmpty {
    print("As far as music goes, I'm not picky.")
} else {
   print("I have particular music preferences.")
}
// 添加新元素: insert(_:)
favoriteGenres.insert("Jazz")
print(favoriteGenres)
//删除一个元素 remove(_:)
let ele = favoriteGenres.remove("Jazz") //返回String?:如果传入的元素存在于集合中, 返回被删除的元素, 如果不存在则返回nil
print(favoriteGenres)
print(ele as Any)

if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it.")
} else {
    print("I never much cared for that.")
}
//检测是否包含一个值 contains(_:)
if favoriteGenres.contains("Funk") {
    print("I get up on the good foot.")
} else {
    print("It's too funky in here.")
}
//遍历一个集合 for-in
for genre in favoriteGenres {
    print("\(genre)")
}

//  sorted() 方法，它将返回一个有序数组
for genre in favoriteGenres.sorted(){
    print("\(genre)")
}

//2.6 集合操作
// 使用 intersection(_:) 根据两个集合中都包含的值创建的一个新的集合。
// 使用 symmetricDifference(_:) 根据在一个集合中但不在两个集合中的值创建一个新的集合。
// 使用 union(_:) 根据两个集合的值创建一个新的集合。
// 使用 subtracting(_:) 根据不在该集合中的值创建一个新的集合
let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]
print(oddDigits.union(evenDigits).sorted())
print(oddDigits.intersection(evenDigits).sorted())
print(oddDigits.subtracting(singleDigitPrimeNumbers).sorted())
print(oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted())
// 集合成员关系和相等

// 使用“是否相等”运算符（==）来判断两个集合是否包含全部相同的值。
// 使用 isSubset(of:) 否是子集。
// 使用 isSuperset(of:) 否是超集。
// 使用 isStrictSubset(of:) 或者 isStrictSuperset(of:) 判断是否是严格包含关系 真子集。
// 使用 isDisjoint(with:) 方法来判断两个集合是否不含有相同的值（是否没有交集）
let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

print(houseAnimals.isSubset(of: farmAnimals))
print(farmAnimals.isSuperset(of: houseAnimals))
print(farmAnimals.isDisjoint(with: cityAnimals))

/**
 3. 字典 (Dictionary)
 
 字典是一种存储多个相同类型的值的容器
 
 Swift 的 Dictionary 类型被桥接到 Foundation 的 NSDictionary 类。
 
 语法:  Dictionary<key, value> 或者 [Key: value]定义，其中 Key 是字典中键的数据类型, Value 是字典中对应于这些键所存储值的数据类型
 
 一个字典的 Key 类型必须遵循 Hashable 协议，就像 Set 的值类型
 
 */
print("----------------字典(Dictionary)---------------------")
// 3.1 创建一个空字典
var namesOfIntegers = [Int:String]()
namesOfIntegers[16] = "sixteen"
namesOfIntegers[1] = "ace"
print(namesOfIntegers)
// 如果上下文已经提供了类型信息，我们可以使用空字典字面量来创建一个空字典，记作 [:]
namesOfIntegers = [:]
print(namesOfIntegers)

// 3.2 用字典字面量创建字典
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"] // airports 字典被声明为变量（用 var 关键字）而不是常量（let 关键字）, 所以其他信息可以被添加到这个示例字典中。
// 如果它的键和值都有各自一致的类型，那么就不必写出字典的类型
var airports2 = ["YYZ": "Toronto Pearson", "DUB": "Dublin"] // 因为这个语句中所有的键类型相同, 所有的值类型也相同，Swift 可以推断出 Dictionary<String, String> 是 airports2 字典的正确类型。
print(airports2)

// 3.3 访问和修改字典
// count 来获取某个字典的数据项数量
print("The dictionary of airports contains \(airports.count) items.")
// isEmpty 作为一个缩写形式去检查 count 属性是否为 0
if airports.isEmpty {
    print("The airports dictionary is empty.")
} else {
    print("The airports dictionary is not empty.")
}

// 使用下标语法来添加新的数据项
airports["LHR"] = "London" // 新增
print(airports)

airports["LHR"] = "London Heathrow" // 修改
print(airports)

// updateValue(_:forKey:) 返回值是未修改之前的值
print(airports.updateValue("London", forKey: "LHR") as Any)
print(airports)
if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}
print(airports.updateValue("Beijing", forKey: "BJ") as Any) // 如果key以前不存在, 则会创建这个键值对
print(airports)


// 使用下标语法来检查key是否存在

if let airportName = airports["DUB"] {
    print("The name of the airport is \(airportName).")
} else {
    print("That airport is not in the airports dictionary.")
}
// 用下标语法给对应的key赋值成为nil, 可以移除一个键值对
airports["APL"] = "Apple Internation" // "Apple Internation" 不是真的 APL 机场，删除它
airports["APL"] = nil
print(airports)

// removeValue(forKey:) 也可以用来移除键值对。键值对存在的情况下会移除并且返回被移除的值 ,在没有该key的情况下返回 nil：

if let removedValue = airports.removeValue(forKey: "DUB") {
    print("The removed airport's name is \(removedValue).")
} else {
    print("The airports dictionary does not contain a value for DUB.")
}

// 字典遍历: for-in 循环来遍历某个字典中的键值对。每一个字典中的数据项都以 (key, value) 元组形式返回
for (code, name) in airports {
    print("\(code): \(name)")
}

// keys 或者 values 属性，我们也可以遍历字典的键或者值：

for airportCode in airports.keys {
    print("Airport code: \(airportCode)")
}

for name in airports.values {
    print("Airport name: \(name)")
}

print(type(of: airports.keys))
print(airports.values)
print(object_getClass(airports.keys) as Any)
// 如果我们只是需要使用某个字典的键集合或者值集合来作为某个接受 Array 实例的 API 的参数，可以直接使用 keys 或者 values 属性构造一个新数组：
let airportCodes = [String](airports.keys)
print(airportCodes)

let airportNames = [String](airports.values)
debugPrint(type(of: airportNames))
