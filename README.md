# Expando

[![Gem Version](https://img.shields.io/gem/v/expando.svg)][ruby-gems]
[![Linux Build Status](https://img.shields.io/travis/expando-lang/expando/master.svg?label=Linux%20build)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/expando-lang/expando.svg)][codeclimate]
[![Dependency Status](https://img.shields.io/gemnasium/expando-lang/expando.svg)][gemnasium]
[![Security](https://hakiri.io/github/expando-lang/expando/master.svg)][hakiri]

[ruby-gems]: https://rubygems.org/gems/expando
[travis]: https://travis-ci.org/expando-lang/expando
[codeclimate]: https://codeclimate.com/github/expando-lang/expando
[gemnasium]: https://gemnasium.com/expando-lang/expando
[hakiri]: https://hakiri.io/github/expando-lang/expando/master

Expando is a translation language for easily defining user utterance examples when building conversational interfaces. The following line of Expando:

```text
(is it possible to|can I|how do I) return (something|an item)
```

...would be expanded by producing the Cartesian product of the phrases in parentheses that are separated by pipes:

```text
is it possible to return something
is it possible to return an item
can I return something
can I return an item
how do I return something
how do I return an item
```

This encoding makes it much easier to manage multiple user utterance examples when building conversational interfaces on platforms like [Api.ai](http://api.ai). In fact, it will handle uploading expanded intents and entities to Api.ai for you. This makes it easy to collaborate on constructing a conversational intelligence.

## How can I use it?

Expando isn't *quite* ready for public consumption, but should be within a month or so as we flesh out the spec. Watch this space, and all that. If you're really interested, you can always [drop us a line](http://voxable.io/hire-us) and we'll help you out.


