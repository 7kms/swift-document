//
//  main.swift
//  17-嵌套类型 Nested Types
//
//  Created by tangl on 2019/11/22  1:01 AM
//  Copyright © 2019 km7. All rights reserved.
//
//  ---------------------------------------------------------
//  😃  https://github.com/7kms
//  热爱生活, 勤于思考, 努力学习
//  ---------------------------------------------------------
//

import Foundation
/**
 Swift 允许你定义嵌套类型，可以在支持的类型中定义嵌套的枚举、类和结构体
 
 要在一个类型中嵌套另一个类型，将嵌套类型的定义写在其外部类型的 {} 内，而且可以根据需要定义多级嵌套。
 */

//1. 嵌套类型实践
/**
 因为 BlackjackCard 是一个没有自定义构造器的结构体.
 所以获得结构体默认的成员构造器
 */
struct BlackjackCard {
    
    // 嵌套的 Suit 枚举
    enum Suit: Character {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }
    
    
    // 嵌套的 Rank 枚举
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
        
        struct Values {
            let first: Int, second: Int?
        }
        var values: Values {
            switch self {
            case .ace:
                return Values(first: 1, second: 11)
            case .jack, .queen, .king:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }
    
    
    //BlackjackCard 的属性和方法
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}


//尽管 Rank 和 Suit 嵌套在 BlackjackCard 中，但它们的类型仍可从上下文中推断出来，所以在初始化实例时能够单独通过成员名称（.ace 和 .spades）引用枚举实例
let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
print("theAceOfSpades: \(theAceOfSpades.description)")

//2. 引用嵌套类型
/**
 在外部引用嵌套类型时，在嵌套类型的类型名前加上其外部类型的类型名作为前缀：
 */
let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
print(heartsSymbol)
/**
 对于嵌套类型，这样可以使 Suit、Rank 和 Values 的名字尽可能的短，因为它们的名字可以由定义它们的上下文来限定。
 */
