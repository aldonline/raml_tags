assert = require 'assert'
chai = require 'chai'
should = chai.should()

X = require '../lib'


keys = (o) -> ( k for k, v of o )

compare = (o1, o2) ->
  k1 = keys o1
  k2 = keys o2
  assert.equal k1.length, k2.length, "Objects don't have the same keys: #{k1} -> #{k2}"
  o1[k].should.equal o2[k] for k in k1

C = (o) -> compare X(o.i), o.o

describe 'RAML Tag Parser', ->

  it 'should parse prefixed names', ->
  
    C
      i: [ 'div#hello', $color:'red' ]
      o:
        attr$id:    'hello'
        css$color:  'red'
        x$tag:      'div'

    C
      i: [ 'div#hello.nice', $color:'red' ]
      o:
        attr$id:    'hello'
        css$color:  'red'
        x$tag:      'div'
        class$nice:  yes

    C
      i: [ 'div#hello.nice', $color:'red', ( f = ->) ]
      o:
        attr$id:    'hello'
        css$color:  'red'
        x$tag:      'div'
        class$nice:  yes
        x$content:   f

    C
      i: [ 'div#hello.nice', $color:'red', 'Hello']
      o:
        attr$id:    'hello'
        css$color:  'red'
        x$tag:      'div'
        class$nice:  yes
        x$content:   'Hello'