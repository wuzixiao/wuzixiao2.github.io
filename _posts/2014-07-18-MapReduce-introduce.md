---
layout: post
title: "MapReduce简介"
description: ""
category:
tags: [Progamming]
---
{% include JB/setup %}

MapReduce 是主要用来处理大数据的编程模型。用户通过编写map函数来生成中间数据，它以key/value形式被生成，然后这些数据被reduce函数通过合并相同key的value值来生产最后的结果。

简单的说，就是“*先分开，再合并*”。

例子：计算大量文件中每个单词的个数。
{% highlight C++ %}
map(String key, String value):
    // key: document name
    // value: document contents
    for each word w in value:
        EmitInternediate(w, "1");

reduce(String key, Iterator values):
    // key: a word
    // values: al list of counts
    int result = 0;
    for each v in values:
        result += PaseInt(v);
    Emit(AsString(resutl));
{% endhighlight %}


更多例子
统计url的访问量：统计日志，map输出中间变量（url，1），reduce统计结果，输出（url，total count)


MapReduce的流程图

<img src="/images/mapreduce.png" alt="mapreduce" class="img-center" width="250" height="250"/>

1 input文件先被分割成16m至64m大小（根据配置文件的设定），便于map程序并行的处理。
2 master程序是整个MapReduce的指挥官。它负责分配任务。一共有M个map任务和R个Reduce任务需要分配。它挑选闲置的机器给他们分配map或者reduce任务。
3 执行map任务的机器从input files中读取一个split, 然后交给map函数分析，map函数会生成key/value 对，保存在buffer中。
4 buffer中的数据被定期的写到硬盘中。并不是写到一个文件中，而是R个文件。至于怎么分配，可以想像成一个hash算法。这些文件的位置会被发送给master,他们将来会安排reduce任务读取这些文件。
5 当reduce任务被分配给一台机器时，它同时会得到步骤4中文件的位置信息，然后他们利用RPC读取这些文件，当reduce程序从所有的map中读取中间数据之后，它会对这些key/value根据key来排序，因为有时不相同的key也会被map到同一个reduce任务中。
6 Reduce任务会先去遍历这些排序过的数据，然后把具有相同key的value集和这个key一起传给reduce函数，函数的输出结果会被保存到最终文件内。
7 当所有的map和reduce任务结束之后，master将通知用户程序。

从上述的执行过程可以看出，用户只需要编写map和reduce函数就可以，其它如：预处理，错误处理，排序，分块等任务都会被mapreduce库来处理。

