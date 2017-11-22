' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 

sub init()
    m.top.hud = m.top.findNode("hud")
    m.top.Buttons = m.top.findNode("Buttons")
    
    m.UIConstants = m.top.createChild("UIConstants")
    m.top.hud.height = m.UIConstants.root.hud.height
    
    m.top.Buttons.font = m.UIConstants.root.Fonts.Label.node
    m.top.Buttons.focusedFont = m.UIConstants.root.Fonts.FocusedLabel.node
    m.top.Buttons.itemSize = m.UIConstants.root.LabelList.itemSize  
    Buttons_SetContent()
end sub
    
function OnKeyEvent(button as string, press as boolean) as boolean
    handled = false
    print button;"  ";press
    if press then
        if button="back" then
            m.top.show = false
            handled = true
        else if button = "left" or button = "right" then
            handled = true            
        end if
    end if
    return handled
end function    
    
sub OnOffsetChange()
    m.top.buttons.translation = m.top.offset
    m.top.Hud.offset = m.top.offset
end sub

sub OnShowChange()
    print "OnShowChange"
    if m.top.show then
        m.top.Buttons.setFocus(true)
    end if    
    m.top.hud.show = m.top.show
    m.top.buttons.visible = m.top.show
end sub

'For presentation only content for buttons
Sub Buttons_SetContent()
    
    result = [{
        title :"Watch trailer"
    },{
        title : "Rent SD $2.99"
    },{
        title : "Rent HD $3.99"
    },{
        title : "Buy SD $14.99"
    },{
        title : "Buy HD $17.99"
    },{
        title : "Cast & crew"
    },{
        title : "Rate movie"
    },{
        title : "Similar movies"
    },{
        title : "Add to Watchlist"
    },{
        title : "Follow"
    }]
    
    m.top.buttons.content = ContentList2SimpleNode(result)
End Sub

'///////////////////////////////////////////'
' Helper function convert AA to Node
Function ContentList2SimpleNode(contentList as Object, nodeType = "ContentNode" as String) as Object
    result = createObject("roSGNode",nodeType)
    if result <> invalid
        for each itemAA in contentList
            item = createObject("roSGNode", nodeType)
            item.setFields(itemAA)
            result.appendChild(item)
        end for
    end if
    return result
End Function