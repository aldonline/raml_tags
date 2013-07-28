assert = require 'assert'
chai = require 'chai'
should = chai.should()

X = require '../lib/attributes'


keys = (o) -> ( k for k, v of o )

compare = (o1, o2) ->
  k1 = keys o1
  k2 = keys o2
  assert.equal k1.length, k2.length, "Objects don't have the same keys: #{k1} -> #{k2}"
  o1[k].should.equal o2[k] for k in k1

C = (o) ->
  inputs = []
  output = null
  for own k, v of o
    if k[0] is 'i' then inputs.push v else output = v
  compare X(inputs), output

describe 'RAML Attribute Parser', ->

  it 'should parse prefixed names', ->
  
    C
      i:
        type:     'a'
        '!click': f = ->
        $color:   'red'
        '.disabled': yes
        _content: 'content'
      o:
        attr$type:      'a'
        event$click:    f
        css$color:    'red'
        class$disabled:  yes
        x$content:      'content'

  it 'should parse nested objects', ->
  
    C
      i:
        attr:
          type:     'a'
        event:
          click: f = ->
        css:
          color:   'red'
        class:
          disabled : yes
        x:
          content: 'content'
      o:
        attr$type:      'a'
        event$click:    f
        css$color:    'red'
        class$disabled:  yes
        x$content:      'content'


  it 'should parse mixed styles of keys', ->
  
    C
      i:
        attr:
          type:     'a'
        event:
          click: f = ->
        css:
          color:   'red'
        class:
          disabled : yes
        x:
          content: 'content'
        '!hover': f2 = ->
      o:
        attr$type:        'a'
        event$click:      f
        event$hover:      f2
        css$color:        'red'
        class$disabled:   yes
        x$content:        'content'

  it 'should parse multiple hashmaps', ->

    C
      i:
        attr:
          type:     'a'
      i2:
        event:
          click: f = ->
        css:
          color:   'red'
        class:
          disabled : yes
      i3:
        x:
          content: 'content'
        '!hover': f2 = ->
      o:
        attr$type:        'a'
        event$click:      f
        event$hover:      f2
        css$color:        'red'
        class$disabled:   yes
        x$content:        'content'


  it 'should identify events semantically ( on___ )', ->
    C
      i:
        onmouseover: f3 = ->
      o:
        event$mouseover:  f3

  it.skip 'should identify styles semantically', ->
    # TODO: analyze the list of possible attributes for x$tag


