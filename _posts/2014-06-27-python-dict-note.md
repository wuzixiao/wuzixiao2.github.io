---
layout: post
title: "Python dict 的实现"
description: ""
category:
tags: [Python]
---
{% include JB/setup %}

Python中的Dictionary是个非常方便的数据结构。Python语言内部也使用它来保存信息。
比如：

{% highlight python %}
>>> obj = MyClass( )  # Create a class instance
>>> obj.name = 'object'  #add a .name attribute
>>> obj.id = 14      #add a .id attribute
>>> obj.__dict__  #Retrieve the underlying dictionary
{'name': 'object', 'id': 14}
>>> obj.__dict__['id'] = 12  #Store a new value in the dictionary
>>> obj.id   #Attribute is changed accordingly
12
{% endhighlight %}

Python是一门学院派的语言，但是从Dict的实现来看，想成为一个实用的语言就需要去权衡代码的简洁和实际使用的效率问题。

* 在Dict中既保存key也保存hash code. 这样做就不必每次都去计算key的hash code而浪费时间。
* 有专门保存少于5个元素的table。这是一种在函数调用时候常用的结构，可以节省程序malloc()的开销。而且它在x86下是128字节，正好是2个64-byte cache line, 易于保存在CPU的cache中。
* dict中key经常是string类型，在Java实现的JPython中有为全部key都是string的Dict设计一个独立的结构，但是在CPython中是用另外一个方法实现的。CPython是在ma_lookup这个函数指针处实现的：如果全都都是string类型的key,那么ma_lookup实际指向lookdict_string，否则ma_lookup指向lookdict，它可以处理所有其它的类型。
* Collision的解决。为了节省在处理link所需要花费的额外时间，Python使用的是
{% highlight c %}
/* Starting slot */
slot = hash;
/* Initial perturbation value */
perturb = hash;
while (<slot is full> && <item in slot does not equal the key>) {
    slot = (5*slot) + 1 + perturb;
    perturb >>= 5;
}
{% endhighlight %}
这样，对所有的数据进行扁平化处理。至于为何是5而不是6或者4，是经过大量实际数据测试得出的。

* free list。频繁的使用malloc()和free()函数会降低程序的效率，所以Python的Dict内部使用了一个array保存了80个分配好的dict，保存在freedicts中。

总结来看，这里面使用的以空间换时间，内存池，对常用情况的特殊情况的方法。其实也都是一些常用的手段，关键是怎么利用这些手段做权衡。可见打模一个工业可用的软件，需要在细处下很多功夫。

