--------------------------------------------------- Creates the Screen Background Effects ----------------------------------------------------(1)
local function Background(Logo,Aura0,Aura1,r,g,b,ar,ag,ab)
    
    local rx, ry = getResolution()
    local vw = rx/100
    local vh = ry/100

    --- Main Color ---
    local r = r or 0
    local g = g or 0.2
    local b = b or 0.8
    
    --- Accent Color ---
    local ar = ar or 0
    local ag = ag or 0.4
    local ab = ab or 0.8

    setBackgroundColor(0.05*r,0.05*g,0.05*b)

    for ii = 3,165,8 do
        setNextStrokeColor(Aura0,r,g,b,0.05)
        setNextStrokeWidth(Aura0,0.05*vh)
        addLine(Aura0,ii*vh,0,ii*vh,ry)
    end

    for ii = 6,98,8 do
        setNextStrokeColor(Aura0,r,g,b,0.05) 
        setNextStrokeWidth(Aura0,0.05*vh)
        addLine(Aura0,0,ii*vh,rx,ii*vh)
    end

    local PX = {0,1}
    local PY = {0.03,0.03}

    for ii = 1,#PX-1,1 do
        setNextStrokeColor(Aura1,ar,ag,ab, 1) 
        addLine(Aura1, PX[ii]*rx, PY[ii]*ry, PX[ii+1]*rx, PY[ii+1]*ry) 
    end

    for ii = 1,#PX-1,1 do
        setNextStrokeColor(Aura1,ar,ag,ab, 1) 
        addLine(Aura1, PX[ii]*rx, ry-PY[ii]*ry, PX[ii+1]*rx, ry-PY[ii+1]*ry) 
    end

end

--------------------------------------------------- Horizontal Bar Chart for Ore Output ----------------------------------------------------(1)

function BarChart(layer,Font,X,Y,Data,n,r,g,b,sx,sy)
    
    local rx, ry = getResolution()
    local vw = rx/100
    local vh = ry/100
    
    local xwidth = sx/n
    local xmargin = xwidth*0.1
    
    local ywidth = sy/#Data
    local ymargin = ywidth*0.1    

    for ii = 1,#Data,1 do 
        
        local r,g,b = table.unpack(OreTable[OreTierOrder[ii]].color)
        
        local Height = math.ceil(n*Data[ii]/TotalOut)

        for jj = 1,Height,1 do
            setNextFillColor(layer,r/255,g/255,b/255,1)
            addQuad(layer,              
                X + (jj-1)*xwidth + xmargin,
                Y + (ii-1)*ywidth + ymargin,               
                X + jj*xwidth - xmargin,
                Y + (ii-1)*ywidth + ymargin,               
                X + jj*xwidth - xmargin,
                Y + ii*ywidth - ymargin,             
                X + (jj-1)*xwidth + xmargin,
                Y + ii*ywidth - ymargin
            )
        end
        
        for jj = math.max(Height,1),n,1 do
            
            if Height == 0 then
                setNextFillColor(layer,r/255,g/255,b/255,0.05)
            else
                setNextFillColor(layer,r/255,g/255,b/255,0.1)
            end
            
            addQuad(layer,              
                X + (jj-1)*xwidth + xmargin,
                Y + (ii-1)*ywidth + ymargin,               
                X + jj*xwidth - xmargin,
                Y + (ii-1)*ywidth + ymargin,               
                X + jj*xwidth - xmargin,
                Y + ii*ywidth - ymargin,             
                X + (jj-1)*xwidth + xmargin,
                Y + ii*ywidth - ymargin
            )
        end
        
        setNextTextAlign(layer, AlignH_Left, AlignV_Middle)
        if Height == 0 then
            setNextFillColor(layer,r/255,g/255,b/255,0.1)
        else
            setNextFillColor(layer,r/255,g/255,b/255,1)
        end
        setFontSize(Font,3*vh)
        addText(layer, Font, " " .. round(tonumber(Data[ii]),1) .. " L/H", X + sx, Y + (ii - 0.5)*ywidth)     
            
        setNextTextAlign(layer, AlignH_Right, AlignV_Middle)
        if Height == 0 then
            setNextFillColor(layer,r/255,g/255,b/255,0.1)
        else
            setNextFillColor(layer,r/255,g/255,b/255,1)
        end
        setFontSize(Font,3*vh)
        addText(layer, Font, OreTable[OreTierOrder[ii]].displayNameWithSize .. " ", X, Y + (ii - 0.5)*ywidth)    

    end

end

------------------------------------------------------------ General Helpers -----------------------------------------------------------------(10)

--- Splits String at Delimiter ---
function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

--- Rounds Number to Precision ---
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

--- Word Wrap ---
local function wrap(str, limit)
    
    local Lines, here, limit = {}, 1, limit or 72
    
    if str:find("(%s+)()(%S+)()") ~= nil then
        
        Lines[1] = string.sub(str,1,str:find("(%s+)()(%S+)()")-1)  -- Put the first word of the string in the first index of the table.

        str:gsub("(%s+)()(%S+)()",
            function(sp, st, word, fi)  -- Function gets called once for every space found.
                if fi-here > limit then
                    here = st
                    Lines[#Lines+1] = word                                             -- If at the end of a line, start a new table index...
                else Lines[#Lines] = Lines[#Lines].." "..word end  -- ... otherwise add to the current table index.
            end)
    else
        Lines[1] = str
    end

  return Lines
end
------------------------------------------------------------ Reference Tables -----------------------------------------------------------------(11)

OreTable = {    
    ["4234772167"]={color={255,255,129},displayNameWithSize="Hematite",iconPath="resources_generated/env/voxel/ore/iron-ore/icons/env_iron-ore_icon.png"},
    ["3724036288"]={color={159,209,255},displayNameWithSize="Quartz",iconPath="resources_generated/env/voxel/ore/silicon-ore/icons/env_silicon-ore_icon.png"},
    ["299255727"]={color={192,255,255},displayNameWithSize="Coal",iconPath="resources_generated/env/voxel/ore/carbon-ore/icons/env_carbon-ore_icon.png"},
    ["262147665"]={color={255,188,68},displayNameWithSize="Bauxite",iconPath="resources_generated/env/voxel/ore/aluminium-ore/icons/env_aluminium-ore_icon.png"},
    
    ["2289641763"]={color={70,255,197},displayNameWithSize="Malachite",iconPath="resources_generated/env/voxel/ore/copper-ore/icons/env_copper-ore_icon.png"},
    ["3086347393"]={color={255,128,88},displayNameWithSize="Limestone",iconPath="resources_generated/env/voxel/ore/calcium-ore/icons/env_calcium-ore_icon.png"},
    ["2029139010"]={color={129,255,129},displayNameWithSize="Chromite",iconPath="resources_generated/env/voxel/ore/chromium-ore/icons/env_chromium-ore_icon.png"},
    ["343766315"]={color={255,139,157},displayNameWithSize="Natron",iconPath="resources_generated/env/voxel/ore/sodium-ore/icons/env_sodium-ore_icon.png"},
        
    ["4041459743"]={color={74,255,74},displayNameWithSize="Pyrite",iconPath="resources_generated/env/voxel/ore/sulfur-ore/icons/env_sulfur-ore_icon.png"}, 
    ["3837858336"]={color={108,255,255},displayNameWithSize="Petalite",iconPath="resources_generated/env/voxel/ore/lithium-ore/icons/env_lithium-ore_icon.png"},    
    ["1050500112"]={color={75,255,166},displayNameWithSize="Acanthite",iconPath="resources_generated/env/voxel/ore/silver-ore/icons/env_silver-ore_icon.png"},
    ["1065079614"]={color={255,148,124},displayNameWithSize="Garnierite",iconPath="resources_generated/env/voxel/ore/nickel-ore/icons/env_nickel-ore_icon.png"},
    
    ["1866812055"]={color={255,103,63},displayNameWithSize="Gold Nuggets",iconPath="resources_generated/env/voxel/ore/gold-ore/icons/env_gold-ore_icon.png"},
    ["271971371"]={color={255,166,104},displayNameWithSize="Kolbeckite",iconPath="resources_generated/env/voxel/ore/scandium-ore/icons/env_scandium-ore_icon.png"},
    ["3546085401"]={color={255,132,79},displayNameWithSize="Cobaltite",iconPath="resources_generated/env/voxel/ore/cobalt-ore/icons/env_cobalt-ore_icon.png"},
    ["1467310917"]={color={168,255,73},displayNameWithSize="Cryolite",iconPath="resources_generated/env/voxel/ore/fluorine-ore/icons/env_fluorine-ore_icon.png"},
    
    ["3934774987"]={color={90,206,255},displayNameWithSize="Rhodonite",iconPath="resources_generated/env/voxel/ore/manganese-ore/icons/env_manganese-ore_icon.png"},
    ["629636034"]={color={255,203,255},displayNameWithSize="Ilmenite",iconPath="resources_generated/env/voxel/ore/titanium-ore/icons/env_titanium-ore_icon.png"},
    ["2162350405"]={color={184,184,255},displayNameWithSize="Vanadinite",iconPath="resources_generated/env/voxel/ore/vanadium-ore/icons/env_vanadium-ore_icon.png"},    
    ["789110817"]={color={231,229,74},displayNameWithSize="Columbite",iconPath="resources_generated/env/voxel/ore/niobium-ore/icons/env_niobium-ore_icon.png"}
}

OreTierOrder = {"4234772167","3724036288","299255727","262147665","2289641763","3086347393","2029139010","343766315","4041459743","3837858336","1050500112","1065079614","1866812055","271971371","3546085401","1467310917","3934774987","629636034","2162350405","789110817"}

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------- Compose --------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------

local rx, ry = getResolution()
local vw = rx/100
local vh = ry/100

local Logo = createLayer()
local Aura0 = createLayer()
local Aura1 = createLayer()
local Back = createLayer()
local Center = createLayer()
local Front = createLayer()
local Top = createLayer()

local Font = loadFont(getAvailableFontName(5), 6*vh)

if not _init then

    ConstructTable = {}
    TotalOut = 100
    
    _init = true
    
end

json = require('dkjson')

Payload = getInput()

logMessage(Payload)

if Payload ~= nil and Payload ~= '' then
        
    PayloadType = mysplit(Payload, "&")    
    
    if PayloadType[1] ~= nil and PayloadType[1] ~= '' then
        
        ConstructRows = mysplit(PayloadType[1], "#")  
        ConstructTable = {}
        for idx, v in ipairs(ConstructRows) do
            CurrentRow = mysplit(v, "$") 
            ConstructTable[idx] = {
                Name = CurrentRow[1],
                Mass = CurrentRow[2],
                Vol = CurrentRow[3],
                StorageTime = CurrentRow[4],
                CalibrationTime = CurrentRow[5],
                CDTime = CurrentRow[6]
            }
        end
                
    end
    
    ------

    if PayloadType[2] ~= nil and PayloadType[2] ~= '' then
        
        DataRows = mysplit(PayloadType[2], "#")  
        DataTable = {}
        
        TotalOut = 0
        for idx, v in ipairs(DataRows) do
            CurrentRow = mysplit(v, "$") 
            DataTable[CurrentRow[1]] = tonumber(CurrentRow[2])
            TotalOut = TotalOut + tonumber(CurrentRow[2])
        end
        
    end

end

Background(Logo,Aura0,Aura1)

X = 9.5*vh
Y = 10*vh
SX = 80*vh
SY = 8*vh

--------- Row Background ----------

local HeaderFont = loadFont(getAvailableFontName(11), 3*vh)

setNextFillColor(Top, 255/255,175/255,83/255,1)
setNextTextAlign(Top, AlignH_Left, AlignV_Descender)
addText(Top, HeaderFont, "Construct", X, Y - 0.5*vh)

setNextFillColor(Top, 0.2,0.7,1,1)
setNextTextAlign(Top, AlignH_Right, AlignV_Descender)
addText(Top, HeaderFont, "Calibrate", X + SX, Y - 0.5*vh)

setNextFillColor(Top, 1,1,0.5,1)
setNextTextAlign(Top, AlignH_Center, AlignV_Descender)
addText(Top, HeaderFont, "Storage", X + SX - 32*vh, Y - 0.5*vh)

setNextFillColor(Top, 1,1,1,1)
setNextTextAlign(Top, AlignH_Center, AlignV_Descender)
addText(Top, HeaderFont, "Cumulative Mining Rate", X + SX + 39.75*vh, Y - 0.5*vh)

for jj = 1,11 do
    setNextStrokeColor(Top,1,1,1,0.05+jj*0.085)
    setNextStrokeWidth(Top,0.02*vh+jj*0.02*vh)
    addLine(Top,X + SX/21*(jj-1) + 0.1*vh, Y + (1-1)*10*vh, X + SX/21*(jj) - 0.1*vh, Y + (1-1)*10*vh)
end

for jj = 12,21 do
    setNextStrokeColor(Top,1,1,1,1-(jj-11)*0.085)
    setNextStrokeWidth(Top,0.22*vh-(jj-11)*0.02*vh)
    addLine(Top,X + SX/21*(jj-1) + 0.1*vh, Y + (1-1)*10*vh, X + SX/21*(jj) - 0.1*vh, Y + (1-1)*10*vh)
end

for ii = 1,5 do

    setNextFillColor(Top,1,1,1,0.1)
    addBox(Top, X, Y + (ii-1)*2*SY, SX, SY)

    setNextFillColor(Top,0,0.6,1,0.1)
    addBox(Top, X, Y + (ii-1)*2*SY, SX, SY)

    setNextFillColor(Top,1,1,1,0.1)
    addBox(Top, X, Y + SY + (ii-1)*2*SY, SX, SY)

    setNextFillColor(Top,0,0.3,0.5,0.1)
    addBox(Top, X, Y + SY + (ii-1)*2*SY, SX, SY)

end

--------------- Fill in Rows ----------------------

if ConstructTable[1] ~= nil and ConstructTable[1] ~= {} then
    for ii = 1,#ConstructTable do

        local ConstructImage = loadImage("resources_generated/gameplay/marks/icon_static_construct.png")
        addImage(Top, ConstructImage, X + 0.5*vh, Y + (ii-0.5)*SY - 2*vh, 4*vh, 4*vh)

        ConstructText = wrap(ConstructTable[ii].Name,20)

        WrapLines = math.min(#ConstructText,3)
        for jj = 1,WrapLines  do
            setNextFillColor(Top, 1,1,1,1)
            setNextTextAlign(Top, AlignH_Left, AlignV_Middle)
            setFontSize(Font,2.5*vh)
            if WrapLines == 1 then
                addText(Top, Font, ConstructText[jj],  X + 5*vh, Y + (ii - 0.5)*SY)
            elseif WrapLines == 2 then
                addText(Top, Font, ConstructText[jj],  X + 5*vh, Y + (ii-(3-jj)*0.5 + 0.25)*SY)
            elseif WrapLines == 3 then
                addText(Top, Font, ConstructText[jj],  X + 5*vh, Y + (ii-(4-jj)*0.33 + 0.165)*SY)
            end            
        end

        StorageTime = ConstructTable[ii].StorageTime
        
        local Days = math.floor(StorageTime/24)
        local Hours = StorageTime - Days*24
        local Minutes = (Hours - math.floor(Hours))*60
        
        local DaysText = tostring(math.floor(Days))
        local HoursText = tostring(math.floor(Hours))
        local MinutesText = tostring(math.floor(Minutes))
        
        StorageTimeText = DaysText .. "D" .. HoursText .. "H" .. MinutesText .. "M"
        
        StorageText = {round(ConstructTable[ii].Vol/1000,2) .. "kL", round(ConstructTable[ii].Mass/1000,2) .. "t"}

        for jj = 1,2 do
            setNextFillColor(Top, 1,1,0.5,1)
            setNextTextAlign(Top, AlignH_Center, AlignV_Middle)
            setFontSize(Font,2.5*vh)
            addText(Top, Font, StorageText[jj],  X + 40*vh, Y + (ii-(3-jj)*0.5 + 0.25)*SY)
        end
        
        setNextFillColor(Top, 1,1,0.5,1)
        setNextTextAlign(Top, AlignH_Center, AlignV_Middle)
        setFontSize(Font,2.5*vh)
        addText(Top, Font, StorageTimeText,  X + 55*vh, Y + (ii - 0.5)*SY)

        CalibrationTime = ConstructTable[ii].CalibrationTime
        
        local Days = math.floor(CalibrationTime)
        local Hours = (CalibrationTime - Days)*24
        local Minutes = (Hours - math.floor(Hours))*60
        
        local DaysText = tostring(math.floor(Days))
        local HoursText = tostring(math.floor(Hours))
        local MinutesText = tostring(math.floor(Minutes))
        
        logMessage(CalibrationTime)
        
        CalibrationTimeText = DaysText .. "D" .. HoursText .. "H" .. MinutesText .. "M "
        
        CDTime = ConstructTable[ii].CDTime
  
        local Hours = math.floor(CDTime)
        local Minutes = (CDTime - Hours)*60
        
        local HoursText = tostring(math.floor(Hours))
        local MinutesText = tostring(math.floor(Minutes))
        
        CDTimeText = HoursText .. "H" .. MinutesText .. "M "
        
        CooldownText = {CalibrationTimeText,CDTimeText}

        for jj = 1,2 do
            setNextFillColor(Top, 0.2,0.7,1,1)
            setNextTextAlign(Top, AlignH_Right, AlignV_Middle)
            setFontSize(Font,2.5*vh)
            addText(Top, Font, CooldownText[jj],  X + SX, Y + (ii-(3-jj)*0.5 + 0.25)*SY)
        end



    end
end


--------------------------------------------------------------------------------------------

local Bar = createLayer()
local Font = loadFont(getAvailableFontName(5), 6*vh)

Data = {}

if DataTable then
    for ii = 1,20 do
        if DataTable[OreTierOrder[ii]] ~= nil and DataTable[OreTierOrder[ii]] ~= {} then
            Data[ii] = DataTable[OreTierOrder[ii]]
        else 
            Data[ii] = 0
        end
    end
    
else
    for ii = 1,20 do
        Data[ii] = 0
    end
end
    
BarChart(Bar,Font,0.675*rx,0.1*ry,Data,10,0.0,0.4,0.8,0.2*rx,0.8*ry,TotalOut)

requestAnimationFrame(60)


