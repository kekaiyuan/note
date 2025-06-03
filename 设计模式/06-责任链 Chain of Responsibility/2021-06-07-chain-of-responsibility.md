---
layout: post
title: 设计模式之——责任链 Chain of Responsibility
categories: DesignPatterns
description: 设计模式之——责任链 Chain of Responsibility
keywords: Java,设计模式
mermaid: true
---

设计模式之——责任链 Chain of Responsibility

# 责任链

责任链是一个类似于**流水线**的设计模式。

通过**三个问题**理解责任链模式：


----------


**Q1**

假如现在程序里有类 A，然后需要**依次**调用 **100** 个方法处理 A

最简单的实现肯定是这样的
```java
A a = new A();
method1(a);
method2(a);
method3(a);
……
method100(a);
return a;
```


----------

**Q2**

如果说这 100 个方法**不需要全部调用**，而是**选择式**的。<br>
即先调用 `method1()` 处理，如果处理成功，则不调用剩下的方法。
如果处理失败，则调用 `method2()`……
```java
A a = new A();
if(method1(a)){
    return a;
}
if(method2(a)){
    return a;
}
if(method3(a)){
    return a;
}
……
method100(a);
return a;
```

这样的调用方式肯定是不好的，一个比较抖机灵的办法是**自定义异常**。<br>
如果这 100 个方法抛出了该异常，则代表**处理成功**。
```java
A a = new A();
try{
    method1(a);
    method2(a);
    method3(a);
    ……
    method100(a);
}catch(MyException e){
    ……
}finally{
    return a;
}
```

虽然这个方法有一些小问题，但确实是**可行**的。


----------

**Q3**

实现这些方法的**动态扩展**。

即我可以随时**添加**某个方法，也可以**删除**某个方法。


----------

Q1 和 Q2 还可以尝试用最粗暴的编程思想去解决，但是 Q3 却没有解决办法。

在程序中加入大量的参数和选择语句肯定是不可行的，我们急需一种设计模式来解决这个问题。

于是**责任链模式**应运而生。

![image](/images/posts/designpatterns/chain-of-responsibility/process2.png)

所有的处理方法组织成**链式结构**。<br>
然后某个具体的处理方法可以决定处理对象是否已经处理完毕，是否需要**交给下一个方法处理**，或是直接**结束处理流程**。

这就以一个比较完美的程序设计解决了 Q1 和 Q2。

至于 Q3，所有的处理类**继承**于同一个**接口**，然后可以用 `List` 这样的集合来保存这些处理类。<br>
然后调用 `List` 类的 `add()` 和 `remove()` 方法就可以很简单的实现**动态扩展**。

# 概念

> 以下内容引用自 [菜鸟教程](https://www.runoob.com/design-pattern/chain-of-responsibility-pattern.html)
> 
> ### 责任链模式
> 顾名思义，责任链模式（Chain of Responsibility Pattern）为请求创建了一个接收者对象的链。这种模式给予请求的类型，对请求的发送者和接收者进行解耦。这种类型的设计模式属于行为型模式。
> 
> 在这种模式中，通常每个接收者都包含对另一个接收者的引用。如果一个对象不能处理该请求，那么它会把相同的请求传给下一个接收者，依此类推。
> 
> ### 介绍
> 意图
> - 避免请求发送者与接收者耦合在一起，让多个对象都有可能接收请求，将这些对象连接成一条链，并且沿着这条链传递请求，直到有对象处理它为止。
> 
> 主要解决
> - 职责链上的处理者负责处理请求，客户只需要将请求发送到职责链上即可，无须关心请求的处理细节和请求的传递，所以职责链将请求的发送者和请求的处理者解耦了。
> 
> 何时使用
> - 在处理消息的时候用以过滤很多道。
> 
> 如何解决
> - 拦截的类都实现统一接口。
> 
> 关键代码
> - Handler 里面聚合它自己，在 HandlerRequest 里判断是否合适，如果没达到条件则向下传递，向谁传递之前 set 进去。
> 
> 应用实例
> - 红楼梦中的"击鼓传花"。
> - JS 中的事件冒泡。 
> - JAVA WEB 中 Apache Tomcat 对 Encoding 的处理，Struts2 的拦截器，jsp servlet 的 Filter。
> 
> 优点
> - 降低耦合度。它将请求的发送者和接收者解耦。
> - 简化了对象。使得对象不需要知道链的结构。 
> - 增强给对象指派职责的灵活性。通过改变链内的成员或者调动它们的次序，允许动态地新增或者删除责任。 
> - 增加新的请求处理类很方便。
> 
> 缺点
> - 不能保证请求一定被接收。 
> - 系统性能将受到一定影响，而且在进行代码调试时不太方便，可能会造成循环调用。 
> - 可能不容易观察运行时的特征，有碍于除错。
> 
> 使用场景 
> - 有多个对象可以处理同一个请求，具体哪个对象处理该请求由运行时刻自动确定。 
> - 在不明确指定接收者的情况下，向多个对象中的一个提交一个请求。 
> - 可动态指定一组对象处理请求。
> 
> 注意事项
> - 在 JAVA WEB 中遇到很多应用。

# 实现
**定义接口**
```java
public interface ProcessInterface {
    boolean execute(Object o);
}
```


----------

**定义三个实现类**
```java
public class Process1 implements ProcessInterface {
    @Override
    public boolean execute(Object o) {
        System.out.println("执行方法 1");
        Random random = new Random();
        if (random.nextInt(10) > 8) {
            return true;
        }
        return false;
    }
}
```
```java
public class Process2 implements ProcessInterface {
    @Override
    public boolean execute(Object o) {
        System.out.println("执行方法 2");
        Random random = new Random();
        if (random.nextInt(10) > 8) {
            return true;
        }
        return false;
    }
}
```
```java
public class Process3 implements ProcessInterface {
    @Override
    public boolean execute(Object o) {
        System.out.println("执行方法 3");
        Random random = new Random();
        if (random.nextInt(10) > 8) {
            return true;
        }
        return false;
    }
}
```


----------

**责任链**
```java
public class ChainOfResponsibility implements ProcessInterface {
    private List<ProcessInterface> chain = new ArrayList<ProcessInterface>(){{
        add(new Process1());
        add(new Process2());
        add(new Process3());
    }};

    public void addMethod(ProcessInterface method){
        chain.add(method);
    }

    public void removeMethod(int index){
        chain.remove(index);
    }

    @Override
    public boolean execute(Object o) {
        for (ProcessInterface method : chain) {
            boolean result = method.execute(o);
            if(result){
                return true;
            }
        }
        return false;
    }
}
```


----------

**说明**
1. 类之间是**解耦**的，不知道彼此的存在，它们的组合由责任链控制。
2. 方法的返回值**任意**，不一定是 `boolean`，用 `int`, `String`, `Object` 都可以。<br>
	甚至可以是 `void`，通过读取参数的值或是抛出异常来实现。<br>
	只要能提供一个**判断依据**即可。
3. 责任链最好也**实现接口**，这样多个责任链的**结构统一**，而且可以实现多个责任链的**组合**。


----------

**测试**
- 简单调用
	```java
	ChainOfResponsibility chainOfResponsibility = new ChainOfResponsibility();
	Object obj = new Object();
	chainOfResponsibility.execute(obj);
	```
	```java
	执行方法 1
	执行方法 2
	执行方法 3
	```
- 添加方法
	```java
	chainOfResponsibility.addMethod(new Process1());
	chainOfResponsibility.execute(obj);
	```
	```java
	执行方法 1
	执行方法 2
	执行方法 3
	执行方法 1
	```
- 移除方法
	```java
	chainOfResponsibility.removeMethod(2);
	chainOfResponsibility.execute(obj);
	```
	```java
	执行方法 1
	执行方法 2
	执行方法 1
	```
- 拼接两个责任链
	```java
	ChainOfResponsibility chainOfResponsibility2 = new ChainOfResponsibility();
	chainOfResponsibility.addMethod(chainOfResponsibility2);
	chainOfResponsibility.execute(obj);
	```
	```java
	执行方法 1
	执行方法 2
	执行方法 1
	执行方法 1
	执行方法 2
	执行方法 3
	```
	
可以看到，使用**责任链**以后我们可以很方便地组织对某个对象的处理过程。


# Servlet中的责任链
Servlet 是常用的前后端交互的技术，它把前端发送的请求传入后端进行处理然后再返回给前端。<br>
从 Client 到 Server ，称为 Request 。<br>
从后端到 Client ，称为 Response 。<br>
在这个过程中，需要用到多个 Filter 过滤器对数据进行处理。<br>
Request 需要 Filter 过滤掉不必要的前端信息。<br>
Response 需要 Filter 加上必要的前端信息。

如果采用这样的设计<br>
![image](/images/posts/designpatterns/chain-of-responsibility/server01.png)
这需要实现两个责任链，六个 Filter ，而且需要建立两次 Http 请求。<br>
一次 Http 请求是从

可以改进一下，使用一条责任链完成

假设现在有三个过滤器，<br>
从前端到后端，需要经过 Filter1 , Filter2 , Filter3 <br>
从后端到前端，需要经过 Filter3 , Filter2 , Filter1 <br>
过滤器在数据的往返时都需要用到，而且顺序是相反的。<br>
这种设计应该如何用责任链实现?


```java

```
```java

```
```java

```
# 源码链接
该文章源码链接 [url](url)
