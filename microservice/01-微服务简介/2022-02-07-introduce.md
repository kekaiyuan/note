---
layout: post
title: 微服务架构——微服务简介
categories: 微服务
description: 微服务架构——微服务简介
keywords: 微服务简介
---



# 微服务技术对比

| | Dubbo | Spring Cloud | Spring Cloud Alibaba |
| :--: | :--: | :--: | :--: |
| 年份 |  |  |  |
| 注册中心 | Zookeeper,<br>Redis | Euraka,<br>Consul| Nacos,<br>Euraka |
| 服务远程调用 | Dubbo 协议 | Feign（http协议）| Dubbo,<br>Feign |
| 配置中心 | 无 | Spring Cloud Config| Spring Cloud Config,<br>Nacos |
| 服务网关 | 无 | Spring Cloud Gateway,<br>Zuul| Spring Cloud Gateway,<br>Zuul| 
| 服务监控和保护 | dubbo-admin（功能弱） | Hystrix| Sentinel |

## Dubbo
Dubbo 的诞生时间很早，所以比起目前主流的微服务架构少了很多组件。
- 没有配置中心和服务网关
- Zookeeper 是集群管理工具，Redis 是缓存<br>
	这两个都不是专业的注册中心，Dubbo 只是用这两个工具实现了简单的注册中心
- 在服务监控和保护方面，自带了 dubbo-admin，但是功能非常弱，只有基础功能

它的重点是提出了服务远程调用的概念，并且定义了严格的 dubbo 协议。

在项目量级不够时，可以使用 Dubbo 实现简单的分布式服务。

## Spring Cloud
目前全世界范围内**最流行**的微服务框架。

Spring Cloud 除了把各种第三方公司的组件整合进来，还做了一个很重要的事——**基于 SpringBoot 实现了组件的自动装配，简化流程，实现了良好的开箱即用体验**。
- 开发中一定要注意 Spring Cloud 和 Spring Boot 两者版本是否**兼容**。


## Spring Cloud Alibaba
Dubbo 并不是一套成熟的微服务架构，所以阿里在经过一段时间后，也是推出了属于自己的微服务架构——Spring Cloud Alibaba。
- 既然开头是 Spring Cloud，说明 Spring Cloud Alibaba 是继承于 Spring Cloud 的，很多东西一脉相承。<br>
- 除此之外，Spring Cloud Alibaba 还把 Dubbo 整合了进来。

所以 Spring Cloud Alibaba 可以视为 Dubbo 和 Spring Cloud 两种微服务架构的整合版。
- 比如 Nacos 即支持 Dubbo，又支持 Feign。

Spring Cloud Alibaba 最近的热度越来越高，有赶超 Spring Cloud 的趋势。

## 企业需求
当今企业的架构需求可以概括为以下四种：

||技术栈|服务接口风格|服务调用方式|
|:--:|:--:|:--:|:--:|
|Spring Cloud<br>+ Feign |Spring Cloud | Restful | Feign |
|Spring Cloud Alibaba<br>+ Feign | Spring Cloud Alibaba | Restful | Feign |
|Spring Cloud Alibaba<br>+ Dubbo | Spring Cloud Alibaba | Dubbo | Dubbo |
| Dubbo | Dubbo | Dubbo | Dubbo |

# 源码链接
该文章源码链接 [Github](url)