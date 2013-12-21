# https://gist.github.com/bfred-it/7330016
TimelineLite::addDelay = (delay, position) ->
    switch $.type position
        when 'undefined', 'null' then @set {}, {}, "+=#{delay}"
        when 'string' then @set {}, {}, "#{position}+=#{delay}"
        when 'number' then @set {}, {}, delay + position 
        else console.log "BAD POSITION TYPE for addDelay!"

$ ->
    $('body').css('display', 'none').fadeIn(1200)
    $(".faq h3").next().hide()
    $(".faq h3").wrap('<a href="#"></a>').click (a, obj)->
        $(this).parent().next().slideToggle(duration: "fast", complete: obj?.done ? ->)
        return false
    $service = $('#service')
    $subtitle = $('#subtitle')
    $tagline = $('#serviceTagline')
    $firstImg = $('.slideshow img').first()
    $firstTxt = $('.slideshow span').first()

    debug = undefined  # set to true to see how this crap works
    TIME_PER_ANIMATION   = 1
    TIME_FOR_IMG_DISPLAY = 5
    STAGGER_AMOUNT       = TIME_PER_ANIMATION + TIME_FOR_IMG_DISPLAY
    SLIDE_PADDING        = 100
    SLIDE_TXT_PADDING    = $firstTxt.outerHeight(true)
    TXT_MARGIN           = ($tagline.outerHeight(true) - $tagline.outerHeight(false))/2
    SLIDE_TXT_CENTER     = $subtitle.outerHeight(true) + TXT_MARGIN
    SLIDE_TXT_LEFT       = $service.offset().left
    IMG_WIDTH            = $firstImg.width()

    # really tiny window mode
    if $firstImg.parent().offset().left == $subtitle.offset().left
        SLIDE_IMG_CENTER = Math.max($subtitle.width()/2-IMG_WIDTH/2, 0)
    else
        SLIDE_IMG_CENTER = 0

    tl = new TimelineMax repeat: -1, paused: true

    fadeIn  = (elements, endLocs, t) ->
        # array-ify them if they're not already arrays
        [elements, endLocs] = [[elements],[endLocs]] if not elements.length?

        for $el, idx in elements
            if $el.css('visibility') == 'hidden'
                console.log "#{t}: #{new Date()} fadeIn : #{$el.attr('src')}" if debug?
                TweenMax.to $el, TIME_PER_ANIMATION, $.extend({}, endLocs[idx], {autoAlpha: 1})
    fadeOut = (elements, endLocs, t) ->
        # array-ify them if they're not already arrays
        [elements, endLocs] = [[elements],[endLocs]] if not elements.length?
        
        for _$el, _idx in elements
            do -> # a bit of insanity to avoid overwriting these vars: $el, idx, resetLoc
                [$el, idx] = [_$el, _idx]
                if $el.css('visibility') != 'hidden'
                        console.log "#{t}: #{new Date()} fadeOut: #{$el.attr('src')}" if debug?
                        resetLoc = $.extend {}, endLocs[idx] # copy the endLocs
                        dir = Object.keys(resetLoc)[0]
                        resetLoc[dir] = endLocs[idx][dir] + 2 * ($el.position()[dir] - endLocs[idx][dir])
                        TweenMax.to $el, TIME_PER_ANIMATION, $.extend({}, endLocs[idx], {
                            autoAlpha : 0
                            onComplete: -> $el.css(resetLoc) # reset to start
                        })
                else if debug?
                    console.log "#{t}: #{new Date()} fadeOut: #{$el.attr('src')} SKIPPING CAUSE: #{$el.css('visibility')}"


    $slides = $('.slideshow > div')

    # manually iterate over all of the images instead of using the staggerFromTo/staggerTo
    # functions, because this gives me the fine control over the timeline that i need to make
    # the whole thing seamlessly loop around.
    $slides.each (idx, el) ->
        [$img, $text] = objs = [$(el).find('img'), $(el).find('span')]
        [pt1, pt2] = [idx * STAGGER_AMOUNT,  STAGGER_AMOUNT + (idx * STAGGER_AMOUNT)]

        console.log "#{idx}: [pt1=#{pt1}, pt2=#{pt2}]" if debug?

        # set initial location
        $img.css left: startImgLoc = (IMG_WIDTH + SLIDE_PADDING)
        # very hackish positioning of $text. We position top based on css (cause greensock uses that)
        # and absolute offset, since we're not animation and i can't figure out how to get the css-value,
        # we position using offset. this is junk, and needs to e fixed at somepoint... but if it works... it works. :)
        $text.css {top: startTxtLoc = (SLIDE_TXT_CENTER + SLIDE_TXT_PADDING)}
        $text.offset left: SLIDE_TXT_LEFT
        endImgLoc = -startImgLoc
        endTxtLoc = startTxtLoc - 2 * SLIDE_TXT_PADDING

        tl.addCallback fadeIn, pt1, [objs, [{left: SLIDE_IMG_CENTER}, {top: SLIDE_TXT_CENTER}], pt1] 

        # for a seamless transition to the start, we have the last element fadeOut at the start (if visible)
        if idx + 1 == $slides.length
            tl.addCallback fadeOut, 0, [objs, [{left: endImgLoc}, {top: endTxtLoc}], 0]
            tl.addDelay TIME_FOR_IMG_DISPLAY, pt1
        else
            tl.addCallback fadeOut, pt2, [objs, [{left: endImgLoc}, {top: endTxtLoc}], pt2] 
        
    tl.play()

    fragment = window.location.hash.slice(1)
    $.scrollTo(0)
    if fragment and ($faq = $(".faq h3[name='#{fragment}']")).length != 0
        # console.log "scrolling to: #{fragment}"
        $.scrollTo $faq,
            duration: 500
            # offset: {top:-50, left:0}
            margin: true
            onAfter: ->
                $faq.trigger 'click', done: ->
                    TweenMax.to $(@), 0.5,
                        backgroundColor: "yellow"
                        onComplete: => TweenMax.to $(@), 0.5, backgroundColor: "inherit"
        
