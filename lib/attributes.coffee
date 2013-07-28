
module.exports = parse_many = ( objects ) ->
  result = {}
  parse_one o, result for o in objects
  result

parse_one = ( obj, result ) ->
  for k, v of obj
    # 1. check for prefixed style
    if ( r = parse_as_prefixed k )?
      result[r] = v
    # 2. check for expanded style ( attr$name, css$style )
    else if ( k.indexOf('$') > 0 )
      result[k] = v
    else
      # 3. check for nested objects
      if typeof v is 'object'
        result[k + '$' + k2] = v2 for k2, v2 of v 
      else
        # 4. plain attribute ( no prefix, no nested object )
        # we apply some semantic heuristics
        # it may be an event or a style
        # TODO: styles are not supported yet
        #       we need an HTML tag + attribute lookup table
        if k.indexOf('on') is 0
          result['event$' + k[2..]] = v
        else
          result['attr$'+k] = v

prefixes =
  '$': 'css'
  '!': 'event'
  '_': 'x'
  '.': 'class'

parse_as_prefixed = (k) ->
  prefix = k[0]
  rest = k[1..]
  if ( p = prefixes[prefix] )
    p + '$' + rest
  else
    undefined