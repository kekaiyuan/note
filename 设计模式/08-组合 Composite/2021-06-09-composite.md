---
layout: post
title: 设计模式之——组合 Composite
categories: DesignPatterns
description: 设计模式之——组合 Composite
keywords: Java，设计模式
---

设计模式之——组合 Composite

## 组合模式
组合模式是一种将一组相似的对象组合成单一对象的模式。

典型就是文件系统。

文件组合成文件夹，但是文件夹并没有脱离文件的范畴。
文件夹依然与文件一样，可以与其他的文件或文件夹组成新的文件夹。

组合模式是一个对应树状结构的设计模式。

组合模式很简单，“组合” 和 “个体” 都继承于某个类，而 “组合” 只比 “个体” 多了个 add 方法和 remove 方法。

比如说。
人是对象，一群人就是一组人的组合。作为个体的“人”和作为组合的“一群人”都继承于人这个概念。
人能做什么，一群人也能做什么，组合无法脱离个体的属性范畴。
“你给我认真听讲！”
“你给赶紧吃饭！”
把 “你” 换成 “你们” ，这些话依然是合理的。

组合唯一多出来的，就是增加和删除。
一群人中加入一个人或是一群人中踢掉某个人。
仅此而已。

## 概念
> 以下内容引用自 [菜鸟教程](https://www.runoob.com/design-pattern/composite-pattern.html)
> 
> ### 组合模式
> 组合模式（Composite Pattern），又叫部分整体模式，是用于把一组相似的对象当作一个单一的对象。组合模式依据树形结构来组合对象，用来表示部分以及整体层次。这种类型的设计模式属于结构型模式，它创建了对象组的树形结构。
> 
> 这种模式创建了一个包含自己对象组的类。该类提供了修改相同对象组的方式。
> 
> 我们通过下面的实例来演示组合模式的用法。实例演示了一个组织中员工的层次结构。
> 
> ### 介绍
> 意图
> - 将对象组合成树形结构以表示"部分-整体"的层次结构。组合模式使得用户对单个对象和组合对象的使用具有一致性。
> 
> 主要解决
> - 它在我们树型结构的问题中，模糊了简单元素和复杂元素的概念，客户程序可以像处理简单元素一样来处理复杂元素，从而使得客户程序与复杂元素的内部结构解耦。
> 
> 何时使用
> - 您想表示对象的部分-整体层次结构（树形结构）。
> - 您希望用户忽略组合对象与单个对象的不同，用户将统一地使用组合结构中的所有对象。
> 
> 如何解决
> - 树枝和叶子实现统一接口，树枝内部组合该接口。
> 
> 关键代码
> - 树枝内部组合该接口，并且含有内部属性 List，里面放 Component。
> 
> 应用实例
> - 算术表达式包括操作数、操作符和另一个操作数，其中，另一个操作符也可以是操作数、操作符和另一个操作数。 
> - 在 JAVA AWT 和 SWING 中，对于 Button 和 Checkbox 是树叶，Container 是树枝。
> 
> 优点
> - 高层模块调用简单。
> - 节点自由增加。
> 
> 缺点
> - 在使用组合模式时，其叶子和树枝的声明都是实现类，而不是接口，违反了依赖倒置原则。
> 
> 使用场景
> - 部分、整体场景，如树形菜单，文件、文件夹的管理。
> 
> 注意事项
> - 定义时为具体类。

## 案例
如何用组合模式模拟一个只有文件名的简单文件系统？

该文件系统有文件和文件夹两种成员，文件夹下可以添加任意个文件夹和文件。

- UML图
![image](/images/posts/designpatterns/composite/uml.png)

- 抽象类
	- 文件夹和文件都继承于这个抽象类
		```java
		abstract class Node {
			//打印该节点的内容
			abstract public void print();
		}
		```
- 文件
	- 在树状结构中，没有子节点的节点称为叶子节点
		```java
		//叶子节点
		class LeafNode extends Node {
			//文件名
			String content;
			public LeafNode(String content) {this.content = content;}

			@Override
			public void print() {
				System.out.println(content);
			}
		}
		```
- 文件夹
	- 在树状机构中，有子节点的节点叫做分支节点
		```java
		//分支节点
		class BranchNode extends Node {
			//该文件夹下的列表，包括文件夹和文件
			List<Node> nodes = new ArrayList<>();

			//文件夹名
			String name;
			public BranchNode(String name) {this.name = name;}

			@Override
			public void print() {
				System.out.println(name);
			}

			//添加子节点
			public void add(Node n) {
				nodes.add(n);
			}
		}
		```
- 使用方法
	- 首先定义根目录。
		```java
		BranchNode root = new BranchNode("root");
		```
	- 在根目录下添加文件。
		```java
		Node r1 = new LeafNode("r1");
		root.add(r1);
		```
	- 在根目录下添加文件夹。
		```java
		BranchNode chapter1 = new BranchNode("chapter1");
		root.add(chapter1);
		```
	- 子文件夹的操作雷同。

- 遍历<br>
   树状结构的遍历建议使用递归。
	```java
	//遍历node下的所有内容，depth为该节点的高度
	static void tree(Node node, int depth) {
		//为了美观，打印"-"为文件分级
		for(int i=0; i<depth; i++) {
			System.out.print("-");
		}
		//打印节点
		node.print();

		//遍历节点下的子节点
		if(node instanceof BranchNode) {
			for (Node n : ((BranchNode)node).nodes) {
				tree(n, depth + 1);
			}
		}
	}
	```
- 结果
	```java
	root
	-chapter1
	--c11
	--c12
	-chapter2
	--section21
	---c211
	---c212
	-r1
	```

## 注意
遍历树状结构时最好使用**递归**，虽然会增加资源消耗，但是编程简单，不易出错。

## 源码链接
该文章源码链接 [Github](https://github.com/kekaiyuan/designpatterns/tree/main/src/main/java/com/kky/dp/composite)
