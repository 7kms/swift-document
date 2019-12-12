//
//  main.swift
//  25-高级运算符
//
//  Created by tangl on 2019/12/11  11:14 PM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

// 1. 位运算符
// 1.1 位取反运算符 (~)
let initialBits: UInt8 = 0b00001111
// 位取反运算符是一个前缀运算符，需要直接放在运算符的前面，并且不能有空格
let invertedBits = ~initialBits
print(initialBits,invertedBits)
// 1.2 位与运算符 (&)
// 可以对两个数的比特位进行合并。它会返回一个新的数，只有当这两个数都是 1 的时候才能返回 1
let firstSixBits: UInt8 = 0b11111100
let lastSixBits: UInt8 = 0b00111111
let middleForBits: UInt8 = firstSixBits & lastSixBits
print(firstSixBits, lastSixBits, middleForBits)
print(String(middleForBits, radix: 2))
// 1.3 位或运算符(|)
// 位或运算符（ | ）可以对两个比特位进行比较，然后返回一个新的数，只要两个操作位任意一个为 1 时，那么对应的位数就为 1
let someBits: UInt8 = 0b10110010
let moreBits: UInt8 = 0b01011110
let combinedbits = someBits | moreBits
print(String(combinedbits, radix: 2))
// 1.4 位异或运算符(^)
// 位异或运算符，或者说“互斥或”（ ^ ）可以对两个数的比特位进行比较。它返回一个新的数，当两个操作数的对应位不相同时，该数的对应位就为 1

let firstBits: UInt8 = 0b00010100
let otherBits: UInt8 = 0b00000101
let outputBits = firstBits ^ otherBits
print(String(outputBits, radix: 2))

// 1.5 位左移和右移运算符
/**
 位左移运算符（ << ）和位右移运算符（ >> ）可以把所有位数的数字向左或向右移动一个确定的位数，但是需要遵守下面定义的规则。

 位左和右移具有给整数乘以或除以二的效果。将一个数左移一位相当于把这个数翻倍，将一个数右移一位相当于把这个数减半。
 */
// 1.5.1 无符号整数的移位操作
/**
 对无符号整数的移位规则如下(逻辑移位):
 1. 已经存在的比特位按指定的位数进行左移和右移。
 2. 任何移动超出整型存储边界的位都会被丢弃。
 3. 用 0 来填充向左或向右移动后产生的空白位。
 */
let shiftBits: UInt8 = 4
print(String(shiftBits, radix: 2))
print(String(shiftBits << 1 , radix: 2))
print(String(shiftBits << 2 , radix: 2))
print(String(shiftBits << 3 , radix: 2))
print(String(shiftBits << 10 , radix: 2))
    
let pink: UInt32 = 0xCC6699
let redComponent = (pink & 0xFF0000) >> 16
print(String(redComponent, radix: 16))

// 1.5.2 有符号整型的位移操作
/**
 有符号整型使用它的第一位（所谓的符号位）来表示这个整数是正数还是负数。符号位为0 表示为正数， 1 表示为负数。
 
 其余的位数（所谓的数值位）存储了实际的值。有符号正整数和无符号数的存储方式是一样的，都是从 0 开始算起。这是值为 4 的 Int8 型整数的二进制位表现形式
   0    0000100
   ↑       ↑
 符号位   数值位
 
 这是值为 -4 的 Int8 型整数的二进制位表现形式
   1    1111100
   ↑       ↑
 符号位   数值位
 
 负数的编码就是二进制补码表示
 使用二进制补码可以使负数的位左移和右移操作得到跟正数同样的效果，即每向左移一位就将自身的数值乘以 2 ，每向右一位就将自身的数值除以 2
 
 当对有符号整型进行右移操作时, 对于移位产生的空白位使用符号位进行填充，而不是 0
 
 */

//2. 溢出运算符
/**
 在默认情况下，当向一个整数赋超过它容量的值时，Swift 会报错而不是生成一个无效的数。这个行为给我们操作过大或着过小的数的时候提供了额外的安全性。
 */
var potentialOverflow = Int16.max
print(potentialOverflow)
//potentialOverflow += 1 // EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
/**
 Swift 提供三个算数溢出运算符来让系统支持整数溢出运算。这些运算符都是以 & 开头的
 溢出加法 （ &+ ）
 溢出减法 （ &- ）
 溢出乘法 （ &* ）
 */
print(potentialOverflow &+ 1)

//2.1 值溢出
var unsignedOverflow = UInt8.max
unsignedOverflow = unsignedOverflow &+ 1
print(unsignedOverflow)
print(UInt8.min &- 1)

// 溢出也会发生在有符号整型数值上。正如按位左移/右移运算符所描述的，在对有符号整型数值进行溢出加法或溢出减法运算时，符号位也需要参与计算
var signedOverflow = Int8.min
signedOverflow = signedOverflow &- 1
print(signedOverflow)
/**
 对于无符号与有符号整型数值来说，当出现上溢时，它们会从数值所能容纳的最大数变成最小的数。同样地，当发生下溢时，它们会从所能容纳的最小数变成最大的数。
 */
//3. 优先级和结合性
/**
 运算符的优先级使得一些运算符优先于其他运算符，高优先级的运算符会先被计算。
 
 对于 C 和 Objective-C 来说，Swift 的运算符优先级和结合性规则是更加简洁和可预测的。但是，这也意味着它们于那些基于 C 的语言不是完全一致的。在对现有的代码进行移植的时候，要注意确保运算符的行为仍然是按照你所想的那样去执行。
 */
//4. 运算符方法
/**
 类和结构体可以为现有的运算符提供自定义的实现，这通常被称为运算符重载
 */

// 算术加法运算符是一个二元运算符，因为它可以对两个目标进行操作，同时它还是中缀运算符，因为它出现在两个目标中间。
struct Vector2D {
    var x = 0.0, y = 0.0
}

extension Vector2D {

    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
}
let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 4.0)
let combinedVector = vector + anotherVector

print(combinedVector)

//4.1 前缀和后缀运算符

/**
 类与结构体也能提供标准一元运算符的实现。单目运算符只有一个操作目标。当运算符出现在目标之前，它就是前缀(比如 -a )，当它出现在操作目标之后时，它就是后缀运算符(比如 b! )
 */
extension Vector2D {
    // 要实现前缀或者后缀运算符，需要在声明运算符函数的时候在 func  关键字之前指定 prefix  或者 postfix  限定符
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
}

let positive = Vector2D(x: 3.0, y: 4.0)
let negative = -positive
let alsoPositive = -negative
print(negative, alsoPositive)

//4.2 组合赋值运算符
/**
 组合赋值运算符将赋值运算符( = )与其它运算符进行结合。比如，将加法与赋值结合成加法赋值运算符（ += ）。在实现的时候，需要把运算符的左参数设置成 inout  类型，因为这个参数的值会在运算符函数内直接被修改。
 */
extension Vector2D {
    static func += ( left: inout Vector2D, right: Vector2D) {
        left = left + right
    }
}
/**
 注: 不能对默认的赋值运算符（ = ）进行重载。只有组合赋值运算符可以被重载。同样地，也无法对三元条件运算符 a ? b : c  进行重载.
 */
var original = Vector2D(x: 1.0, y: 2.0)
let vectorToAdd = Vector2D(x: 3.0, y: 4.0)
original += vectorToAdd
print(original)

//4.3 等价运算符
/**
 自定义类和结构体不接收等价运算符的默认实现，也就是所谓的“等于”运算符（ == ）和“不等于”运算符（ != ）
 
 要使用等价运算符来检查你自己类型的等价，需要和其他中缀运算符一样提供一个“等于”运算符，并且遵循标准库的 Equatable 协议
 */
extension Vector2D: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == lhs.y)
    }
    
    // 标准库提供了一个关于“不等于”运算符（ != ）的默认实现，它仅仅返回“等于”运算符的相反值。
}
let twoThree = Vector2D(x: 2.0, y: 3.0)
let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
if twoThree == anotherTwoThree {
    print("These two vectors are equivalent.")
}

/**
 Swift 为以下自定义类型提等价运算符供合成实现：
 
 只拥有遵循 Equatable 协议存储属性的结构体；
 只拥有遵循 Equatable 协议关联类型的枚举；
 没有关联类型的枚举。
 
 */
struct Vector3D: Equatable {
    var x = 0.0, y = 0.0, z = 0.0
}
let twoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
let anotherTwoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
if twoThreeFour == anotherTwoThreeFour {
    print("These two vectors are also equivalent.")
}

//4.4 自定义运算符
/**
 除了实现标准运算符，在 Swift 当中还可以声明和实现自定义运算符（custom operators）。可以用来自定义运算符的字符列表请参考运算符(https://docs.swift.org/swift-book/ReferenceManual/LexicalStructure.html#ID418)
 
 新的运算符要在全局作用域内，使用 operator  关键字进行声明，同时还要指定 prefix 、 infix  或者 postfix  限定符:
 
 prefix operator +++
 上面的代码定义了一个新的名为 +++  的前缀运算符. 这个运算符在 Swift 中并没有意义.
 */
prefix operator +++

extension Vector2D {
    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
        vector += vector
        return vector
    }
}
var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
let afterDoubling = +++toBeDoubled
print(afterDoubling)

//4.4.1 自定义中缀运算符的优先级和结合性
/**
 定义一个新的中缀运算符 语法:
 infix operator <#operator name#>: <#precedence group#>
 如果未指明<#precedence group#>, swift会默认DefaultPrecedence, 优先级比TernaryPrecedence高
 
 定义优先级组(Precedence Group):
 https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID550
 precedencegroup <#precedence group name#> {
     higherThan: <#lower group names#>
     lowerThan: <#higher group names#>
     associativity: <#associativity#>
     assignment: <#assignment#>
 }
 */
// 和+
infix operator +-: AdditionPrecedence
extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
}

let firstVector = Vector2D(x: 1.0, y: 2.0)
let secondVector = Vector2D(x: 3.0, y: 4.0)
let plusMinusVector = firstVector +- secondVector

print(plusMinusVector)
