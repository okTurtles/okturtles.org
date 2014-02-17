# https://gist.github.com/bfred-it/7330016
TimelineLite::addDelay = (delay, position) ->
    switch $.type position
        when 'undefined', 'null' then @set {}, {}, "+=#{delay}"
        when 'string' then @set {}, {}, "#{position}+=#{delay}"
        when 'number' then @set {}, {}, delay + position 
        else console.log "BAD POSITION TYPE for addDelay!"

# TODO: make this generic and for jumping to ids, not names.
# scrollToFAQ = (idName) ->
#     if idName and ($faq = $(".faq h3[name='#{idName}']")).length != 0
#         scrollToEl $faq

gScrollTo = (target, shouldFlashCb) ->
    if target # '' evals to false
        if typeof(target) isnt 'string'
            $t = target
        else if target.indexOf('#') is 0
            if ($t = $(target)).length is 0
                $t = $("[name='#{target.slice(1)}']")
        else if ($t = $("[name='#{target}']")).length is 0
            $t = $('#'+target)

        if $t.length is 0
            console.log "ERROR: can't find: #{target}!"
        else
            hash = '#' + ($t.attr('id') or $t.attr('name'))
            faq = $t.hasClass 'faq_question'
            console.log "scrolling to: #{hash} (faq=#{faq})"
            options =
                duration: 500
                # offset: {top:-50, left:0}
                onAfter: ->
                    window.location.hash = hash
                    
                    return if !faq and shouldFlashCb and !shouldFlashCb()

                    hTgt = if faq then $t.parent().next() else $t
                    
                    highlight = ->
                        color = $(@).css 'background-color'
                        TweenMax.to $(@), 0.5,
                            backgroundColor: "yellow"
                            onComplete: => TweenMax.to $(@), 0.5, backgroundColor: color
                    
                    if faq and hTgt.is ':hidden'
                        $t.trigger 'click', done: highlight
                    else
                        highlight.call hTgt
                        
            # scrollTo has a bug where even specifying margin:true means margin is enabled
            if faq
                console.log "ADDING MARGIN!"
                $.extend(options, {margin:true})
            
            console.log options
            $.scrollTo $t, options
            
            return false # for <a href='#blah'> links

cachedCurrentSectionTop = undefined

# sets 'cachedCurrentSectionTop'
navPillSelectedOn = 0
selectNavPill = (target, sticky) ->
    if ($t = $("nav a[href='##{target}']")).length > 0
        $li = $t.parent('li')
        if (Date.now() - navPillSelectedOn) > 300
            navPillSelectedOn = Date.now() if sticky
            $li.addClass('active').siblings().removeClass 'active'
            cachedCurrentSectionTop = $('#'+target).offset().top
        $li

makeSectionObj = (el) -> {el: el, top: $(el).offset().top}

closestSection = ->
    pos = $(window).scrollTop() + ($(window).height() / 2)
    offsets = $('section.nav').map(-> makeSectionObj @).get().sort (a,b)-> a.top - b.top
    for o in offsets
        if pos >= o.top then closest = o else break
    closest ? offsets[0]

$ ->
    # do this before we wrap the FAQ with anchors
    $("a[href^='#']").click ->
        if (target = $(@).attr('href').slice(1)) != ''
            gScrollTo target, -> not selectNavPill(target, true)
                

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
        
    # nav        
    navBoundary = 100
    navNeedsUpdate = do ->
        prevPos = $(window).scrollTop()
        ->
            curPos = $(window).scrollTop() 
            update = if curPos < navBoundary then prevPos > navBoundary else prevPos < navBoundary
            update and prevPos = curPos

    $(window).scroll ->
        # note that 0 position could be returned, and it has a truthy value of false
        if (pos = navNeedsUpdate()) != false
            TweenMax.to $('nav'), 0.4, {overwrite:true, autoAlpha: if pos >= navBoundary then 1 else 0}
        
        if (closest = closestSection()).top != cachedCurrentSectionTop
            $li = selectNavPill $(closest.el).attr('id') # update 'cachedCurrentSectionTop'
            liOff = ($li.offset().left + $li.outerWidth(true)) - $(window).width()
            if liOff > 0
                # we need to scroll the 'ul' to bring it inside
                TweenMax.to $li.parent(), 0.2, {marginLeft: -liOff}
            else if $li.offset().left < 0
                TweenMax.to $li.parent(), 0.2, {marginLeft: 0}

    winHash = window.location.hash.slice(1)
    gScrollTo winHash, -> not selectNavPill(winHash, true)
        # # yes, this is hackish..
        # # do it like this so that 'updateCurrentSection' doesn't override it
        # setTimeout (-> selectNavPill winHash), 200
        # # gScrollTo needs to know whether or not to highlight
        # not selectNavPill(winHash)
