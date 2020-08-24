--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:7f9f81aa3be2a8a159f48a54c96aa635:570394db4649564838c7c1b1c716883d:9018e87063fa6b6f4b7e287b34f78594$
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
            -- chicken
            x=0,
            y=0,
            width=257,
            height=196

        },
        {
            -- cow
            x=257,
            y=0,
            width=257,
            height=196

        },
        {
            -- dog
            x=514,
            y=0,
            width=257,
            height=196

        },
        {
            -- elephant
            x=771,
            y=0,
            width=257,
            height=196

        },
        {
            -- hen
            x=1028,
            y=0,
            width=257,
            height=196

        },
        {
            -- horse
            x=1285,
            y=0,
            width=257,
            height=196

        },
        {
            -- ladybug
            x=1542,
            y=0,
            width=257,
            height=196

        },
        {
            -- pig
            x=1799,
            y=0,
            width=257,
            height=196

        },
        {
            -- seal
            x=2056,
            y=0,
            width=257,
            height=196

        },
        {
            -- sheep
            x=2313,
            y=0,
            width=257,
            height=196

        },
		
    },
    
    sheetContentWidth = 2570,
    sheetContentHeight = 196
}

SheetInfo.frameIndex =
{

    ["rubbit"] = 1	,
    ["cat"] = 2,
	["river_horse"] = 3,
    ["lion"] = 4,
    ["zebra"] = 5,
    ["sheep"] = 6,
    ["monkey"] = 7,
    ["elephant"] = 8,
    ["uni_bane"] = 9,
    ["koko"] = 10,
	["penquin"] = 1	,
    ["crocodile"] = 2,
	["horse"] = 3,
    ["pig"] = 4,
    ["fox"] = 5,
    ["bird"] = 6,
    ["camel"] = 7,
    ["banda"] = 8,
    ["ladybug"] = 9,
    ["goat"] = 10,
	
}

SheetInfo.frameName =
{
    name = {
    "rubbit",
    "cat",
    "river_horse",
    "lion",
    "zebra",
    "sheep",
    "monkey",
    "elephant",
    "uni_bane",
    "koko",
	"penquin",
	"crocodile",
	"horse",
	"pig",
	"fox",
	"bird",
	"camel",
	"banda",
	"ladybug",
	"goat",
	
    }
}

function SheetInfo:getFrameName()
    return self.frameName;
end



function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
