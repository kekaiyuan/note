---
layout: post
title: 设计模式之——模板方法 Template Method
categories: DesignPatterns
description: 设计模式之——模板方法 Template Method
keywords: Java，设计模式
---

设计模式之——模板方法 Template Method

# 序言
模板方法，又叫钩子函数或回调函数（Callback Function）。

考虑现实生活：<br>
学校为所有学生定义了一个模板：
```java
上学();
学习();
放学();
```
模板中 `上学()` 和 `放学()` 是空方法，要求学生们自己实现：
- 公交车
- 单车
- 步行
- 家长接送
- ……

这就是模板方法：<br>
- 在父类中定义所有子类**必须**实现的方法。
- 子类自定义地**具体**实现这些方法。

# 概念

> 以下内容引用自 [菜鸟教程](https://www.runoob.com/design-pattern/template-pattern.html)
> 
> ### 模板模式
> 在模板模式（Template Pattern）中，一个抽象类公开定义了执行它的方法的方式/模板。它的子类可以按需要重写方法实现，但调用将以抽象类中定义的方式进行。这种类型的设计模式属于行为型模式。
> 
> ### 介绍
> 意图
> - 定义一个操作中的算法的骨架，而将一些步骤延迟到子类中。模板方法使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤。
> 
> 主要解决
> - 一些方法通用，却在每一个子类都重新写了这一方法。
> 
> 何时使用
> - 有一些通用的方法。
> 
> 如何解决
> - 将这些通用算法抽象出来。
> 
> 关键代码
> - 在抽象类实现，其他步骤在子类实现。
> 
> 应用实例
> - 在造房子的时候，地基、走线、水管都一样，只有在建筑的后期才有加壁橱加栅栏等差异。 
> - 西游记里面菩萨定好的 81 难，这就是一个顶层的逻辑骨架。 
> - spring 中对 Hibernate 的支持，将一些已经定好的方法封装起来，比如开启事务、获取 Session、关闭 Session 等，程序员不重复写那些已经规范好的代码，直接丢一个实体就可以保存。
> 
> 优点
> - 封装不变部分，扩展可变部分。 
> - 提取公共代码，便于维护。 
> - 行为由父类控制，子类实现。
> 
> 缺点
> - 每一个不同的实现都需要一个子类来实现，导致类的个数增加，使得系统更加庞大。
> 
> 使用场景
> - 有多个子类共有的方法，且逻辑相同。 
> - 重要的、复杂的方法，可以考虑作为模板方法。
> 
> 注意事项
> - 为防止恶意操作，一般模板方法都加上 final 关键词。

# 案例
父类定义模板：方法和执行顺序
```java
abstract class Superclass {
    public void templateMethod(){
        method1();
        method2();
    }

    abstract void method1();
    abstract void method2();
}
```

子类具体实现
```java
class Subclass1 extends Superclass{
    @Override
    void method1() {
        System.out.println("subclass1 method1");
    }

    @Override
    void method2() {
        System.out.println("subclass1 method2");
    }
}
```
```java
class Subclass2 extends Superclass{
    @Override
    void method1() {
        System.out.println("subclass2 method1");
    }

    @Override
    void method2() {
        System.out.println("subclass2 method2");
    }
}
```


----------


调用
```java
public static void main(String[] args) {
	Superclass aClass1 = new Subclass1();
	aClass1.templateMethod();

	System.out.println("------");

	Superclass aClass2 = new Subclass2();
	aClass2.templateMethod();
}
```
结果
```java
subclass1 method1
subclass1 method2
------
subclass2 method1
subclass2 method2
```

# 源码链接
该文章源码链接 [Github](https://github.com/kekaiyuan/designpatterns/tree/main/src/main/java/com/kky/dp/templatemethod)