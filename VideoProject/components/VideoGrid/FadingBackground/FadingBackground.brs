' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 

sub init()
    m.background = m.top.findNode("background")
    m.oldBackground = m.top.findNode("oldBackground")
    m.oldbackgroundInterpolator = m.top.findNode("oldbackgroundInterpolator")
    m.shade = m.top.findNode("shade")
    m.fadeoutAnimation = m.top.findNode("fadeoutAnimation")
    m.fadeinAnimation = m.top.findNode("fadeinAnimation")
    m.backgroundColor = m.top.findNode("backgroundColor")
    m.background.observeField("bitmapWidth", "onBackgroundLoaded")
end sub


sub onBackgroundUriChange()
    oldUrl = m.background.uri
    m.background.uri = m.top.uri
    if oldUrl <> ""
        m.oldBackground.uri = oldUrl
        m.oldbackgroundInterpolator = [m.background.opacity, 0]
        m.fadeoutAnimation.control = "start"
    end if
end sub


sub updateLayout()
    m.background.width = m.top.width
    m.oldBackground.width = m.top.width
    m.shade.width = m.top.width
    m.backgroundColor.width = m.top.width

    m.oldBackground.height = m.top.height
    m.background.height = m.top.height
    m.shade.height = m.top.height
    m.backgroundColor.height = m.top.height
end sub


sub onBackgroundLoaded()
    m.fadeinAnimation.control = "start"
end sub