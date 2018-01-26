###*
# Feed class
###

Feed = do ->
  `var Feed`

  Feed = (options) ->
    # URL for RSS
    @url = ''
    #Mask element
    @maskEl = '#mask'
    #Error message element
    @errorEl = '#error-message'
    #List container
    @listEl = '#feed-list'
    if options
      $.extend this, options
    @addClickHandler()
    return

  ###*
  # Fetch RSS and display the contents of it
  ###

  Feed::load = ->
    self = this
    $(@maskEl).show()
    $(@errorEl).text ''
    $.ajax
      url: @url
      dataType: 'text'
      crossDomain: true
      success: (data) ->
        data = $.parseXML(data.trim())
        $(self.listEl).empty()
        # Display RSS contents
        $rss = $(data)
        $('h2').text $rss.find('channel > title').text()
        # Add
        $rss.find('item').each ->
          item = this
          $(self.listEl).append self.createListElement(item)
          return
        self.favorite.applyAll()
        # Add
        return
      error: ->
        $(errorEl).text 'Failed to load RSS.'
        return
      complete: ->
        $(self.maskEl).hide()
        return
    return

  Feed::addClickHandler = ->
    $(@listEl).on 'click', 'li', ->
      url = $(this).data('link')
      if /^http/.test(url)
        ref = window.open(url, '_blank', 'location=yes')
        ref.addEventListener 'exit', ->
      else
        alert 'Invalid URL.'
      return
    return

  ###*
  # Create list element
  # @param Array item
  # @returns DOMElement
  ###

  Feed::createListElement = (item) ->
    $item = $(item)
    link = @escape($item.find('link').text())
    title = @escape($item.find('title').text())
    description = @escape(strip_tags($item.find('description').text()))
    date = new Date($item.find('pubDate').text())
    '<li class="feed-item" data-link="' + link + '">' + '<time>' + date.getFullYear() + '/' + date.getMonth() + 1 + '/' + date.getDate() + '</time>' + '<h2>' + title + '</h2><p>' + description + '</p><i class="star fa fa-star-o fa-2x"></i></li>'

  Feed::escape = (string) ->
    htmlspecialchars string, 'ENT_QUOTES'

  Feed

###*
# htmlspecialchars
#
# @see http://phpjs.org/
###

htmlspecialchars = (string, quote_style, charset, double_encode) ->
  # http://kevin.vanzonneveld.net
  # +   original by: Mirek Slugen
  # +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  # +   bugfixed by: Nathan
  # +   bugfixed by: Arno
  # +    revised by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  # +    bugfixed by: Brett Zamir (http://brett-zamir.me)
  # +      input by: Ratheous
  # +      input by: Mailfaker (http://www.weedem.fr/)
  # +      reimplemented by: Brett Zamir (http://brett-zamir.me)
  # +      input by: felix
  # +    bugfixed by: Brett Zamir (http://brett-zamir.me)
  # %        note 1: charset argument not supported
  # *     example 1: htmlspecialchars("<a href='test'>Test</a>", 'ENT_QUOTES');
  # *     returns 1: '&lt;a href=&#039;test&#039;&gt;Test&lt;/a&gt;'
  # *     example 2: htmlspecialchars("ab\"c'd", ['ENT_NOQUOTES', 'ENT_QUOTES']);
  # *     returns 2: 'ab"c&#039;d'
  # *     example 3: htmlspecialchars("my "&entity;" is still here", null, null, false);
  # *     returns 3: 'my &quot;&entity;&quot; is still here'
  optTemp = 0
  i = 0
  noquotes = false
  if typeof quote_style == 'undefined' or quote_style == null
    quote_style = 2
  string = string.toString()
  if double_encode != false
    # Put this first to avoid double-encoding
    string = string.replace(/&/g, '&amp;')
  string = string.replace(/</g, '&lt;').replace(/>/g, '&gt;')
  OPTS = 
    'ENT_NOQUOTES': 0
    'ENT_HTML_QUOTE_SINGLE': 1
    'ENT_HTML_QUOTE_DOUBLE': 2
    'ENT_COMPAT': 2
    'ENT_QUOTES': 3
    'ENT_IGNORE': 4
  if quote_style == 0
    noquotes = true
  if typeof quote_style != 'number'
    # Allow for a single string or an array of string flags
    quote_style = [].concat(quote_style)
    i = 0
    while i < quote_style.length
      # Resolve string input to bitwise e.g. 'ENT_IGNORE' becomes 4
      if OPTS[quote_style[i]] == 0
        noquotes = true
      else if OPTS[quote_style[i]]
        optTemp = optTemp | OPTS[quote_style[i]]
      i++
    quote_style = optTemp
  if quote_style & OPTS.ENT_HTML_QUOTE_SINGLE
    string = string.replace(/'/g, '&#039;')
  if !noquotes
    string = string.replace(/"/g, '&quot;')
  string

###*
# strip_tags
#
# @see http://phpjs.org/
###

strip_tags = (input, allowed) ->
  # http://kevin.vanzonneveld.net
  # +   original by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  # +   improved by: Luke Godfrey
  # +      input by: Pul
  # +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  # +   bugfixed by: Onno Marsman
  # +      input by: Alex
  # +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  # +      input by: Marc Palau
  # +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  # +      input by: Brett Zamir (http://brett-zamir.me)
  # +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  # +   bugfixed by: Eric Nagel
  # +      input by: Bobby Drake
  # +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  # +   bugfixed by: Tomasz Wesolowski
  # +      input by: Evertjan Garretsen
  # +    revised by: Rafał Kukawski (http://blog.kukawski.pl/)
  # *     example 1: strip_tags('<p>Kevin</p> <br /><b>van</b> <i>Zonneveld</i>', '<i><b>');
  # *     returns 1: 'Kevin <b>van</b> <i>Zonneveld</i>'
  # *     example 2: strip_tags('<p>Kevin <img src="someimage.png" onmouseover="someFunction()">van <i>Zonneveld</i></p>', '<p>');
  # *     returns 2: '<p>Kevin van Zonneveld</p>'
  # *     example 3: strip_tags("<a href='http://kevin.vanzonneveld.net'>Kevin van Zonneveld</a>", "<a>");
  # *     returns 3: '<a href='http://kevin.vanzonneveld.net'>Kevin van Zonneveld</a>'
  # *     example 4: strip_tags('1 < 5 5 > 1');
  # *     returns 4: '1 < 5 5 > 1'
  # *     example 5: strip_tags('1 <br/> 1');
  # *     returns 5: '1  1'
  # *     example 6: strip_tags('1 <br/> 1', '<br>');
  # *     returns 6: '1  1'
  # *     example 7: strip_tags('1 <br/> 1', '<br><br/>');
  # *     returns 7: '1 <br/> 1'
  allowed = (((allowed or '') + '').toLowerCase().match(/<[a-z][a-z0-9]*>/g) or []).join('')
  # making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
  tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi
  commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi
  input.replace(commentsAndPhpTags, '').replace tags, ($0, $1) ->
    if allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 then $0 else ''

# ---
# generated by js2coffee 2.2.0