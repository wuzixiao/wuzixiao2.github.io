---
layout: post
title: "Dao of Software Develop"
description: ""
category: Blog
tags: [Develop]
---

{% include JB/setup %}

- 程序总是会在各种的情况下出错，bug一词就说明了外界环境也会造成程序出错。所以不要为错误找借口，而是提供解决方案。

- 不好的设计要及时纠正，否则会影响全局。

- 在团队管理中，做变化的催化剂，而不是自己什么都做。

- 欲求更好，常把好事变糟。知道如何权衡，才能做出足够好的软件。

- 定期投资你的知识资产，比如每年学一门新语言。

- 交流：被打量比被忽视要好。blog，youtube，stackoverflow。

- UNIX设计哲学，将一件事做到最好。

- 正交性与重复。这是系统设计的关键之处。

- 框架

- 要使用GIT。

- 调试，先要接受出错的事实。Don’t be panic。检查程序，使之没有警告。再现错误。简化程序。检查可疑的代码是否通过的测试，是否还存在系统的其它地方。向别人解释程序。

- 按合约设计：合约应该应该做为约定贯穿整个项目。首先要知道没有完美的代码，谁写的都可以出错。所以，对别人代码（或者内部函数）的调用要用检查结果，异常处理等防范措失。自己写的代码当然也不会100%正确，就也需要做同样的处理。处理的方式就要用合约的方式事先约定好。每段程序都会做某件事情。在做事开始前和结束之后，做一些保证，尽量让程序的结果不出意外是合约的关键。1 前条件，它应该由调用者完成，如果参数不符合程序的需求，那么就不应该去调用。2 后条件：程序或者函数应该有结束的状态。3 类不变项，我理解这个不变项就是尽量不要使用引用。

 
- 提早崩溃：尽量早的发现问题，比如要向一个文件中写数据，比较好的方法是先查看一个文件是否已经关闭再去打开并写数据。不早了差的方法是不去检查，打开时出错了也选择忽视错误，并继续写数据，结果会很糟。在这里我们有两个位置可以利用，如果都没有去做，我只能说“no zuo no die”。
 
- 断言式编程：如果这事绝不对发生，那么就用断言确定它不会发生。比如这个软件绝不会被用上30年，所以，日期处理时就用两位就够了，那要加上assert。

- 异常：异常是为了简化程序中检查每一个错误造成的代码复杂性。所谓异常就是意外事件，它不是像断言中的绝不可能发生的事，而是在正常过程之外的事。

