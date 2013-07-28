attrs = require './attributes'
htp = require 'htmltagparser'


module.exports = parse = ( args ) ->

  args = args.concat() # operate on copy
  throw new Error 'no arguments' if args.length is 0

  # 1. tag, id, classes come first
  {id, tag, classes} = htp args.shift()
  
  # 2. optional content comes last. can be anything but an object
  content = args.pop() if typeof args[-1..][0] isnt 'object'

  props = {}
  # add tag, id, classes and content to the props hashmap
  props.attr$id        = id if id?
  props.x$tag          = tag if tag?
  props.x$content      = content if content?
  props['class$' + c ] = yes for c in classes if classes?

  # 3. the rest are property maps. the attribute parser should handle them
  attrs args.concat props