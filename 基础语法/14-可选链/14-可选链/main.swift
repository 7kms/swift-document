//
//  main.swift
//  14-可选链 Optional Chaining
//
//  Created by tangl on 2019/11/20  10:27 AM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

/**
 可选链式调用是一种可以在当前值可能为 nil 的可选值上请求和调用属性、方法及下标的方法。
 如果可选值有值，那么调用就会成功；如果可选值是 nil，那么调用将返回 nil。
 多个调用可以连接在一起形成一个调用链，如果其中任何一个节点为 nil，整个调用链都会失败，即返回 nil。
 
 注: Swift 的可选链式调用和 Objective-C 中向 nil 发送消息有些相像，但是 Swift 的可选链式调用可以应用于任意类型，并且能检查调用是否成功。
 */

//1. 使用可选链式调用代替强制展开
/**
 可选链式调用: 在想调用的属性、方法，或下标的可选值后面放一个问号（?），可以定义一个可选链
 强制展开: 在可选值后面放一个叹号（!）来强制展开它的值
 它们的主要区别在于当可选值为空时可选链式调用只会调用失败，然而强制展开将会触发运行时错误。
 
 对于可选链式调用，不论这个调用的属性、方法及下标返回的值是不是可选值，它的返回结果都是一个可选值。
 你可以利用这个返回值来判断你的可选链式调用是否调用成功，如果调用有返回值则说明调用成功，返回 nil 则说明调用失败。
 */
class Person {
    var residence: Residence?
}

class Residence {
    var numberOfRooms = 1
}

let john = Person()
//let roomCount = john.resisdence!.numberOfRooms //如果使用叹号（!）强制展开获得这个 john 的 residence 属性中的 numberOfRooms 值，会触发运行时错误，因为这时 residence 没有可以展开的值
// Fatal error: Unexpectedly found nil while unwrapping an Optional value:

if let roomCount = john.residence?.numberOfRooms { //在 residence 后面添加问号之后，Swift 就会在 residence 不为 nil 的情况下访问 numberOfRooms。
    print("john's resisdence has \(roomCount) room(s).")
}else{
     print("Unable to retrieve the number of rooms.")
}

john.residence = Residence()
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}
//2. 为可选链式调用定义模型类
/**
 通过使用可选链式调用可以调用多层属性、方法和下标。这样可以在复杂的模型中向下访问各种子属性，并且判断能否访问子属性的属性、方法或下标。
 */
class Room {
    let name: String
    init(name: String) { self.name = name }
}
class Person2{
    var residence: Residence2?
}
class Residence2{
    var rooms = [Room]()
    var numberOfRooms :Int {
        return rooms.count
    }
    subscript(i: Int) -> Room{
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func PrintNumberOfRooms() {// 没有返回值的方法具有隐式的返回类型 Void. 这意味着没有返回值的方法也会返回 ()，或者说空的元组。
         print("The number of rooms is \(numberOfRooms)")
    }
    var address:Address?
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street:String?
    func buildingIdentifier() -> String? {
        if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else if buildingName != nil {
            return buildingName
        } else {
            return nil
        }
    }
}

//3. 通过可选链式调用访问属性
let tom = Person2()

if let roomCount = tom.residence?.numberOfRooms{ //因为 tom.residence 为 nil
    print("tom's residence has \(roomCount) room(s).")
}else{
    print("Unable to retrieve the number of rooms.")
}

let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"
tom.residence?.address = someAddress // 通过 tom.residence 来设定 address 属性也会失败，因为 tom.residence 当前为 nil
print(tom.residence?.address?.buildingIdentifier() as Any)


func createAddress() -> Address {
    print("Function was called.")
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"
    return someAddress
}
// 赋值过程是可选链式调用的一部分，这意味着可选链式调用失败时，等号右侧的代码不会被执行。
tom.residence?.address = createAddress() //createAddress()函数没有执行

//4. 通过可选链式调用调用方法

/**
 通过可选链式调用得到的返回值都是可选的, PrintNumberOfRooms()方法的返回类型会是 Void?，而不是 Void
 */
if tom.residence?.PrintNumberOfRooms() != nil { //即使方法本身没有定义返回值, 也可以使用 if 语句来判断能否成功调用 printNumberOfRooms() 方法
    print("It was possible to print the number of rooms.")
}else{
    print("It was not possible to print the number of rooms.")
}

// 通过可选链式调用给属性赋值会返回 Void?，通过判断返回值是否为 nil 就可以知道赋值是否成功：
if (tom.residence?.address = someAddress) != nil {
     print("It was possible to set the address.")
}else{
    print("It was not possible to set the address.")
}

//5. 通过可选链式调用访问下标
/**
 通过可选链式调用，我们可以在一个可选值上访问下标，并且判断下标调用是否成功。
 注: 通过可选链式调用访问可选值的下标时，应该将问号放在下标方括号的前面而不是后面。可选链式调用的问号一般直接跟在可选表达式的后面。
 */
if let firstRoomName = tom.residence?[0].name {
    print("The first room name is \(firstRoomName).")
}else{
    print("Unable to retrieve the first room name.")
}
// 可以通过下标，用可选链式调用来赋值：
tom.residence?[0] = Room(name: "Bathroom") //这次赋值同样会失败，因为 residence 目前是 nil。

let tomsHouse = Residence2()
tomsHouse.rooms.append(Room(name: "Living Room"))
tomsHouse.rooms.append(Room(name: "Kitchen"))
tom.residence = tomsHouse
if let firstRoomName = tom.residence?[0].name {
    print("The first room name is \(firstRoomName).")
}else{
    print("Unable to retrieve the first room name.")
}
// 5.1 访问可选类型的下标
/**
 如果下标返回可选类型值，比如 Swift 中 Dictionary 类型的键的下标，可以在下标的结尾括号后面放一个问号来在其可选返回值上进行可选链式调用：
 */

var testScores = ["Dave":[86,82,84], "Bev": [79,94,81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72 //testScores 字典中没有 "Brian" 这个键，所以调用会失败。
print(testScores)
//6. 连接多层可选链式调用
/**
 可以通过连接多个可选链式调用在更深的模型层级中访问属性、方法以及下标。然而，多层可选链式调用不会增加返回值的可选层级。
 
 也就是说:
 如果你访问的值不是可选的，可选链式调用将会返回可选值。
 如果你访问的值就是可选的，可选链式调用不会让可选返回值变得“更可选”
 因此:
 通过可选链式调用访问一个 Int 值，将会返回 Int?，无论使用了多少层可选链式调用。
 类似的，通过可选链式调用访问 Int? 值，依旧会返回 Int? 值，并不会返回 Int??。
 */

if let tomStreet = tom.residence?.address?.street{
     print("Tom's street name is \(tomStreet).")
}else{
    print("Unable to retrieve the address.")
}

let johnsAddress = Address()
johnsAddress.buildingName = "The Larches"
johnsAddress.street = "Laurel Street"
tom.residence?.address = johnsAddress
if let johnsStreet = tom.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the address.")
}
//7. 在方法的可选返回值上进行可选链式调用
/**
 可以在一个可选值上通过可选链式调用来调用方法，并且可以根据需要继续在方法的可选返回值上进行可选链式调用
 */

if let buildingIdentifier = tom.residence?.address?.buildingIdentifier() {
    print("tom's building identifier is \(buildingIdentifier).")
}

// 如果要在该方法的返回值上进行可选链式调用，在方法的圆括号后面加上问号即可：
if let beginWithThe = tom.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
    if beginWithThe {
        print("Tom's building identifier begins with \"The\".")
    }else{
        print("Tom's building identifier does not begin with \"The\".")
    }
}

// 注: 在上面的例子中，在方法的圆括号后面加上问号是因为你要在 buildingIdentifier() 方法的可选返回值上进行可选链式调用，而不是 buildingIdentifier() 方法本身。
