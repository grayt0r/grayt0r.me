class ScrollSpy
  
  # Options
  @defaultOptions:
    container: window
    min: 100
    max: 200
    mode: 'vertical'
  
  constructor: (options) ->
    @options = $.extend ScrollSpy.defaultOptions, options
    @container = $(@options.container)
    @enters = @leaves = 0
    @inside = false
    @scrollMethod = 'scroll' + (if @options.mode is 'vertical' then 'Top' else 'Left')
    
    @listener = (e) =>
      #position = @container.getScroll()
      #xy = position[@options.mode == 'vertical' ? 'y' : 'x']
      position = @container[@scrollMethod]()
      
      if position >= @options.min and (@options.max is 0 or position <= @options.max)
        if not @inside
          @inside = true
          @enters++
          @container.trigger 'enter', [position, @enters]
        
        @container.trigger 'tick', [position, @inside, @enters, @leaves]
      
      else if @inside
        @inside = false
        @leaves++
        @container.trigger 'leave', [position, @leaves]
      
      @container.trigger 'scroll2', [position, @inside, @enters, @leaves]
    
    @addListener()
  
  start: ->
    @container.on 'scroll', @listener
  
  stop: ->
    @container.off 'scroll', @listener
  
  addListener: ->
    @start()

jQuery.fn.scrollSpy = ->
  new ScrollSpy
    container: this

$(window).scrollSpy()

$(window).on 'scroll2', (ev, p, i, e, l) ->
  console.log ev, p, i, e, l