---
layout: post
title: "Debug and log with logging"
description: ""
category:
tags: [Python]
---

{% include JB/setup %}
Let me try to show how to use the *module logging* in the simplest way.

Usually, there are two kinds of situation we want to use logging. First, we want to debug with a programe. Second, we want to record the running status of a program.

Here is a simple UML Class Diagram of logging.py

<img src="/images/logging.png" alt="Logging" class="img-center" />

{% highlight Python %}
#settings.py
DEBUG = 1
{% endhighlight %}

{% highlight Python %}
#__init__.py
import logging
import settings
if setting.DEBUG:
    logging.basicConfig(level=logging.DEBUG, format='%(levelname)s:%(name)s:%(message)s')
else:
    logging.basicConfig(level=logging.WARNING, format='%(levelname)s:%(name)s:%(asctime)s:%(message)s', datefmt='%m-%d %H:%M', filename='programe.log')
{% endhighlight %}

{% highlight Python %}
#test.py
import logging
log = logging.getLogger(__name__)

log.info('starting test')
log.debug('run through here')
log.warning('are you sure you want to do this?')
log.error('parse dom error')
log.critical('Oh! This should not happen')
{% endhighlight %}

For more information about logging, please refer to [Doc](https://docs.python.org/2/howto/logging.html)
