--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:9ec82ca137a3bb2453ec875ffbb9696f:c2cad6935f5d2129cad28434c467b5c3:8cbb69f5fe539f93276cc74112b583af$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- a_1
            x=0,
            y=0,
            width=360,
            height=172,

        },
        {
            -- a_2
            x=0,
            y=172,
            width=333,
            height=172,

        },
        {
            -- a_3
            x=0,
            y=344,
            width=330,
            height=167,

        },
         {
            -- a_5
            x=330,
            y=172,
            width=330,
            height=172,

        },
        {
            -- a_6
            x=330,
            y=344,
            width=330,
            height=160,

        },
        
        {
            -- cow_0
            x=2,
            y=2,
            width=660,
            height=504,

            sourceX = 0,
            sourceY = 25,
            sourceWidth = 500,
            sourceHeight = 500
        },
        {
            -- cow_1
            x=660,
            y=0,
            width=685,
            height=504,
            sourceX = 0,
            sourceY = 25,
            sourceWidth = 500,
            sourceHeight = 500
        },
        
		
		{
            -- a_1
            x=679,
            y=525,
            width=360,
            height=172,

        },
        {
            -- a_2
            x=679,
            y=697,
            width=333,
            height=172,

        },
        {
            -- a_3
            x=679,
            y=869,
            width=330,
            height=167,

        },

        {
            -- a_5
            x=1009,
            y=697,
            width=330,
            height=172,

        },
        {
            -- a_6
            x=1009,
            y=869,
            width=330,
            height=160,

        },

        
    },
    
    sheetContentWidth = 2074,
    sheetContentHeight = 1028
}

SheetInfo.frameIndex =
{

    ["a_1"] = 1,
    ["a_2"] = 2,
    ["a_3"] = 3,
	["a_4"] = 4,
    ["a_5"] = 5,
    ["goat_0"] = 6,
    ["goat_1"] = 7,
    ["goat_2"] = 8,
	["w_1"] = 9,
    ["w_2"] = 10,
    ["w_3"] = 11,
	["w_4"] = 12,
    ["w_5"] = 13,
   
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
