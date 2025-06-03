---
layout: post
title: 设计模式之——原型 Prototype
categories: DesignPatterns
description: 设计模式之——原型 Prototype
keywords: Java，设计模式
---

设计模式之——原型 Prototype

# 序言
原型模式是 Java 中自带的模式。

用于从一个固定的对象中**克隆**出多个相同的对象。

# 概念

> 以下内容引用自 [菜鸟教程](https://www.runoob.com/design-pattern/template-pattern.html)
> 
> ### 原型模式
> 原型模式（Prototype Pattern）是用于创建重复的对象，同时又能保证性能。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。
> 
> 这种模式是实现了一个原型接口，该接口用于创建当前对象的克隆。当直接创建对象的代价比较大时，则采用这种模式。例如，一个对象需要在一个高代价的数据库操作之后被创建。我们可以缓存该对象，在下一个请求时返回它的克隆，在需要的时候更新数据库，以此来减少数据库调用。
> 
> ### 介绍
> 意图
> - 用原型实例指定创建对象的种类，并且通过拷贝这些原型创建新的对象。
> 
> 主要解决
> - 在运行期建立和删除原型。
> 
> 何时使用
> - 当一个系统应该独立于它的产品创建，构成和表示时。 
> - 当要实例化的类是在运行时刻指定时，例如，通过动态装载。
> - 为了避免创建一个与产品类层次平行的工厂类层次时。
> - 当一个类的实例只能有几个不同状态组合中的一种时。建立相应数目的原型并克隆它们可能比每次用合适的状态手工实例化该类更方便一些。
> 
> 如何解决
> - 利用已有的一个原型对象，快速地生成和原型对象一样的实例。
> 
> 关键代码
> - 实现克隆操作，在 JAVA 继承 Cloneable，重写 clone()，在 .NET 中可以使用 Object 类的 MemberwiseClone() 方法来实现对象的浅拷贝或通过序列化的方式来实现深拷贝。 
> - 原型模式同样用于隔离类对象的使用者和具体类型（易变类）之间的耦合关系，它同样要求这些"易变类"拥有稳定的接口。
> 
> 应用实例
> - 细胞分裂。
> - JAVA 中的 Object clone() 方法。
> 
> 优点
> - 性能提高。 
> - 逃避构造函数的约束。
> 
> 缺点
> - 配备克隆方法需要对类的功能进行通盘考虑，这对于全新的类不是很难，但对于已有的类不一定很容易，特别当一个类引用不支持串行化的间接对象，或者引用含有循环结构的时候。 
> - 必须实现 Cloneable 接口。
> 
> 使用场景
> - 资源优化场景。
> - 类初始化需要消化非常多的资源，这个资源包括数据、硬件资源等。 
> - 性能和安全要求的场景。 
> - 通过 new 产生一个对象需要非常繁琐的数据准备或访问权限，则可以使用原型模式。 
> - 一个对象多个修改者的场景。 
> - 一个对象需要提供给其他对象访问，而且各个调用者可能都需要修改其值时，可以考虑使用原型模式拷贝多个对象供调用者使用。 
> - 在实际项目中，原型模式很少单独出现，一般是和工厂方法模式一起出现，通过 clone 的方法创建一个对象，然后由工厂方法提供给调用者。
> - 原型模式已经与 Java 融为浑然一体，大家可以随手拿来使用。
> 
> 注意事项
> - 与通过对一个类进行实例化来构造新对象不同的是，原型模式是通过拷贝一个现有对象生成新对象的。浅拷贝实现 Cloneable，重写，深拷贝是通过实现 Serializable 读取二进制流。

# 案例
## 浅克隆
### 实现
实现克隆有三步：
1. 继承 Cloneable 接口
2. 重写 clone() 方法
3. 调用 clone() 方法

事实上，不继承 `Cloneable` 接口也可以重写 `clone()` 方法。<br>
因为 `Cloneable` 是一个空接口（里面什么都没有）。<br>
而 `clone()` 方法是 `Object` 类（所有类共同的父类）的方法。

但是，不继承 `Cloneable` 接口**编译可以通过**，**调用**  `clone()` 方法时会报 `java.lang.CloneNotSupportedException` **异常**！
```java
@AllArgsConstructor
@ToString
class Person implements Cloneable{
    int age;
    int score;
    Location loc;

    @Override
    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}

@AllArgsConstructor
@ToString
class Location {
    String street;
    int roomNo;
}
```
需要克隆对象时直接调用 `clone()` 方法。
```java
public static void main(String[] args) throws Exception {
        Person p1 = new Person(18, 100, new Location("bj", 22));
        System.out.println(p1);

        Person p2 = (Person) p1.clone();
        System.out.println(p2);

        System.out.println(p1 == p2);
    }
```
结果
```java
Person(age=18, score=100, loc=Location(street=bj, roomNo=22))
Person(age=18, score=100, loc=Location(street=bj, roomNo=22))
false
```
可以看到 p1 和 p2 内容一样，且是两个不同的对象。

### 什么是浅克隆？

```java
public static void main(String[] args) throws Exception {
        Person p1 = new Person(18, 100, new Location("bj", 22));
        Person p2 = (Person) p1.clone();
		
        System.out.println(p1.loc == p2.loc);
    }
```
结果
```java
true
```
这意味着 `p1.loc` 和 `p2.loc` 是**同一个**对象！

这就是浅克隆，新对象和旧对象的值**完全一致**。

![](\images\posts\designpatterns\prototype\loc.png)

```java
    protected native Object clone() throws CloneNotSupportedException;
```
`clone()` 是个 `native` 方法，本地找不到其实现，可以简单地将 `Person` 类的 `clone()` 视为这样的：
```java
@Override
public Object clone() throws CloneNotSupportedException {
	Person clone = new Person();
	clone.age = this.age;
	clone.score = this.score;
	clone.loc = this.loc;
	return clone;
}
```

于是会出现以下情形
```java
public static void main(String[] args) throws Exception {
        Person p1 = new Person(18, 100, new Location("bj", 22));
        Person p2 = (Person) p1.clone();

        p1.age = 8;
        System.out.println(p2.age);

        p1.loc.street = "sh";
        System.out.println(p2.loc.street);
    }
```
结果
```java
18
sh
```
修改 `p1.age` ，`p2.age` 没有变。<br>
但是修改 `p1.loc` ，`p2.loc` 也变了。

## 深克隆
深克隆可以解决浅克隆中引用类型指向同一个对象的问题。

办法很简单，**使所有的引用类型都继承 Cloneable 接口并重写 clone() 方法**。
```java
@AllArgsConstructor
@ToString
class Person implements Cloneable {
    int age;
    int score;
    Location loc;

    @Override
    protected Object clone() throws CloneNotSupportedException {
        Person person = (Person) super.clone();
        person.loc = (Location) this.loc.clone();
        return person;
    }
}

@AllArgsConstructor
@ToString
class Location implements Cloneable {
    String street;
    int roomNo;

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}
```
测试
```java
public static void main(String[] args) throws Exception {
        Person p1 = new Person(18, 100, new Location("bj", 22));
        Person p2 = (Person) p1.clone();

        System.out.println(p1.loc == p2.loc);
        p1.loc.street = "sh";
        System.out.println(p2.loc.street);
    }
```
结果
```java
false
bj
```
`p1.loc` 和 `p2.loc` 不再指向同一个对象。

修改 `p1.loc` ， `p2.loc` 不会受影响。

## 反序列化
还可以通过序列化和反序列化的方式实现深克隆。

将对象序列化为字节流，然后再反序列化为对象。<br>
反序列化创建的是新对象，并没有复制现有对象。

`CloneUtil` 工具类，通过序列化和反序列化克隆对象
```java
/**
 * 通过序列化和反序列化克隆对象
 */
public class CloneUtil {

    public static <T extends Serializable> T clone(T object) {
        T result = null;

        try (ByteArrayOutputStream byteOutput = new ByteArrayOutputStream();
             ObjectOutputStream objectOutput = new ObjectOutputStream(byteOutput)) {
            objectOutput.writeObject(object);
            try (ByteArrayInputStream byteInput = new ByteArrayInputStream(byteOutput.toByteArray());
                 ObjectInputStream objectInput = new ObjectInputStream(byteInput);
            ) {
                result = (T) objectInput.readObject();
            }
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return result;
    }

}
```

对象不需要实现 `Cloneable` 接口，而是需要实现 `Serializable` 接口
```java
@AllArgsConstructor
@ToString
class Person implements Serializable {
    private static final long serialVersionUID = -280939426127136800L;
    int age;
    int score;
    Location loc;
}

@AllArgsConstructor
@ToString
class Location implements Serializable {
    private static final long serialVersionUID = 5934373144430208588L;
    String street;
    int roomNo;
}
```

测试
```java
    public static void main(String[] args) throws Exception {
        Person p1 = new Person(18, 100, new Location("bj", 22));
        Person p2 = CloneUtil.clone(p1);
        System.out.println(p2);

        System.out.println(p1.loc == p2.loc);
        p1.loc.street = "sh";
        System.out.println(p2.loc.street);
    }
```

结果
```java
Person(age=18, score=100, loc=Location(street=bj, roomNo=22))
false
bj
```

## 性能测试
### 深克隆与反序列化
克隆十万个对象
- 深克隆：
	- 11 ms
	- 10 ms
	- 11 ms
- 反序列化：
	- 1309 ms
	- 1223 ms
	- 1233 ms
- 深克隆比反序列化快了**百倍**


### 直接创建对象与深克隆
一千万个对象

|Jdk 版本|直接创建时间（ms）|深克隆时间（ms）|
|:--:|:--:|:--:|
| Jdk 8 | 78, 61, 61| 163, 153, 156|
| Jdk 11 | 122,97,100 | 39, 39, 39 |
| Jdk 13 | 125, 106, 98  | 40, 48, 44 |
| Jdk 15 | 11, 10, 9 | 93, 101, 97 |
| Jdk 17 | 10, 12, 12 | 97, 111, 101 |

可以看到，时间对比的结果很神奇。
- 经典的 Jdk 8 是直接创建比较快
- Jdk 8 之后一些中版本，是深克隆快
- 新版本是直接创建比较快

99% 的对象都是通过 `new` 关键字生成的，所以 Jdk 肯定是会着重针对此做优化的。<br>
这样的结果不知道是 BUG 或是其他原因，将来有时间了研究一下。

网上的通用结论是：**直接创建对象比较快，除非构造函数里面有复杂的运算**。

## 哪些变量不需要深克隆？
常量不需要深克隆
- 八种基本类型没有深浅克隆的说法：
	- byte
	- short
	- int
	- long
	- float
	- double
	- char
	- boolean
- 八种包装类型不需要深克隆：
	- Byte
	- Short
	- Integer
	- Long
	- Float
	- Double
	- Character
	- Boolean
- String 不需要深克隆

修改以上 17 种类型的变量的值时，并不是修改常量，而是将其指向了新的常量。

# 源码链接
该文章源码链接 [Github](https://github.com/kekaiyuan/designpatterns/tree/main/src/main/java/com/kky/dp/prototype)