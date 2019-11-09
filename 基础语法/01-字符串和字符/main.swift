// 1. 字符串字面量
// Swift 会推断该常量为String类型
let someString = "Some string literal value"

// 2. 多行字符串字面量
//  由一对三个双引号包裹"""开始, """结束
let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.\
"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""

// 3.字符串字面量的特殊字符

// 转义字符 \0(空字符)、\\(反斜线)、\t(水平制表符)、\n(换行符)、\r(回车符)、\"(双引号)、\'(单引号)。
// Unicode 标量，写成 \u{n}(u 为小写)，其中 n 为任意一到八位十六进制数且可用的 Unicode 位码。

let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
// "Imageination is more important than knowledge" - Enistein
let dollarSign = "\u{24}"             // $，Unicode 标量 U+0024
let blackHeart = "\u{2665}"           // ♥，Unicode 标量 U+2665
let sparklingHeart = "\u{1F496}"      // 💖，Unicode 标量 U+1F496

print(wiseWords)
print(dollarSign)
print(blackHeart)
print(sparklingHeart)

// 4. 初始化空字符串
var emptyString = "" //空字符串字面量
var anotherEmptyString = String() //初始化方法
//两个字符串为空 并且等价
print(emptyString, emptyString == anotherEmptyString)
if(emptyString.isEmpty){
  print("Nothing to see here")
}

// 5. 字符串可变性

// 可以通过将一个特定字符串分配给一个变量来对其进行修改，或者分配给一个常量来保证其不会被修改

var variableString = "Horse"
variableString += " and carriage"

let constantString = "Highlander" //常量字符串不能修改
// constantString+= "fafa" 编译报错

// 6. 字符串是值类型
// 当对string类型进行常量(变量)复制, 参数传递会进行值拷贝(对已有字符串值创建新的副本,并对该副本进行传递和赋值操作)
// 在实际编译时,Swift 编译器会优化字符串的使用,使实际的复制只发生在绝对必要的情况下,这意味着将字符串作为值类型的同时可以获得极高的性能。

// 7. 使用字符
// for-in 循环来遍历字符串
for character in "Haha!💕🚩"{
  print(character)
}
// 创建字符常量(变量) 标明一个 Character 类型并用字符字面量进行赋值
let exclamationMark:Character = "!"
// 字符串可以通过传递一个值类型为 Character 的数组作为自变量来初始化：
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)
print(catString)

// 8. 连接字符串和字符
// 使用 +
let string1 = "hello"
let string2 = " there"
var welcome = string1 + string2
print(welcome)

// 使用+=
var instruction = "look over"
instruction += string2
print(instruction)

// 使用 append(Character: c)
welcome.append(exclamationMark)
print(welcome)

// 9. 字符串插值

// 适用范围: 字符串字面量, 多行字符串字面量
// 可以在其中包含常量、变量、字面量和表达式. 
// 语法: 插入的表达式在以反斜线为前缀的圆括号中 \()

let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
print(message)

let prevstr = "prevstr"
let afterstr = "\(prevstr) + afterstr \(2*3)"
print(afterstr)

// 10.计算字符数量
// 如果想要获得一个字符串中 Character 值的数量，可以使用 count 属性：
let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
print("unusualMenagerie has \(unusualMenagerie.count) characters")

/**
注意在 Swift 中，使用可拓展的字符群集作为 Character 值来连接或改变字符串时，并不一定会更改字符串的字符数量。
*/
var word = "cafe"
print("the number of characters in \(word) is \(word.count)")
word += "\u{301}"    // 拼接一个重音，U+0301
print("the number of characters in \(word) is \(word.count)")

// 11. 访问和修改字符串

/*
访问:字符串索引
每一个 String 值都有一个关联的索引（index）类型，String.Index，它对应着字符串中的每一个 Character 的位置。
startIndex: 获取一个 String 的第一个 Character 的索引
endIndex: 获取最后一个 Character 的后一个位置的索引. endIndex 属性不能作为一个字符串的有效下标

String 的 index(before:)或index(after:)方法可以得到前面或后面的一个索引

index(_:offsetBy:) 方法来获取对应偏移量的索引

使用下标语法来访问 String 特定索引的 Character
*/


let greeting = "Guten Tag!"
print(greeting.startIndex)
print(greeting[greeting.startIndex])
print(greeting[greeting.index(after: greeting.startIndex)])
// print(greeting[greeting.index(before: greeting.startIndex)]) 报错: Fatal error: String index is out of bounds

let index = greeting.index(greeting.startIndex, offsetBy: 7)
print(greeting[index])

// 试图获取越界索引对应的 Character，将引发一个运行时错误
// greeting[greeting.endIndex]
// greeting.index(after: endIndex)

// 使用 indices 属性会创建一个包含全部索引的范围（Range），用来在一个字符串中访问单个字符
for index in greeting.indices {
   print("\(greeting[index]) ", terminator: "")
}

// 使用 startIndex 和 endIndex 属性或者 index(before:) 、index(after:) 和 index(_:offsetBy:) 方法在任意一个确认的并遵循 Collection 协议的类型里面，如上文所示是使用在 String 中，您也可以使用在 Array、Dictionary 和 Set 中


/*
修改:
1. insert(_:at:) 在字符串的指定索引插入一个字符. 原有的字符串改变
2. insert(contentsOf:at:)可以在一个字符串的指定索引插入一个段字符串
3. remove(at:) 方法可以在一个字符串的指定索引删除一个字符
4. removeSubrange(_:) 方法可以在一个字符串的指定索引删除一个子字符串。
*/
welcome.insert("!", at: welcome.endIndex)
print(welcome)
welcome.insert(contentsOf:" there", at: welcome.index(before: welcome.endIndex))
print(welcome)

welcome.remove(at: welcome.index(before: welcome.endIndex))
print(welcome)

let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
welcome.removeSubrange(range)
print(welcome)

// 您以使用 insert(_:at:)、insert(contentsOf:at:)、remove(at:) 和 removeSubrange(_:) 方法在任意一个确认的并遵循 RangeReplaceableCollection 协议的类型里面，如上文所示是使用在 String 中，您也可以使用在 Array、Dictionary 和 Set 中。

// 12. 子字符串

/*
从字符串中获取一个子字符串
使用下标或者 prefix(_:) 之类的方法 —— 就可以得到一个 SubString 的实例，而非另外一个 String
Swift 里的 SubString 绝大部分函数都跟 String 一样，意味着你可以使用同样的方式去操作 SubString 和 String
然而，跟 String 不同的是，你只有在短时间内需要操作字符串时，才会使用 SubString。当你需要长时间保存结果时，就把 SubString 转化为 String 的实例

而 String 和 SubString 的区别在于性能优化上，SubString 可以重用原 String 的内存空间，或者另一个 SubString 的内存空间（String 也有同样的优化，但如果两个 String 共享内存的话，它们就会相等）。这一优化意味着你在修改 String 和 SubString 之前都不需要消耗性能去复制内存
*/

let greeting2 = "Hello, world!"
let index2 = greeting2.firstIndex(of: ",") ?? greeting2.endIndex
let beginning2 = greeting2[..<index2]
print(beginning2)

// 把结果转化为 String 以便长期存储。
let newString = String(beginning2)
print(newString)

/*
上面的例子，greeting2 是一个 String，意味着它在内存里有一片空间保存字符集。而由于 beginning2 是 greeting2 的 SubString，它重用了 greeting2 的内存空间。相反，newString 是一个 String —— 它是使用 SubString 创建的，拥有一片自己的内存空间
*/


// 13. 比较字符串
/*

1. 字符串/字符相等  用等于操作符（==）和不等于操作符（!=）
2. 前缀/后缀相等 用字符串的 hasPrefix(_:)/hasSuffix(_:)

*/
let quotation2 = "We're a lot alike, you and I."
let sameQuotation2 = "We're a lot alike, you and I."
if quotation2 == sameQuotation2 {
    print("These two strings are considered equal")
}

let romeoAndJuliet = [
    "Act 1 Scene 1: Verona, A public place",
    "Act 1 Scene 2: Capulet's mansion",
    "Act 1 Scene 3: A room in Capulet's mansion",
    "Act 1 Scene 4: A street outside Capulet's mansion",
    "Act 1 Scene 5: The Great Hall in Capulet's mansion",
    "Act 2 Scene 1: Outside Capulet's mansion",
    "Act 2 Scene 2: Capulet's orchard",
    "Act 2 Scene 3: Outside Friar Lawrence's cell",
    "Act 2 Scene 4: A street in Verona",
    "Act 2 Scene 5: Capulet's mansion",
    "Act 2 Scene 6: Friar Lawrence's cell"
]

var act1SceneCount = 0
var mansionCount = 0
var cellCount = 0
for scene in romeoAndJuliet {
    if scene.hasPrefix("Act 1 ") {
        act1SceneCount += 1
    }
    if scene.hasSuffix("Capulet's mansion") {
        mansionCount += 1
    } else if scene.hasSuffix("Friar Lawrence's cell") {
        cellCount += 1
    }
}
print("There are \(act1SceneCount) scenes in Act 1")

print("\(mansionCount) mansion scenes; \(cellCount) cell scenes")


// 14. 字符串的表示形式

/*
UTF-8 表示
UTF-16 表示
Unicode 标量表示
*/
let dogString = "Dog‼🐶"

for codeUnit in dogString.utf8 {
    print("\(codeUnit) ", terminator: "")
}
print("")

for codeUnit in dogString.utf16 {
    print("\(codeUnit) ", terminator: "")
}
print("")

for scalar in dogString.unicodeScalars {
    print("\(scalar.value) ", terminator: "")
}
print("")