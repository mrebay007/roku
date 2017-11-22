' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 

sub init()
    'initialize node variables
    m.gridPoster = m.top.findNode("gridPoster")
    m.descriptionZone = m.top.findNode("descriptionZone")
    m.titleLabel = m.top.findNode("titleLabel")
    m.descriptionLabel = m.top.findNode("descriptionLabel")

    'set additional onChange handlers
    m.gridPoster.observeField("loadStatus", "OnLoadStatusChange")
    
    'setting font for labels from UIConstants
    m.UIConstants = m.top.createChild("UIConstants")
    
    m.titleLabel.font = m.UIConstants.root.Fonts.text.node
    m.titleLabel.color = m.UIConstants.root.Fonts.text.color
    m.descriptionLabel.font = m.UIConstants.root.Fonts.text.node
    m.descriptionLabel.color = m.UIConstants.root.Fonts.text.color
end sub


sub OnLoadStatusChange()
    if m.gridPoster.loadStatus = "failed"
        'force reloading poster if it fails
        prevUri = m.gridPoster.uri
        m.gridPoster.uri = ""
        m.gridPoster.uri = prevUri
    end if
end sub


sub OnItemContentChange()
    itemContent = m.top.itemContent
    m.gridPoster.uri = itemContent.HDPosterUrl
    m.titleLabel.text = itemContent.title
    m.descriptionLabel.text = itemContent.description
end sub


sub OnWidthChange()
    m.gridPoster.width = m.top.width
    m.descriptionZone.width = m.top.width+2
    m.titleLabel.width = m.descriptionZone.width*0.95
    m.descriptionLabel.width = m.descriptionZone.width*0.95
end sub

'Callback that evalutes heights and vertical transition
'for poster, description zone rectangle, and labels 
sub OnHeightChange()
    'that value contrlos overlaping  description zone over poster
    isOverlapping = false
    if isOverlapping then
        m.gridPoster.height = m.top.height
        m.descriptionZone.translation = [0, m.gridPoster.height*(1-0.38)]
    else
        m.gridPoster.height = m.top.height*(1-0.38)
        m.descriptionZone.translation = [0, m.gridPoster.height] 
    end if    
    m.descriptionZone.height = m.top.height*0.38+2
    
    delta = (m.descriptionZone.height - 2*m.titleLabel.font.size)/3  
    
    m.titleLabel.height = m.titleLabel.font.size*1.2
    m.titleLabel.translation = [m.UIConstants.root.LayoutItemGroup.translation[0], delta]
      
    m.descriptionLabel.height = m.descriptionLabel.font.size*1.2
    m.descriptionLabel.translation = [m.UIConstants.root.LayoutItemGroup.translation[0], 2*(delta + m.descriptionLabel.height/2.5)]
end sub