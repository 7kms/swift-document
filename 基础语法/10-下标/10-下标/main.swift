//
//  main.swift
//  10-下标
//
//  Created by tangl on 2019/11/14  12:09 AM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation

/**
 subscrips
 下标可以定义在类、结构体和枚举中，是访问集合、列表或序列中元素的快捷方式.可以使用下标的索引，设置和获取值，而不需要再调用对应的存取方法

 如:
 1. 访问一个Array实例中的元素, someArray[index]
 2. 访问一个Dictionary实例中的元素, someDictionary[key]
 
 
 一个类型可以定义多个下标，通过不同索引类型进行重载. 下标不限于一维，你可以定义具有多个入参的下标满足自定义类型的需求。
 */

//1. 下标语法
/**
 1. 读取: 在实例名称后面的方括号([])中传入一个或者多个索引值来对实例进行存取
 2. 定义: 定义下标使用 subscript 关键字, 指定一个或多个输入参数和返回类型
 
 与实例方法不同的是，下标可以设定为读写或只读。这种行为由 getter 和 setter 实现，有点类似计算型属性：
 
 subscript(index: Int) -> Int {
     get {
       // 返回一个适当的 Int 类型的值
     }

     set(newValue) { //如同计算型属性，可以不指定 setter 的参数（newValue）。如果不指定参数，setter 会提供一个名为 newValue 的默认参数
       // 执行适当的赋值操作
     }
 }
 
只读下标: 只提供getter方法,  和只读计算属性一样, 可以省略get关键字
 subscript(index: Int) -> Int {
     // 返回一个适当的 Int 类型的值
 }
 */

struct TimesTable {
    let multiplier: Int
    
    // TimesTable 例子基于一个固定的数学公式，对 threeTimesTable[someIndex] 进行赋值操作并不合适，因此下标定义为只读的。
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}

let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")



//2. 下标用法
/**
 下标通常作为访问集合，列表或序列中元素的快捷方式
 你可以针对自己特定的类或结构体的功能来自由地以最恰当的方式实现下标。
 */
var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4] //字典的类型被推断为 [String: Int]
numberOfLegs["bird"] = 2

print(numberOfLegs["bird"]) //Optional(2)

/**
 注: Swift 的 Dictionary 类型的下标接受并返回可选类型的值。上例中的 numberOfLegs 字典通过下标返回的是一个 Int? 或者说“可选的 int”。Dictionary 类型之所以如此实现下标，是因为不是每个键都有个对应的值，同时这也提供了一种通过键删除对应值的方式，只需将键对应的值赋值为 nil 即可。
 */

//3. 下标选项
/**
 下标可以接受任意数量的入参，并且这些入参可以是任意类型。下标的返回值也可以是任意类型。下标可以使用变量参数和可变参数，但不能使用输入输出参数，也不能给参数设置默认值。
 
 下标的重载 :一个类或结构体可以根据自身需要提供多个下标实现，使用下标时将通过入参的数量和类型进行区分，自动匹配合适的下标
 
 
 */

struct Matrix {
    let rows: Int, columns: Int
    var grid:Array<Double>
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Double{
        get{
            assert(indexIsValid(row: row, column: column), "Index out of range")//断言将在下标越界时触发
            return grid[(row * columns) + column]
        }
        set{
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix(rows: 2, columns: 2)
matrix[0, 1] = 1.5
matrix[1, 0] = 3.2
print(matrix.grid)

let someValue = matrix[2,2] //断言将会触发，因为 [2, 2] 已经超过了 matrix 的范围
