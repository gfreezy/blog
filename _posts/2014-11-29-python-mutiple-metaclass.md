---
layout: post
title: Python多继承下metaclass优先级
tagline: null
category: null
tags: []
published: true
---
在 Python 里面，class 也是一个对象，它是 type 实例化后生成的对象。我们一般用

```python
class ClassA(object):
  def method1(self):
    pass
  
  @classmethod
  def method2(cls):
    pass
```

可以定义类 `ClassA` 。而实际上 `class` 这个关键字是类似语法糖一样的东西。上面的 class 定义
等价为

```python
def method1(self):
  pass
  
@classmethod
def method2(cls):
  pass
  
attrs = {
  'method1': method1,
  'method2': method2,
}

ClassA = type('ClassA', (object,), attrs)
```

`type` 的三个参数分别表示 类的名字（`ClassA.__name__`中存储的名字), 继承的父类(可以是多个父类), 类的所有属性（类的各种方法和属性）。

以上是一个不指定 `__metaclass__` 的 class 的生成过程。但是在 ORM 的代码中，经常可以看到类似这样的写法

```python
class MetaA(type):
  def __new__(cls, name, bases, attrs):
    # some work
    new_class = xxx
    return new_class

class ClassB(object):
  __metaclass__ = MetaA
  
  def create_xxx(self):
    pass
```

在 ClassB 的属性中，比之前多了一个 `__metaclass__` 的属性。`__metaclass__` 是做什么用的呢？
我们先把这个类用 `type(name, bases, attrs)` 的方式重新写下。

```python
class MetaA(type):
  def __new__(cls, name, bases, attrs):
    # some work
    new_class = xxx
    return new_class
  
def create_xxx(self):
  pass
  
attrs = {
  'create_xxx': create_xxx,
}

ClassB = MetaA('ClassB', (object,), attrs)
```

到这里，你一定看明白了， `__metaclass__` 的属性就是替换 `type` 的。 `__metaclass__` 的默认值就是 `type`。

那如果一个类从某个指定了 `__metaclass__` 的类继承，而它自身没指定 `__metaclass__` 会怎么样呢？

```python
class ClassC(ClassB):
  pass
```

我想你一定猜到了，`ClassC` 会用 `ClassB` 的 `__metaclass__` 属性来生成自己。当一个类自己没有定义 `__metaclass__` 
的情况下，它会去父类找 `__metaclass__` ，如果父类没有，就去父类的父类找，一直到找到为止。如果所有到父类都没有
指定 `__metaclass__` ，则使用默认的 `type` 来构造类。

你一定会有一个疑问，如果父类指定了 `__metaclass__` ， 父类的父类也指定了 `__metaclass__`；或者父类继承了多个父类，
这多个父类都有自己的 `__metaclass__` ，那会发生什么情况？

对于这一点，Python 对 `__metaclass__` 有一个限制，** 就是一个对象的 `__metaclass__` 和它所有父类的所有 `__metaclass__` 
必须有继承关系或者是同一个 ** ([参考Python源码](https://hg.python.org/cpython/file/0f837071fd97/Objects/typeobject.c#l1930)) 。
在这个基础上，真实使用的 `__metaclass__` 是继承链的最底端（既是最子类的那个 metaclass)。
