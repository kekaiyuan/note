---
layout: post
title: 设计模式之——单例 Singleton
categories: DesignPatterns
description: 设计模式之——单例 Singleton
keywords: Java，设计模式
---

设计模式之——单例 Singleton

# 概念

> 以下内容引用自 [菜鸟教程](https://www.runoob.com/design-pattern/singleton-pattern.html)
> 
> ### 单例模式
> 单例模式（Singleton Pattern）是 Java 中最简单的设计模式之一。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。
> 
> 这种模式涉及到一个单一的类，该类负责创建自己的对象，同时确保只有单个对象被创建。这个类提供了一种访问其唯一的对象的方式，可以直接访问，不需要实例化该类的对象。
> 
> ### 注意
> 
> - 单例类只能有一个实例。
> - 单例类必须自己创建自己的唯一实例。
> - 单例类必须给所有其他对象提供这一实例。
> 
> ### 介绍
> 意图
> - 保证一个类仅有一个实例，并提供一个访问它的全局访问点。
> 
> 主要解决
> - 一个全局使用的类频繁地创建与销毁。
> 
> 何时使用
> - 当您想控制实例数目，节省系统资源的时候。
> 
> 如何解决
> - 判断系统是否已经有这个单例，如果有则返回，如果没有则创建。
> 
> **关键代码**
> - 构造函数是**私有**的。
> 
> 应用实例
> - 一个班级只有一个班主任。
> - Windows 是多进程多线程的，在操作一个文件的时候，就不可避免地出现多个进程或线程同时操作一个文件的现象，所以所有文件的处理必须通过唯一的实例来进行。
> - 一些设备管理器常常设计为单例模式，比如一个电脑有两台打印机，在输出的时候就要处理不能两台打印机打印同一个文件。
> 
> 优点
> - 在内存里只有一个实例，减少了内存的开销，尤其是频繁的创建和销毁实例（比如管理学院首页页面缓存）。
> - 避免对资源的多重占用（比如写文件操作）。
> 
> 缺点
> - 没有接口，不能继承，与单一职责原则冲突，一个类应该只关心内部逻辑，而不关心外面怎么样来实例化。
> 
> 使用场景：
> - 要求生产唯一序列号。
> - WEB 中的计数器，不用每次刷新都在数据库里加一次，用单例先缓存起来。
> - 创建的一个对象需要消耗的资源过多，比如 I/O 与数据库的连接等。
> 
> 注意事项
> - getInstance() 方法中需要使用同步锁 synchronized (Singleton.class) 防止多线程同时进入造成 instance 被多次实例化。

# 实现
单例模式的关键在于：
1. 将**构造函数私有化**，使得外部无法创建实例。
2. 由该类自己创建实例，并且保证**实例唯一**。<br>
	需要考虑多线程并发下的安全问题。

## 饿汉式

饿汉式是**最经典**的单例模式，通过**静态变量**或**静态代码块**创建实例，即在**类加载**时创建，那么此时是不存在多线程并发的，所以无需考虑线程安全问题。

优点很明显，设计简单，不容易出错，不需要关心线程不安全的问题，同时逻辑简洁，运行效率高。

至于所谓的缺点，即饿汉式这个名称的由来：<br>
该单例模式的创建和使用是分开的，所以存在创建实例后却没有执行任何任务，发生对象饿死的情况。

这个问题是分场景的：

JVM 共有四种类加载器：
- 启动类加载器<br>
	加载 `<JAVA_HOME>/lib` 目录下的常用**基础**库：
	- `java.util.*`, `java.io.*`, `java.lang.*` 这些以 `java` 开头的类库。
	-  因为语言差异，一些底层原理需要用 C 语言实现的类。
- 扩展类加载器<br>
	加载 `<JAVA_HOME>/lib/ext` 目录下的 JVM **扩展**类：
	- swing 系列，js 引擎，xml 解析器等，这些类库以 `javax` 开头
- 系统类加载器<br>
	加载用户路径（ClassPath）下的类，也是使用次数最多的类加载器，用于加载我们**自定义**的类和引入的**第三方** jar 包。
- 自定义加载器<br>
	除了 JVM 定义的三种类加载器，我们可以自定义实现一个加载器。

那么哪些类会在程序开始运行后，立即加载的呢？

只有启动类和扩展类。<br>
而我们自定义的类和第三方 jar 包则是使用时才加载，也就是说天然就是懒加载的。

所以在平常使用时，饿汉式的单例模式是**不会饿死**的。

**考虑饿汉式单例会不会饿死时，应该先考虑当前环境下，这个单例模式会不会在程序启动时直接进行类加载。**

----------

### 静态变量

```java
public class Singleton01 {

    private static final Singleton01 INSTANCE = new Singleton01();

    private Singleton01(){}

    public static Singleton01 getInstance(){
        return INSTANCE;
    }
}
```

### 静态代码块

```java
public class Singleton02 {

    private static final Singleton02 INSTANCE;

    static {
        INSTANCE = new Singleton02();
    }

    private Singleton02(){}

    public static Singleton02 getInstance(){
        return INSTANCE;
    }
}
```

## 懒汉式

懒汉式即实现懒加载，用到的时候才创建实例。

那么此时需要考虑线程安全问题：<br>
某一时刻实例尚未创建，如果此时有多个线程同时访问该实例，就会创建多个实例，违反单例模式的定义。

所以需要实现线程同步。

```java
public class Singleton03 {

    private static Singleton03 INSTANCE;

    private Singleton03(){
    }

    public static synchronized Singleton03 getInstance() {
        if(INSTANCE == null){
            INSTANCE = new Singleton03();
        }
        return INSTANCE;
    }
}
```

## 双检锁
双检锁是懒汉式的升级，懒汉式使用的是同步方法，这也导致了每次取实例对象都需要上锁，浪费资源。

而双检锁减小了同步代码块的大小，提高并发度和效率。
- 只有实例未初始化时，创建实例的过程需要上锁，防止创建多个实例。
- 取对象时直接取即可。

```java
public class Singleton04 {

    //使用volatile关键字，禁止指令重排
    private static volatile Singleton04 INSTANCE;

    private Singleton04(){
    }

    public static Singleton04 getInstance() {
        if(INSTANCE == null){
            // 上锁
            synchronized (Singleton04.class){
                //双重检查
                if(INSTANCE == null){
                    INSTANCE = new Singleton04();
                }
            }
        }
        return INSTANCE;
    }
}
```
在双检锁中，必须使用 volatile 关键字，原因是 [禁止指令重排](https://kekaiyuan.github.io//2021/07/16/volatile/#%E7%A6%81%E7%94%A8%E6%8C%87%E4%BB%A4%E9%87%8D%E6%8E%92)


## 静态内部类

可以采用静态内部类的方式，由 JVM 保证单例。<br>
同时加载外部类时并不会加载内部类，可以实现懒加载。

```java
public class Singleton05 {

    private Singleton05(){}

    private static class Singleton{
        private final static Singleton05 INSTANCE = new Singleton05();
    }

    public static Singleton05 getInstance(){
        return Singleton.INSTANCE;
    }
}
```

## 枚举
**使用反射破坏单例模式**

以上四种单例模式的关键之一在于将**构造函数私有化**，从而阻止其它创建实例的行为。

但是 Java 的反射机制可以获取一个类的**私有构造器**，并设置成可访问的，从而破坏单例模式。

```java
public static void main(String[] args) throws Exception {
	// 创建实例 1
	Singleton01 singleton01 = Singleton01.getInstance();

	// 通过反射获取构造器
	Class<? extends Singleton01> aClass = singleton01.getClass();
	Constructor<? extends Singleton01> constructor = aClass.getDeclaredConstructor();

	// 设置构造器为可访问的
	constructor.setAccessible(true);

	// 创建实例 2
	Singleton01 singleton02 = constructor.newInstance();

	// 对比是否是同一个对象
	System.out.println(singleton01 == singleton02); // false
}
```

注意，只能通过 `getDeclaredConstructor()` 方法获取 `private` 构造器。<br>
`getConstructor()` 方法和 `getConstructors()` 方法都无效。

结果
```java
false
```

可以看到，单例模式失效了。




----------
如果要防止反射的话，可以使用枚举来实现单例模式。

枚举这种特殊的数据类型天生就是单例的，而且无法通过反射获取其构造器，还可以**防止反序列化**。

```java
public enum Singleton06 {

    INSTANCE;

    public static Singleton06 getInstance(){
        return INSTANCE;
    }
}
```

# 如何检查是否是单例模式？
通过 `hashCode()` 方法判断
```java
//多线程访问，通过hashcode检验是否是单例模式
for(int i=0;i<100;i++){
	new Thread(()-> System.out.println(Singleton06.getInstance().hashCode())).start();
}
```

# 源码链接
该文章源码链接 [Github](https://github.com/kekaiyuan/designpatterns/tree/main/src/main/java/com/kky/dp/singleton)
