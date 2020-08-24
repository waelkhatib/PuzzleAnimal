--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:acae019764afa0fe931bf2617a352e81:7b57c2262ad553b20409a4cfa5a45fe3:f37be5e0ff9244d1bf336fa81b2fc182$
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
            x=504,
            y=606,
            width=357,
            height=190,

        },
        {
            -- a_2
            x=2,
            y=878,
            width=211,
            height=124,

        },
        {
            -- a_3
            x=863,
            y=466,
            width=268,
            height=159,

        },
        {
            -- a_4
            x=1006,
            y=240,
            width=129,
            height=111,

        },
        {
            -- a_5
            x=1006,
            y=2,
            width=134,
            height=117,

        },
        {
            -- a_6
            x=504,
            y=798,
            width=285,
            height=224,

        },
        {
            -- sheep_0
            x=2,
            y=2,
            width=500,
            height=410,

            sourceX = 0,
            sourceY = 45,
            sourceWidth = 500,
            sourceHeight = 500
        },
        {
            -- sheep_1
            x=504,
            y=2,
            width=500,
            height=410,

            sourceX = 0,
            sourceY = 45,
            sourceWidth = 500,
            sourceHeight = 500
        },
        {
            -- sheep_2
            x=2,
            y=466,
            width=500,
            height=410,

            sourceX = 0,
            sourceY = 45,
            sourceWidth = 500,
            sourceHeight = 500
        },
        {
            -- w_1
            x=504,
            y=606,
            width=357,
            height=190,

        },
        {
            -- w_2
            x=215,
            y=878,
            width=211,
            height=124,

        },
        {
            -- w_3
            x=863,
            y=627,
            width=268,
            height=159,

        },
        {
            -- w_4
            x=1006,
            y=353,
            width=129,
            height=111,

        },
        {
            -- w_5
            x=1006,
            y=121,
            width=134,
            height=117,

        },
        {
            -- w_6
            x=791,
            y=798,
            width=285,
            height=224,

        },
    },
    
    sheetContentWidth = 1142,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["a_1"] = 1,
    ["a_2"] = 2,
    ["a_3"] = 3,
    ["a_4"] = 4,
    ["a_5"] = 5,
    ["a_6"] = 6,
    ["sheep_0"] = 7,
    ["sheep_1"] = 8,
    ["sheep_2"] = 9,
    ["w_1"] = 10,
    ["w_2"] = 11,
    ["w_3"] = 12,
    ["w_4"] = 13,
    ["w_5"] = 14,
    ["w_6"] = 15,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
