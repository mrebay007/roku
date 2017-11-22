' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 

sub init()
    m.initDetailsTrans = true
    m.initGridTran = true
    m.IsInitVideoSize = false
   'animation
    m.scaleAnimation     = m.top.findNode("scaleAnimation")
    'field interpolators
    m.ItemDetailsTranslation     = m.top.findNode("ItemDetailsTranslation")
    m.GridTranslation            = m.top.findNode("GridTranslation")
    m.VideoSizeInterp            = m.top.findNode("VideoSizeInterp")
    
    'Creating nodes configurring it and attaching to top interfaces    
    OnGridChange()
    OnItemDetailsChange()
    OnLiveVideoChange()
    OnDetailsScreenChange()
    
    m.fadingBackground = m.top.findNode("fadingBackground")
    m.background = m.top.findNode("background")
    'UIConstants    
    m.UIConstants = m.top.createChild("UIConstants")
    m.fadingBackground.width  = m.UIConstants.root.background.size[0]
    m.fadingBackground.height = m.UIConstants.root.background.size[1]
    
    m.top.Grid.ItemSize = m.UIConstants.root.Grid.ItemSize
    m.top.Grid.NumRows = m.UIConstants.root.Grid.NumRows
    m.top.Grid.RowSpacings = m.UIConstants.root.Grid.RowSpacings
    m.top.Grid.RowItemSize = m.UIConstants.root.Grid.RowItemSize
    m.top.Grid.RowItemSpacing = m.UIConstants.root.Grid.RowItemSpacing
    
    m.top.LiveVideo.Size = m.UIConstants.root.LiveVideo.size
end sub

'----Initiliaztion of childrens----
sub OnGridChange()
    if m.top.Grid = invalid then
        m.top.Grid = m.top.createChild("RowList")
        m.top.Grid.id = "Grid"
        m.top.Grid.itemComponentName = "GridItemComponent"
    else
        m.top.replaceChild(m.top.Grid, 0)        
    end if
        
    m.GridTranslation.fieldToInterp  = m.top.Grid.id + ".translation"
    
    m.top.Grid.observeField("rowItemFocused", "OnFocusChange")
    m.top.Grid.observeField("rowItemSelected", "OnItemSelected")
end sub

sub OnItemDetailsChange()
    if m.top.ItemDetails = invalid then
        m.top.ItemDetails = m.top.createChild("ItemDetails")
        m.top.ItemDetails.id = "ItemDetails"
    else
        m.top.replaceChild(m.top.ItemDetails, 1)    
    end if
    
    m.ItemDetailsTranslation.fieldToInterp  = m.top.ItemDetails.id + ".translation"    
end sub

sub OnLiveVideoChange()
    if m.top.liveVideo = invalid then
        m.top.liveVideo = m.top.createChild("LiveVideo")
        m.top.liveVideo.id = "liveVideo"
    else
        m.top.replaceChild(m.top.liveVideo, 2)
    end if    
    
    m.VideoSizeInterp.fieldToInterp  = m.top.liveVideo.id + ".size"
    m.top.liveVideo.observeField("isFocused", "OnFocusChange")
end sub

sub OnDetailsScreenChange()
    if m.top.DetailsScreen = invalid then
        m.top.DetailsScreen = m.top.createChild("DetailsScreen")
        m.top.DetailsScreen.id = "DetailsScreen"
    else
        m.top.replaceChild(m.top.DetailsScreen, 3)
    end if   
    
    m.top.DetailsScreen.observeField("show", "OnDetailsScreenShowChange")
end sub
'----------------------------------

'------------callbacks-------------
sub OnUIParamsChange()
    'broadcating offset to nodes
    m.top.liveVideo.videotranslation = m.top.offset
    m.top.liveVideo.offset = m.top.offset
    m.top.DetailsScreen.offset = m.top.offset
    
    'remembering initial size of video
    if not m.IsInitVideoSize then
        m.IsInitVideoSize = m.top.offset[0] <> 0 and m.top.offset[1] <> 0 and m.top.liveGain <> 0           
        m.StartLiveVideoSize = [m.top.LiveVideo.Size[0], m.top.LiveVideo.Size[1]]
        m.EndLiveVideoSize   = [m.top.LiveVideo.Size[0] * m.top.LiveGain, m.top.LiveVideo.Size[1] * m.top.LiveGain]
        if m.top.isVideoFocused then 
            m.top.LiveVideo.Size = m.StartLiveVideoSize
        else
            m.top.LiveVideo.Size = m.EndLiveVideoSize
        end if    
    end if    
    
    'OnUIParamsChange triggers many times from different values and at first there are many uninitialized values
    'so we need many chacking on valid of variable
    if m.IsInitVideoSize then
        'livevideo ui parameters configurring
        m.VideoSizeInterp.KeyValue = [m.StartLiveVideoSize, m.EndLiveVideoSize]
         
        'description ui parameters configurring
        m.descSizes = m.top.ItemDetails.boundingRect()  
        m.StartDescTranslation = [1.47 * m.top.offset[0] + m.StartLiveVideoSize[0], m.top.offset[1] + (m.StartLiveVideoSize[1]-m.descSizes.height)/2]
        
        'calculate values for two types of animation
        deltaY = m.top.offset[1] + (m.EndLiveVideoSize[1] - m.descSizes.height)/2
        if m.top.descAllign = "left" then 
            m.EndDescTranslation = [1.47 * m.top.offset[0] + m.EndLiveVideoSize[0] , deltaY]
        else if m.top.descAllign = "center" then
            m.EndDescTranslation = [m.StartDescTranslation[0], deltaY]
        else
            m.EndDescTranslation = [1.47 * m.top.offset[0] + m.EndLiveVideoSize[0] , deltaY]
        end if
        
        m.ItemDetailsTranslation.KeyValue = [m.StartDescTranslation, m.EndDescTranslation]
        
        if m.initdetailstrans then
            m.initdetailstrans = m.top.offset[0] = 0 and m.top.offset[0] = 0
            if m.top.isVideoFocused then 
                m.top.ItemDetails.translation = m.StartDescTranslation
            else     
                m.top.ItemDetails.translation = m.EndDescTranslation
            end if    
        end if
        
        
        'grid ui parameters configurring
        m.StartGridTranslation = [m.top.offset[0], 1.925 * m.top.offset[1] + m.StartLiveVideoSize[1]]
        m.EndGridTranslation   = [m.top.offset[0], 1.925 * m.top.offset[1] + m.EndLiveVideoSize[1]]
        
        if m.initgridtran then
            m.initgridtran = m.top.offset[0] = 0 and m.top.offset[0] = 0   
            if m.top.isVideoFocused then
                m.top.Grid.translation = m.StartGridTranslation 
            else
                m.top.Grid.translation = m.EndGridTranslation
            end if    
        end if    
        m.GridTranslation.KeyValue = [m.StartGridTranslation, m.EndGridTranslation]
        
        if m.top.GridItemNum <> invalid and m.top.Grid.RowItemSize[0] <> invalid then    
            m.top.Grid.ItemSize = [m.top.GridItemNum * (m.top.Grid.RowItemSize[0][0] + m.top.Grid.RowItemSpacing[0][0]), m.top.Grid.RowItemSize[0][1]]
        end if
        
        if m.top.isVideoFocused then
            m.GridTranslation.keyValue = swap(m.GridTranslation.keyValue)
            m.VideoSizeInterp.keyValue = swap(m.VideoSizeInterp.keyValue)
            m.ItemDetailsTranslation.keyValue = swap(m.ItemDetailsTranslation.keyValue)
        end if
        
    end if    
    m.top.livevideo.setfocus(true)
end sub

function OnFocusChange()
    'update itemDetails content and
    'fading background picture on focus change
    If m.top.Grid.hasFocus() Then
        rowItemFocused = m.top.Grid.rowItemFocused
        if rowItemFocused[0] <> invalid AND rowItemFocused[1] <> invalid AND rowItemFocused[0] > 0 AND rowItemFocused[1] > 0
            focusedItemContent = m.top.Grid.content.getChild(rowItemFocused[0]).getChild(rowItemFocused[1])
            m.top.ItemDetails.content = focusedItemContent
            m.fadingBackground.uri = focusedItemContent.hdBackgroundImageUrl
        end if
    Else If m.top.liveVideo.hasFocus() Then
        m.top.itemDetails.content = m.top.liveContent
        m.fadingBackground.uri = m.top.liveContent.hdBackgroundImageUrl
    End If
       
End Function

'handle item selection event on grid
sub OnItemSelected()
    rowItemSelected             = m.top.Grid.rowItemSelected
    if rowItemSelected <> invalid AND rowItemSelected[0] <> invalid AND rowItemSelected[1] <> invalid
        ItemContent                 = m.top.Grid.content.getChild(rowItemSelected[0]).getChild(rowItemSelected[1])
        m.top.DetailsScreen.content = ItemContent
        m.top.DetailsScreen.show    = true'trigs OnDetailsScreenShowChange()
    end if   
end sub


sub OnDetailsScreenShowChange()
    videoState = m.top.liveVideo.Video.state
    if videoState = "playing" or videoState = "buffering" and m.top.DetailsScreen.show  then
        m.top.liveVideo.Video.control = "pause"
    else if videoState = "paused" or videoState = "stopped" and not m.top.DetailsScreen.show then
        m.top.liveVideo.Video.control = "resume"
    end if 
     
    m.top.Grid.visible = not m.top.DetailsScreen.show
    m.top.ItemDetails.visible = not m.top.DetailsScreen.show
    m.top.liveVideo.visible = not m.top.DetailsScreen.show
    if not m.top.DetailsScreen.show then
        m.top.Grid.setFocus(true)
    end if
end sub


sub onLiveContentChange()
    if m.top.liveVideo.hasFocus()
        m.top.itemDetails.content = m.top.liveContent
    end if
    m.top.liveVideo.content = m.top.liveContent
end sub

'handle animation between grid and LiveVideo focus changing 
sub OnNodeFocuseChange()
    OnUIParamsChange()
    OnItemDetailsExpand(not m.top.isVideoFocused)
    if m.top.isVideoFocused then
        m.top.liveVideo.setFocus(true)
    else
        m.top.Grid.setFocus(true)
    end if
    m.scaleAnimation.control = "start"  
end sub

'set values from UIConstants for labels depending on state: is it expanded or reduced 
sub OnItemDetailsExpand(isExpanded as boolean)
    if isExpanded then
        m.top.itemDetails.title.width          = m.UIConstants.root.ItemDetails.widthExp
        m.top.itemDetails.ReleaseDate.width    = m.UIConstants.root.ItemDetails.widthExp
        m.top.itemDetails.description.width    = m.UIConstants.root.ItemDetails.widthExp
        m.top.itemDetails.description.height   = m.UIConstants.root.ItemDetails.heightExp
    else
        m.top.itemDetails.title.width        = m.UIConstants.root.ItemDetails.width
        m.top.itemDetails.ReleaseDate.width  = m.UIConstants.root.ItemDetails.width
        m.top.itemDetails.description.width  = m.UIConstants.root.ItemDetails.width
        m.top.itemDetails.description.height = m.UIConstants.root.ItemDetails.height
    end if
end sub
'----------------------------------

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if m.scaleAnimation.state<>"stopped" then
        return true
    end if
    if press then
        if key = "up" then
            if m.top.Grid.rowItemFocused[0] = 0 then
                m.top.isVideoFocused = true
                handled = true
            end if
        else if key = "down" or key="right" or key="left" then
            m.top.isVideoFocused = false
            handled = true
        else if key = "OK"
        else if key = "back"
            m.top.LiveVideo.Video.control = "stop"    
        end if
    end if
    return handled
end function


function swap(twoElemVector as object) as object 
     return [twoElemVector[1], twoElemVector[0]]
end function
