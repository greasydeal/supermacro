-- Copyright © 2022, greasydeal
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
-- 
--     * Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--     * Neither the name of SuperMacro nor the
--       names of its contributors may be used to endorse or promote products
--       derived from this software without specific prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL <your name> BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

_addon.name = 'SuperMacro'
_addon.author = 'greasydeal'
_addon.version = '0.1'
_addon.command = 'supermacro'
_addon.commands = {'sm','smacro'}

require('tables')
require('strings')

config = require('config')
images = require('images')
texts = require('texts')
files = require('files')
images = require('images')
xml = require('xml') 

----------------------------------------
-- Addon defaults / settings
----------------------------------------
do
   local defaults = T{}
   defaults.globalBarCount = 3
   defaults.charBarCount = 0
   defaults.buttonCount = 10
   defaults.buttonAlpha = 255
   defaults.buttonColorRed = 0
   defaults.buttonColorGreen = 0
   defaults.buttonColorBlue = 0
   defaults.buttonSizeX = 60
   defaults.buttonSizeY = 45
   defaults.buttonTextAlpha = 0
   defaults.buttonTextRed = 0
   defaults.buttonTextGreen = 0
   defaults.buttonTextBlue = 0
   defaults.buttonTextSize1 = 10
   defaults.buttonTextCharLimit1 = 10
   defaults.buttonTextSize2 = 12
   defaults.buttonTextCharLimit2 = 10
   defaults.cursorAlpha = 255
   defaults.cursorColorRed = 100
   defaults.cursorColorGreen = 0
   defaults.cursorColorBlue = 0
   defaults.mCursorAlpha = 255
   defaults.mCursorColorRed = 0
   defaults.mCursorColorGreen = 100
   defaults.mCursorColorBlue = 0
   defaults.spacingX = 5
   defaults.spacingY = 5
   defaults.posX = 400
   defaults.posY = 650
   defaults.cursorBlinkTime = 1

   settings = config.load(defaults)

   settings:save('all')

   menuOpen = false
   modMode = false
   macroBar = T{}
   globalBarCount = settings.globalBarCount
   charBarCount = settings.charBarCount
   buttonCount = settings.buttonCount
   buttonXSpacing = settings.spacingX
   buttonYSpacing = settings.spacingY
   buttonXStart = settings.posX
   buttonYStart = settings.posY
   cursor = {1,1}
   cursorBlinkTime = 1
   cursorPrevious = cursor
   frameCounter = 0
   totalBarCount = nil
end

keys = S{}
allowedKeys = {'numpad1','numpad2','numpad3','numpad4','numpad5','numpad6','numpad7','numpad8','numpad9','numpad0','tab'}

dikt = {    -- Keys
    [1] = 'esc',
    [2] = '1',
    [3] = '2',
    [4] = '3',
    [5] = '4',
    [6] = '5',
    [7] = '6',
    [8] = '7',
    [9] = '8',
    [10] = '9',
    [11] = '0',
    [12] = '-',
    [13] = '=',
    [14] = 'backspace',
    [15] = 'tab',
    [16] = 'q',
    [17] = 'w',
    [18] = 'e',
    [19] = 'r',
    [20] = 't',
    [21] = 'y',
    [22] = 'u',
    [23] = 'i',
    [24] = 'o',
    [25] = 'p',
    [26] = '[',
    [27] = ']',
    [28] = 'enter',
    [29] = 'ctrl',
    [30] = 'a',
    [31] = 's',
    [32] = 'd',
    [33] = 'f',
    [34] = 'g',
    [35] = 'h',
    [36] = 'j',
    [37] = 'k',
    [38] = 'l',
    [39] = ';',
    [40] = '\'',
    [41] = '`',
    [42] = 'shift',
    [43] = '\\',
    [44] = 'z',
    [45] = 'x',
    [46] = 'c',
    [47] = 'v',
    [48] = 'b',
    [49] = 'n',
    [50] = 'm',
    [51] = ',',
    [52] = '.',
    [53] = '/',
    [54] = nil,
    [55] = 'num*',
    [56] = 'alt',
    [57] = 'space',
    [58] = nil,
    [59] = 'f1',
    [60] = 'f2',
    [61] = 'f3',
    [62] = 'f4',
    [63] = 'f5',
    [64] = 'f6',
    [65] = 'f7',
    [66] = 'f8',
    [67] = 'f9',
    [68] = 'f10',
    [69] = 'numlock',
    [70] = 'scrolllock',
    [71] = 'numpad7',
    [72] = 'numpad8',
    [73] = 'numpad9',
    [74] = 'numpad-',
    [75] = 'numpad4',
    [76] = 'numpad5',
    [77] = 'numpad6',
    [78] = 'numpad+',
    [79] = 'numpad1',
    [80] = 'numpad2',
    [81] = 'numpad3',
    [82] = 'numpad0',

    [199] = 'home',
    [200] = 'up',
    [201] = 'pageup',
    [202] = nil,
    [203] = 'left',
    [204] = nil,
    [205] = 'right',
    [206] = nil,
    [207] = 'end',
    [208] = 'down',
    [209] = 'pagedown',
    [210] = 'insert',
    [211] = 'delete',
    [219] = 'win',
    [220] = 'rwin',
    [221] = 'apps',
}

function AddonMessage(message)
   windower.add_to_chat(1, ('\31\200[\31\05SuperMacro\31\200]\31\207 '.. " " .. message))
end

function GetBarsXML()
   local playerName = windower.ffxi.get_player().name
   local f = files.new('data/'..playerName..'.xml')

   if f:exists() == false then
      AddonMessage('Missing data/'..playerName..'\31\207.xml character profile.')
      AddonMessage('Creating default data/'..playerName..'\31\207.xml')
      AddonMessage('You will need to edit this file to customize your character specific action bars.')
      AddonMessage('Visit https://github.com/greasydeal/supermacro for more info.')
      f:write('<bars>\n')
      f:append('  <bar>default.xml</bar>\n')
      f:append('</bars>')   
   end

   if f:exists() then
      fXML = xml.read(f)
      if fXML == nil then
         AddonMessage('Error parsing data/'..playerName..'\31\207.xml. Check for syntax errors.')
      else
         return fXML
      end
   end

end

function GetJobBarsXML()
   local playerName = windower.ffxi.get_player().name
   local playerJob = windower.ffxi.get_player().main_job
   local playerSubJob = windower.ffxi.get_player().sub_job
   local fString = 'data/'..playerName..'_'..playerJob..'_'..playerSubJob..'.xml'
   local f = files.new(fString)

   if f:exists() == false then
      fString = 'data/'..playerName..'_'..playerJob..'.xml'
      f = files.new(fString)
      if f:exists() == false then
         AddonMessage('Missing '.. playerJob ..'\31\207 job profile for ' .. playerName .. '\31\207.')
         AddonMessage('Creating default data/'..playerName..'_'..playerJob..'\31\207.xml')
         AddonMessage('You will need to edit this file to customize your job specific action bars.')
         AddonMessage('Visit https://github.com/greasydeal/supermacro for more info.')
         f:write('<bars>\n')
         f:append('  <bar>default.xml</bar>\n')
         f:append('</bars>')   
      end
   end

   if f:exists() then
      fXML = xml.read(f)
      if fXML == nil then
         AddonMessage('Error parsing '..fString..'\31\207. Check for syntax errors.')
      else
         return fXML
      end
   end
end

---------------------------------------------------------------
-- Parses bar .xml files for button data
-- Accepts filename as string
-- Returns an array of button data arrays
---------------------------------------------------------------
function GetButtonData(bar)
   local defaultData = {'#empty#','#empty#','/echo No command set','/echo No command set','#empty','#empty#'}
   local actionBar = {}
   for i=1, buttonCount do
      actionBar[i] = {'#empty#','#empty#','/echo No command set','/echo No command set','#empty','#empty#'}
   end
   
   barXML = xml.read('data/bars/'..bar)
   
   for key, button in ipairs(barXML.children) do --[for each button in the bar]

      local data = {'#empty#','#empty#','/echo No command set','/echo No command set','#empty','#empty#'}
      local buttonNumber = tonumber(button.name)

      if type(buttonNumber) == 'number' then --[check element name = number]
         if buttonNumber <= buttonCount then --[only add buttons up to button count in config]

            for key, field in ipairs(button.children) do
               if field.name == 'text1' then
                  if field.children ~= nil then
                     if field.children[1] ~= nil then
                        data[1] = field.children[1].value
                     end
                  end
               elseif field.name == 'text2' then
                  if field.children ~= nil then
                     if field.children[1] ~= nil then
                        data[2] = field.children[1].value
                     end
                  end
               elseif field.name == 'action' then
                  if field.children ~= nil then
                     if field.children[1] ~= nil then
                        data[3] = field.children[1].value
                     end
                  end
               elseif field.name == 'modAction' then
                  if field.children ~= nil then
                     if field.children[1] ~= nil then
                        data[4] = field.children[1].value
                     end
                  end
               elseif field.name == 'modText1' then
                  if field.children ~= nil then
                     if field.children[1] ~= nil then
                        data[5] = field.children[1].value
                     end
                  end
               elseif field.name == 'modText2' then
                  if field.children ~= nil then
                     if field.children[1] ~= nil then
                        data[6] = field.children[1].value
                     end
                  end   
               end
            end

            actionBar[buttonNumber] = data --[Add button data to the matching index number (button number) of the action bar array]

         end
      end
   end

   return actionBar

end

function GetStringWidth(str, fontSize)
   local letterWidthTable = {{" ",27.797},{"!",33.313},{"\"",47.422},{"#",55.625},{"$",55.625},{"%",88.922},{"&",72.219},{"'",23.781},{"(",33.313},{")",33.313},{"*",38.922},{"+",58.406},{",",27.797},{"-",33.313},{".",27.797},{"/",27.797},{"0",55.625},{"1",55.625},{"2",55.625},{"3",55.625},{"4",55.625},{"5",55.625},{"6",55.625},{"7",55.625},{"8",55.625},{"9",55.625},{":",33.313},{";",33.313},{"<",58.406},{"=",58.406},{">",58.406},{"?",61.094},{"@",97.516},{"A",72.219},{"B",72.219},{"C",72.219},{"D",72.219},{"E",66.703},{"F",61.094},{"G",77.797},{"H",72.219},{"I",27.797},{"J",55.625},{"K",72.219},{"L",61.094},{"M",83.313},{"N",72.219},{"O",77.797},{"P",66.703},{"Q",77.797},{"R",72.219},{"S",66.703},{"T",61.094},{"U",72.219},{"V",66.703},{"W",94.391},{"X",66.703},{"Y",66.703},{"Z",61.094},{"{",33.313},{"\\",27.797},{"}",33.313},{"^",58.406},{"_",55.625},{"`",33.313},{"a",55.625},{"b",61.094},{"c",55.625},{"d",61.094},{"e",55.625},{"f",33.313},{"g",61.094},{"h",61.094},{"i",27.797},{"j",27.797},{"k",55.625},{"l",27.797},{"m",88.922},{"n",61.094},{"o",61.094},{"p",61.094},{"q",61.094},{"r",38.922},{"s",55.625},{"t",33.313},{"u",61.094},{"v",55.625},{"w",77.797},{"x",55.625},{"y",55.625},{"z",50},{"{",38.922},{"|",27.984},{"}",38.922},{"~",58.406},{"_median",55.625}}
   local kernModifier = {{" A",-3.719},{" Y",-1.813},{"11",-5.531},{"A ",-3.719},{"AT",-7.422},{"AV",-7.422},{"AW",-5.516},{"AY",-9.172},{"Av",-3.719},{"Aw",-1.813},{"Ay",-3.719},{"F,",-11.094},{"F.",-11.094},{"FA",-5.516},{"L ",-1.829},{"LT",-7.438},{"LV",-7.422},{"LW",-5.532},{"LY",-9.188},{"Ly",-3.719},{"P ",-1.813},{"P,",-12.906},{"P.",-12.906},{"PA",-7.422},{"RV",-1.813},{"RW",-1.813},{"RY",-3.703},{"T,",-11.094},{"T-",-5.532},{"T.",-11.094},{"T:",-11.095},{"T;",-11.095},{"TA",-7.422},{"TO",-1.828},{"Ta",-7.438},{"Tc",-7.438},{"Te",-7.438},{"Ti",-1.829},{"To",-7.438},{"Tr",-5.532},{"Ts",-7.438},{"Tu",-7.438},{"Tw",-7.438},{"Ty",-7.438},{"V,",-9.188},{"V-",-5.532},{"V.",-9.188},{"V:",-5.532},{"V;",-5.532},{"VA",-7.422},{"Va",-5.531},{"Ve",-5.531},{"Vi",-1.813},{"Vo",-7.422},{"Vr",-5.516},{"Vu",-3.719},{"Vy",-3.719},{"W,",-5.532},{"W-",-2.017},{"W.",-5.532},{"W:",-1.813},{"W;",-1.813},{"WA",-5.516},{"Wa",-3.719},{"We",-1.813},{"Wi",-0.891},{"Wo",-1.813},{"Wr",-1.813},{"Wu",-1.813},{"Wy",-1.813},{"Y ",-1.813},{"Y,",-11.094},{"Y-",-5.532},{"Y.",-11.094},{"Y:",-7.438},{"Y;",-7.438},{"YA",-9.172},{"Ya",-5.531},{"Ye",-5.531},{"Yi",-3.719},{"Yo",-7.422},{"Yp",-5.531},{"Yq",-7.422},{"Yu",-5.531},{"Yv",-5.531},{"r,",-5.531},{"r.",-5.531},{"v,",-7.438},{"v.",-7.438},{"w,",-3.735},{"w.",-3.735},{"y,",-7.438},{"y.",-7.438}}
   local stringWidth = 0
   local charStepCount = 0

   str = str:trim()
   for c in str:it() do
      charStepCount = charStepCount + 1
      for t in pairs(letterWidthTable) do
         if letterWidthTable[t][1] == c then
            stringWidth = stringWidth + letterWidthTable[t][2]
            for k in pairs(kernModifier) do
               if kernModifier[k][1] == (c.. str[charStepCount + 1]) then
                  stringWidth = stringWidth + kernModifier[k][2]
               end
            end
         end
      end
   end
   return ((stringWidth * 1.25) / (100/fontSize))
end

function TrimString(str, length)
   return str:slice(1, length)
end

---------------------------------------------------------------
-- Parses profile .xml files for bar data
---------------------------------------------------------------
function ParseBarData()

   local playerName = windower.ffxi.get_player().name
   local barsXML = GetBarsXML()
   local jobBarsXML = GetJobBarsXML()
   local barList = T{}
   local charBarCount  = 0
   local jobBarCount = 0

   if barsXML == nil then
      AddonMessage('Error loading data/'..playerName..'\31\207.xml. Check for syntax errors.')
      AddonMessage('Unloading SuperMacro...')
      windower.send_command('lua unload supermacro')
   else
      for key, bar in ipairs (barsXML.children) do
         if bar.name == 'bar' then
            if bar.children[1].value ~= nil then
               if totalBarCount == nil then
                  totalBarCount = 1
               else
                  totalBarCount = totalBarCount + 1
               end
               barList:append(bar.children[1].value)
            end
         end
      end
      AddonMessage('Found '.. totalBarCount .. ' character bar(s) for '.. playerName.. '\31\207.')
   end

   charBarCount = totalBarCount

   if jobBarsXML == nil then
      AddonMessage('Error loading job specific bars. Check for syntax errors.')
      AddonMessage('Unloading SuperMacro...')
      windower.send_command('lua unload supermacro')
   else
      for key, bar in ipairs (jobBarsXML.children) do
         if bar.name == 'bar' then
            if bar.children[1].value ~= nil then
               if totalBarCount == nil then
                  totalBarCount = 1
               else
                  totalBarCount = totalBarCount + 1
               end
               barList:append(bar.children[1].value)
            end
         end
      end
      jobBarCount = totalBarCount - charBarCount
      AddonMessage('Found '.. jobBarCount .. ' job specific bar(s) for '.. playerName.. '\31\207.')
   end

   if barList ~= nil then
      return barList
   end
end

--------------------------------------------------------------------------
-- Loops through the number of action bars/buttons and builds bars/buttons
-- To be used at load time
--------------------------------------------------------------------------
function BuildActionBar()

   barList = ParseBarData()

   local buttonX = buttonXStart
   local buttonY = buttonYStart
   local buttonSizeX = settings.buttonSizeX
   local buttonSizeY = settings.buttonSizeY

   ---------------------------------------------------------------------------------------------
   -- Itterates though bar and button counts creating button objects and stores them in a table sturcture as follows:
   -- macroBar[#Bar] >> macroButtonList[#Button] >> buttonContainer [(1)buttonUI[(1)buttonText_1,(2)buttonText_1], (2)buttonData]
   ---------------------------------------------------------------------------------------------
   for i, bar in pairs(barList) do

      local macroButtonList = T{} --meant to be a list of buttonContainers
      local barData = GetButtonData(bar)

      for j=1,buttonCount do

         local lineYOffset = settings.buttonTextSize1 / (72/96)

         local buttonData = T{} -- Text Line 1, Text Line 2, Command
         local buttonContainer = T{} -- buttonUI, buttonData
         local buttonUI = T{} -- buttonBg, buttonText_1

         -- Clean button data
         if barData[j][1] == '#empty#' then
            barData[j][1] = ''
         end
         if barData[j][2] == '#empty#' then
            barData[j][2] = ''
         end
         if barData[j][5] == '#empty#' then
            barData[j][5] = barData[j][1]
         end
         if barData[j][6] == '#empty#' then
            barData[j][6] = barData[j][2]
         end

         -- Add data to buttonData table
         buttonData:append(barData[j][1]) -- Text Line 1
         buttonData:append(barData[j][2]) -- Text Line 2
         buttonData:append(barData[j][3]) -- command
         buttonData:append(barData[j][4]) -- modified command
         buttonData:append(barData[j][5]) -- modified text line 1
         buttonData:append(barData[j][6]) -- modified text line 2

         -- Create button background
         local buttonBg = images.new()
         buttonBg:color(settings.buttonColorRed,settings.buttonColorGreen,settings.buttonColorBlue)
         buttonBg:alpha(settings.buttonAlpha)
         buttonBg:size(settings.buttonSizeX,settings.buttonSizeY)
         buttonBg:draggable(false)
         buttonBg:pos(buttonX, buttonY)
         buttonExtentsX, buttonExtentsY = buttonBg:get_extents()

         -- Create button text line 1
         local buttonText_1 = texts.new(TrimString(buttonData[1], settings.buttonTextCharLimit1))
         buttonText_1:bg_visible(false)
         buttonText_1:size(settings.buttonTextSize1)
         buttonText_1:stroke_alpha(100)
         buttonText_1.draggable = false
         buttonText_1_width = GetStringWidth(buttonText_1:text(), settings.buttonTextSize1)
         --buttonText_1:pos(buttonX, buttonY)

         -- Create button text line 2
         if not (buttonData[2] == nil) then
            buttonText_2 = texts.new(TrimString(buttonData[2], settings.buttonTextCharLimit2))
            buttonText_2:bg_visible(false)
            buttonText_2:size(settings.buttonTextSize2)
            buttonText_2:stroke_alpha(100)
            buttonText_2.draggable = false
            buttonText_2_width = GetStringWidth(buttonText_2:text(), settings.buttonTextSize2)
            --buttonText_2:pos(buttonX, buttonY + lineYOffset)
         end

         -- Center text lines horizontally and vertially
         local textOffsetX_1 = ((buttonExtentsX - buttonX) - buttonText_1_width) / 2
         local textOffsetY_1 = ( (buttonExtentsY - buttonY) - ( (settings.buttonTextSize1 / (72/96) ) + ( settings.buttonTextSize2 / (72/96) ) ) ) /2 
         buttonText_1:pos(buttonX + textOffsetX_1, buttonY + textOffsetY_1)

         
         if not (buttonData[2] == nil) then
            local textOffsetX_2 = ((buttonExtentsX - buttonX) - buttonText_2_width) / 2
            local textOffsetY_2 = textOffsetY_1 + lineYOffset
            buttonText_2:pos(buttonX + textOffsetX_2, buttonY + textOffsetY_2)
         end

         -- Combine button UI and data into container
         buttonUI:append(buttonBg)
         buttonUI:append(buttonText_1)
         
         if not (buttonData[2] == nil) then
            buttonUI:append(buttonText_2)
         end

         buttonContainer:append(buttonUI)
         buttonContainer:append(buttonData)

         -- Pass button container to the macro button list
         macroButtonList:append(buttonContainer)

         buttonX = buttonX + buttonSizeX + buttonXSpacing
      end

      buttonX = buttonXStart
      buttonY = buttonY - (buttonSizeY) - buttonYSpacing

      macroBar:append(macroButtonList) -- Adds list of macro buttons to macro bar

   end  
end

function DrawMacroBars()
   for i=1,totalBarCount do
      for j=1,buttonCount do
         macroBar[i][j][1][1]:show()
         macroBar[i][j][1][2]:show()
         if not (macroBar[i][j][1][3] == nil) then
            macroBar[i][j][1][3]:show()
         end
      end
   end
end

function HideMacroBars()
   for i=1,totalBarCount do
      for j=1,buttonCount do
         macroBar[i][j][1][1]:hide()
         macroBar[i][j][1][2]:hide()
         if not (macroBar[i][j][1][3] == nil) then
            macroBar[i][j][1][3]:hide()
         end
      end
   end
end

--Checks if key pressed is a passthrough key
function CheckKeyAllow(key)
   for _,temp in pairs(allowedKeys) do
      if temp == key then
         return true
      end
   end 
   return false
end

-- Checks if key pressed is an arrow key
function CheckKeyArrows(key)
   if (key == 'up') or (key == 'down') or (key == 'left') or (key == 'right') then
      return true
   end
end

-- Checks if key pressed is the enter key
function CheckKeyEnter(key)
   if (key == 'enter') then
      return true
   end
end

-- Checks if they key pressed is the mod key
function CheckModKey(key)
   if (key == '`') then
      return true
   end
end

-- Sends a passthough key
function SendKeySignal(key, down)
   if down then
      state = 'down'
   else
      state = 'up'
   end
   windower.send_command('setkey '.. key .. ' ' .. state)
end

-- Moves the cursor index
function MoveCursor(key)
   cursorBar = cursor[1]
   cursorButton = cursor[2]
   macroBar[cursorBar][cursorButton][1][1]:color(settings.buttonColorRed,settings.buttonColorGreen,settings.buttonColorBlue)
   macroBar[cursorBar][cursorButton][1][1]:alpha(settings.buttonAlpha)

   if key == 'down' then
      if (cursor[1] - 1) <= 0 then
         cursor[1] = totalBarCount
      else   
         cursor[1] = cursor[1] - 1
      end
   elseif key == 'up' then
      if (cursor[1] + 1) > totalBarCount then
         cursor[1] = 1
      else
         cursor[1] = cursor[1] + 1
      end
   elseif key == 'left' then
      if (cursor[2] - 1) <= 0 then
         cursor[2] = buttonCount
      else
         cursor[2] = cursor[2] - 1
      end
   elseif key == 'right' then
      if (cursor[2] + 1) > buttonCount then
         cursor[2] = 1
      else
         cursor[2] = cursor[2] + 1
      end
   end
   ChangeCursorColor()
end

-- Changes the color of the button currently selected by cursor
function ChangeCursorColor()

   cursorBar = cursor[1]
   cursorButton = cursor[2]

   if modMode == true then
      macroBar[cursorBar][cursorButton][1][1]:color(settings.mCursorColorRed,settings.mCursorColorGreen,settings.mCursorColorBlue)
      macroBar[cursorBar][cursorButton][1][1]:alpha(settings.mCursorAlpha)
   else
      macroBar[cursorBar][cursorButton][1][1]:color(settings.cursorColorRed,settings.cursorColorGreen,settings.cursorColorBlue)
      macroBar[cursorBar][cursorButton][1][1]:alpha(settings.cursorAlpha)
   end

end

function FontToPixel(fSize)
   return (fSize / (72/96))
end

windower.register_event('load', function()
   local run = true

   if run == true then
      GetBarsXML()
      BuildActionBar()
      ChangeCursorColor()
      else
         TestFunction()
   end
end)

windower.register_event('prerender', function()   
end)

windower.register_event('keyboard', function(dik, down, flags, blocked)
   key = dikt[dik]
   if (not windower.ffxi.get_info().chat_open) then
      if CheckKeyAllow(key) then
         SendKeySignal(key, down)
      elseif CheckKeyArrows(key) and down and menuOpen then
         MoveCursor(key)
      elseif CheckModKey(key) and down and menuOpen then
         if modMode == false then
            modMode = true
            ChangeCursorColor()
         else
            modMode = false
            ChangeCursorColor()
         end
      elseif CheckKeyEnter(key) and down and menuOpen then
         if modMode == false then
            action = macroBar[cursor[1]][cursor[2]][2][3]
            windower.send_command('input '.. action)
         else
            action = macroBar[cursor[1]][cursor[2]][2][4]
            windower.send_command('input '.. action)
         end
      end
   end
   
   if (dik == 219) then
      if down == true then
         windower.send_command('keyboard_blockinput 1')
         DrawMacroBars()
         menuOpen = true
      else
         windower.send_command('keyboard_blockinput 0')
         HideMacroBars()
         menuOpen = false
         modMode = false
         ChangeCursorColor()
      end
   end
end)

function TestFunction()

end