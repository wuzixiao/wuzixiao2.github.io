---
layout: post
title: "Python程序员容易犯的10个错误"
description: ""
category:
tags: [Programming, Python]
---
{% include JB/setup %}


关于Python
Python是一门解释性、面向对象的高级动态语言。它的内建高级数据结构、动态类型推导与绑定使它对于快速应用程序开发很用吸引力，同时也经常被用做脚本语言和联接各种组件和服务的粘合语言。Python支持模块与包，所以它鼓励程序的模块化与代码重用。

关于这篇文章
Python的简单和容易学习有时会让程序员产生误解－－尤其是刚开始学习这门语言的人－－容易掉进坑中，也不能很好的理解这门语言的强大之处。
基于这点，本文列举了10个不太容易被人发觉的错误，这些错误哪怕是很多高级的Python程序员也有犯的时候。
<声明:这篇文章的读者需要对Python有深入一点的了解，不然请先读另外一篇文章<a href="http://www.onlamp.com/pub/a/python/2004/02/05/learn_python.html">Python程序员的常见错误</a>。

常见错误1：错误的把表达式当成函数默认参数使用
Python允许程序员指定函数的默认参数。尽管这是一个很好的特性，不过当传递可变类型参数时会让人感觉疑惑。例如,这个函数定义：
{% highlight Python %}
>>> def foo(bar=[]):        # bar is optional and defaults to [] if not specified
...    bar.append("baz")    # but this line could be problematic, as we'll see...
...    return bar
{% endhighlight %}

一个很普遍的错误是：对于可选参数，只要在函数调用的时候没有赋值，那么它就应该是默认值。对于上面代码所示的例子，你可能会认为当函数foo被重复的调用时，每次都将返回‘baz’（因为每次在调用foo时，都没有指定任何参数，所示每次都默认的传递[]为bar赋初值）。
但是我们看实际的情况：
{% highlight Python %}
>>> foo()
["baz"]
>>> foo()
["baz", "baz"]
>>> foo()
["baz", "baz", "baz"]
{% endhighlight %}

嗯？为什么每次调用函数foo的时候都会append‘baz’到已有的队列bar中，而不是重新创造一个新的list呢？
答案是，函数参数被赋于默认值这个过程只在函数被定义的时候发生。因此，例子中的[]被赋于bar只发生foo()被第一次定义的时候，而之后调用foo()的时候，都不再会重新定义一个bar，而是使用之前已经定义的bar。
FYI，普通的做法请参考下面的代码：
{% highlight Python %}
>>> def foo(bar=None):
...    if bar is None:# or if not bar:
...        bar = []
...    bar.append("baz")
...    return bar
...
>>> foo()
["baz"]
>>> foo()
["baz"]
>>> foo()
["baz"]
{% endhighlight %}

常见错误2：错误的使用class变量
请看下面的例子：

{% highlight Python %}
>>> class A(object):
...     x = 1
...
>>> class B(A):
...     pass
...
>>> class C(A):
...     pass
...
>>> print A.x, B.x, C.x
1 1 1
{% endhighlight %}

这里可以说的通

{% highlight Python %}
>>> B.x = 2
>>> print A.x, B.x, C.x
1 2 1
{% endhighlight %}

到这也没有问题
{% highlight Python %}
>>> A.x = 3
>>> print A.x, B.x, C.x
3 2 3
{% endhighlight %}

怎么回事？我们只改变了A.x，为什么C.x也变了呢？
在Python中，class变量的内部处理和字典处理一样，依据<a href="http://python-history.blogspot.com.ar/2010/06/method-resolution-order.html">Method Resolution Order（MRO）</a>。所以对于上面的代码，由于C中没有x变量，解释器会在C的基类中查找x。换名话说，C并没有x属性，而依靠它的基类A。因此，C.x实际上就是A.x。

常见错误3：在expect块中指定错误的参数
假设你写了下面的代码：
{% highlight Python %}
>>> try:
...     l = ["a", "b"]
...     int(l[2])
... except ValueError, IndexError:  # To catch both exceptions, right?
...     pass
...
Traceback (most recent call last):
  File "<stdin>", line 3, in <module>
  IndexError: list index out of range
{% endhighlight %}

这个代码的错误之处是expect并不支持将list做为后面的表达式。然而，在Python2.x中，“expect Exception，e”是将可选的第二个参数（这个例子中的e）绑定给异常（exception)，以便将来可以对它进行检查。结果，上面的例子中，IndexError就无法被捕获了。IndexError成了给这个例外表达式做结束的参数名（the exception instead ends up being bound to a parameter named IndexError)
捕获多种异常的合理方法是将第一个参数指定为一个元组(tuple)，在里面包括所有需要捕获的异常类型。并且，尽量使用as关键词，这样就能同时支持Python2和Python3了。
{% highlight Python %}
>>> try:
...     l = ["a", "b"]
...     int(l[2])
... except (ValueError, IndexError) as e:  
...     pass
...
>>>
{% endhighlight %}

常见错误４：错误理解了Python的作用域。
Python的作用域是基于<a href="https://blog.mozilla.org/webdev/2011/01/31/python-scoping-understanding-legb/">LEGB(Local,Enclosing,Global,Build-in)</a>规则解决的。看起来很简单明了吧？实际上Python在这方面有几个坑。看下面的代码：
{% highlight Python %}
>>> x = 10
>>> def foo():
...     x += 1
...     print x
...
>>> foo()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
    File "<stdin>", line 2, in foo
    UnboundLocalError: local variable 'x' referenced before assignment
{% endhighlight %}

这个是什么问题？
上面的错误是这样发生的：当你在一个作用域中进行赋值操作时，操作中的变量被自动的认为是当前作用域中，而作用域之外同名的变量隐藏起来。
许多人也许会惊讶为什么之前运行正常的一段给变量赋值的代码在这里却发生了UnboundLocalError呢？（更多请参看<a href="https://docs.python.org/2/faq/programming.html#why-am-i-getting-an-unboundlocalerror-when-the-variable-has-a-value">这里</a>）
在使用lists时可能会让更多程序员裁了跟头。看这面的例子：
>>> lst = [1, 2, 3]
>>> def foo1():
...     lst.append(5)   # This works ok...
...
>>> foo1()
>>> lst
[1, 2, 3, 5]

>>> lst = [1, 2, 3]
>>> def foo2():
...     lst += [5]      # ... but this bombs!
...
>>> foo2()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
    File "<stdin>", line 2, in foo
    UnboundLocalError: local variable 'lst' referenced before assignment

嗯？为什么foo2出了错而foo1正确呢？
答案与上面的例子类似，只是这里有一点微小的不同。foo１并不是要赋值给lst，而foo2是。还记得lst += [5]是lst＝lst＋[5]的简写形式吗？这里发生的赋值的情况。简单的说，在Python中作用域外的变量是可读但不可写的。（这里的可读与可写是对于动态类型的语言来说的，可读是保持类型不变，仅在当前类型下进行一些操作，不可使用‘＝’发生赋值操作。可写是使用‘＝’发生赋值，动态语言的赋值可以改变变量的整个类型。）

常见错误５：遍历数组时修改了原数组
下面代码的错误十分明显：
>>> odd = lambda x : bool(x % 2)
>>> numbers = [n for n in range(10)]
>>> for i in range(len(numbers)):
...     if odd(numbers[i]):
...         del numbers[i]  # BAD: Deleting item from a list while iterating over it
...
Traceback (most recent call last):
      File "<stdin>", line 2, in <module>
      IndexError: list index out of range

对于有经验的程序员应该都会知道不能在遍历数组或者列表的时候删除里面的元素。但是当情况变得比上面的代码复杂一些的时候，即使是编程高手也可能不小心犯下上面这样的错误。
幸运的是，Python包含了一些很棒的编程范式，只要运用得当，就可以使代码变得十分清晰明了。这种简化代码的好处之一就是可以很大程度避免我们犯上面说的错误。这个范式叫<a href="https://docs.python.org/2/tutorial/datastructures.html#tut-listcomps">列表推导式</a>。进一步说，这个特性对于这个问题十分有用，请看上面代码的另外一种解决了问题的方法：
>>> odd = lambda x : bool(x % 2)
>>> numbers = [n for n in range(10)]
>>> numbers[:] = [n for n in numbers if not odd(n)]  # ahh, the beauty of it all
>>> numbers
[0, 2, 4, 6, 8]

常见错误6：对于Python如何在闭包中绑定变量不是很清楚
请看下面的例子：
>>> def create_multipliers():
...     return [lambda x : i * x for i in range(5)]
>>> for multiplier in create_multipliers():
...     print multiplier(2)
...
你可能会觉得输出下面的结果：
0
2
4
6
8
而实际上输出的是：
8
8
8
8
8
很吃惊吧！

这是由于Python的延迟绑定行为造成的，也就是说闭包中的变量值是多少是在其内部函数被调用的时候确定的。所以对于上面的例子，不管是哪个返回函数被调用了，变量i的值是在它被调用时的作用域里被确定下来的（这个时候，循环已经结束了，i的值被确定为4）

解决这个问题需要一点窍门。
>>> def create_multipliers():
...     return [lambda x, i=i : i * x for i in range(5)]
...
>>> for multiplier in create_multipliers():
...     print multiplier(2)
...
0
2
4
6
8
哈哈！我们使用默认参数的方法得到匿名函数来达到想要的效果。有些人觉得这个做很优美。有些人认为这是一个坑。而有些人很不喜欢这样。不过如果你是一个Python程序员，最重要的就是对它的各种情况都清楚明白。


常见错误7：创建循环的模块依赖
让我们假设有两个文件，a.py 和 b.py, 这两个文件相互引用，如下所示：
在a.py中:
import b
def f():
    return b.x

print f()

在b.py中：
import a

x = 1

def g():
    print a.f()

首先，我们试一下引用a.py:
>>> import a
1

正常工作。也许你会有一点吃惊。毕竟，这里确实存在会导致错误出错的相互引用的情况，不是吗？
答案是仅仅是两个看上去的相互引用并不会在Python中引起错误发生。如果一个模块已经被引用，Python是可以做到不重复的引用的。但是，还要看每个模块是何时去访问另外模块的函数或者变量的，这里可能的确会引起错误发生的。

回到我们的例子，当我们引用a.py的时候，引用b.py没有错误出现，是因为在b.py中并不需要在它引用的时候从a.py中得到什么。b.py中只使用了a.f(),而它是在g()中才调用的。而a.py和b.py在引用的时候都不会去调用g(),所以一切ok。

但是当我们引用b.py时（之前没有先引用a.py）：
>>> import b
Traceback (most recent call last):
        File "<stdin>", line 1, in <module>
        File "b.py", line 1, in <module>
    import a
        File "a.py", line 6, in <module>
      print f()
        File "a.py", line 4, in f
      return b.x
AttributeError: 'module' object has no attribute 'x'

哦哦！不好了！这里的问题是，引用b.py的时候，它会先引用a.py,在a中会调用f(),f()中要访问b.x.但是b.x还没有被定义呢！因此，AttributeError异常就出现了。

这里的一个解决方法倒是没有什么，简单的改一下b.py将import a放到g()内部：

x = 1

def g():
    import a  # This will be evaluated only when g() is called
    print a.f()

这样当我们引用的时候，一切ok了：
>>> import b
>>> b.g()
1# Printed a first time since module 'a' calls 'print f()' at the end
1# Printed a second time, this one is our call to 'g'

常见错误8：和Python标准库的模块发生命名冲突
Python的优点之一是它那些让人难以想象的模块库。但是，如果你不小心，就有可能让你自己的模块名与Python自带的模块库中的名字发生冲突（例如，你也可能有一个叫“email.py”的模块，它就会有标准里的同名的模块发生冲突）
这可能会导致严重的问题。例如本来你打算引用一个自己的模块结果却把标准库中的模块引用;因为重名，另外的程序包本来想引用标准库却把你的模块错误的引用进来。错误就这样发生了。
因此，应该小心一点别和标准库中的模块重名。比较容易的方式是把你的代码里的模块名字换一个，总要比去<a href="http://legacy.python.org/dev/peps/">PEP</a>提申请把标准模块名字改掉要好的多：）

常见错误9：错误处理Python2和Python3的不同
看下面的代码：
import sys

def bar(i):
    if i == 1:
        raise KeyError(1)
    if i == 2:
        raise ValueError(2)

def bad():
    e = None
    try:
        bar(int(sys.argv[1]))
    except KeyError as e:
        print('key error')
    except ValueError as e:
        print('value error')
    print(e)

bad()

在Python2里，运行正常：
$ Python foo.py 1
key error
1
$ Python foo.py 2
value error
2

不过现在让我们在Python3里试一下：
$ Python3 foo.py 1
key error
Traceback (most recent call last):
  File "foo.py", line 19, in <module>
    bad()
  File "foo.py", line 17, in bad
    print(e)
UnboundLocalError: local variable 'e' referenced before assignment

这是怎么回事？这里的"问题"是，在Python3中，异常(exception)对象并不能在except作用域之外被访问（这其中的原因是，这样做会在栈空间中保存一个引用循环，直到自动垃圾回收器运行的时候才被清理掉。更多技术细节请参考<a href="https://docs.python.org/3/reference/compound_stmts.html#except">这里</a>）
避免这个问题的方法之一是在except作用域之外保存一个异常(exception)对象的引用，这样它就可以被访问了。这时的代码可以同时在Python2和Python3中运行。
import sys

def bar(i):
    if i == 1:
        raise KeyError(1)
    if i == 2:
        raise ValueError(2)

def good():
    exception = None
    try:
        bar(int(sys.argv[1]))
    except KeyError as e:
        exception = e
        print('key error')
    except ValueError as e:
        exception = e
        print('value error')
    print(exception)

good()

在Py3K中运行：
$ Python3 foo.py 1
key error
1
$ Python3 foo.py 2
value error
2

好的！
（顺便说一下，我们的<a href="http://www.toptal.com/python#hiring-guide">Python Hiring Guide</a>讨论了另外一些从Python2向Python3移植时需要注意的重点之处）

常见错误10：错误的使用__del__方法
我们假设你的mod.py文件有这样的代码：
import foo

class Bar(object):
   	    ...
    def __del__(self):
        foo.cleanup(self.myhandle)
然后你在另外一个文件another_mod.py中写下：
import mod
mybar = mod.Bar()

你已经有了一个丑陋的AttributeError异常。

为什么呢？原因就像<a href="https://mail.python.org/pipermail/python-bugs-list/2009-January/069209.html">这里</a>说的，当解释器关闭的时候，全局变量都被置成None。所以，在上面的例子中，当__del__被调用的时候，foo已经被置成None了。

一个解决的方法是使用atexit.register()。这样，当你的程序结束时（正常的结束），你之前注册的处理函数就会在解释器关闭之前被调用。

理解了这些，解决上面问题的代码就写成了这样：
import foo
import atexit

def cleanup(handle):
    foo.cleanup(handle)


class Bar(object):
    def __init__(self):
        ...
        atexit.register(cleanup, self.myhandle)

这里的实现方法给出了一个清晰而可靠的解决方案，可以在程序正常退出时调用任何需要的清理方法。显然，具体的清理方法还要取决于foo.cleanup函数对self.myhandle到底做了什么，不过，你是知道的。

总结
Python是一个强大而灵活的开发语言，它具有很多可以大大提高生产力的机制和范式。不过，就像任何的软件工具和开发语言一样，只停留在表面上的理解不仅不能利用好它的优势之处反而有时会成为绊脚石，就像那句俗语说的：一知半解最危险！

让自己能熟悉Python中的细小的关键之处，就像本文（但是不只）提到的这些，能够帮助更好的使用这门语言，同时也能避免掉进一些常见的坑中。

也许你也想看看我们的<a href="http://www.toptal.com/python#hiring-guide">Insider'sGuidetoPythonInterviewing</a>这篇文章，它可以在如何发现Python人才方面提供给你一些建议。



