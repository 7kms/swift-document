//
//  main.swift
//  21-不透明类型 (Opaque Types)
//
//  Created by tangl on 2019/12/4  12:43 AM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation
/**
 一个不透明返回类型的函数, 会隐藏具体的返回值类型.
 返回值被描述成一个协议
 */

//1. 不透明类型解决的问题
protocol Shape {
    func draw() -> String
}
struct Triangle: Shape {
    var size: Int
    func draw() -> String {
        var result = [String]()
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}
let smallTriangle = Triangle(size: 3)
print(smallTriangle.draw())


// 用泛型来实现一个翻转的形状
struct FlippedShape<T: Shape>: Shape{
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

let flippedTriangle = FlippedShape(shape: smallTriangle)
print(flippedTriangle.draw())


// 将两个形状在垂直方向结合起来
struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}

let joinedTriangles = JoinedShape(top: smallTriangle, bottom: flippedTriangle)
print(joinedTriangles.draw())

//2. 返回一个不透明类型
/**
 泛型方法的返回类型取决于调用方
 func max<T>(_ x: T, _ y: T) -> T where T: Comparable { ... }
 */

print("----------------")

struct Square: Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}


/**
 返回值加上some关键字
 返回值遵循Shape协议, 并未指明具体类型
 */
func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}
let trapezoid = makeTrapezoid()
print(trapezoid.draw())
print("----------------")
//将泛型和不透明返回值结合起来使用
func flip<T: Shape>(_ shape: T) -> some Shape {
    return FlippedShape(shape: shape)
}

func join<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
    return JoinedShape(top: top, bottom: bottom)
}


let opaqueJoinedTriangles = join(smallTriangle, flip(smallTriangle) )
print(opaqueJoinedTriangles.draw())
print("----------------")


/**
 如果函数从多处地方返回, 所有返回的地方必须是相同的类型
 */


/**
 Function declares an opaque return type, but the return statements in its body do not have matching underlying types
 */
//func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
//    if shape is Square {
//        return shape
//    }
//    return FlippedShape(shape: shape)
//}

struct FlippedShape2<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        if shape is Square {
            return shape.draw()
        }
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}


/**
 返回不透明类型的函数, 也可以满足只能返回单一的类型:
 
 此函数最终的返回值类型取决于T, 返回值始终是[T]
 */
func `repeat`<T: Shape>(shape: T, count: Int) -> some Collection {
    return Array<T>(repeating: shape, count: count)
}


//3. 不透明类型和协议类型的区别
/**
 主要区别是: 是否保持类型的一致性
 An opaque type refers to one specific type, although the caller of the function isn’t able to see which type;
 
 不透明类型: 涉及一个明确的类型, 调用者不能决定返回值的具体类型
 协议类型: 涉及任何遵循此协议的类型
 */


func protoFlip<T: Shape>(_ shape: T) -> Shape {
    
    // 两处的返回值可能是完全不同的类型
    if shape is Square {
        return shape
    }
    // 两处的返回值可能是完全不同的类型
    return FlippedShape(shape: shape)
}

let protoFlippedTriangle = protoFlip(smallTriangle)
let sameThing = protoFlip(smallTriangle)
//protoFlippedTriangle == sameThing // Binary operator '==' cannot be applied to two 'Shape' operands

//protoFlip(protoFlip(smallTriange)) 无法使用


protocol Container {
    associatedtype Item
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
extension Array: Container { }

// Protocol 'Container' can only be used as a generic constraint because it has Self or associated type requirements
// 拥有关联值的协议不能当做返回类型, 此时缺少必要信息推断出Container的具体关联类型
//func makeProtocolContainer<T>(item: T) -> Container {
//    return [item]
//}


//Cannot convert return expression of type '[T]' to return type 'C'
//func makeProtocolContainer<T, C: Container>(item: T) -> C {
//    return [item]
//}


/**
 潜在的返回值类型是[T]
 */
func makeOpaqueContainer<T>(item: T) -> some Container {
    return [item]
}

// T是Int 返回 [Int], 根据Item可以将Container的关联值被推断为Int
let opaqueContainer = makeOpaqueContainer(item: 12)
//  Container的下标 返回 Item, 被推断为Int
let twelve = opaqueContainer[0]
print(type(of: twelve))
