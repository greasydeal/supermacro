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
   defaults.buttonTextSize1 = 8
   defaults.buttonTextSize2 = 10
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
   defaults.posX = 450
   defaults.posY = 550
   defaults.cursorBlinkTime = 1
   defaults.pageChangeKey = 'tab'

   settings = config.load(defaults)

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

   buttonX = buttonXStart
   buttonY = buttonYStart
   buttonSizeX = settings.buttonSizeX
   buttonSizeY = settings.buttonSizeY

   ---------------------------------------------------------------------------------------------
   -- Itterates though bar and button counts creating button objects and stores them in a table sturcture as follows:
   -- macroBar[#Bar] >> macroButtonList[#Button] >> buttonContainer [(1)buttonUI[(1)buttonText_1,(2)buttonText_1], (2)buttonData]
   ---------------------------------------------------------------------------------------------
   for i, bar in pairs(barList) do

      macroButtonList = T{} --meant to be a list of buttonContainers
      barData = GetButtonData(bar)

      for j=1,buttonCount do

         lineYOffset = settings.buttonTextSize1 / (72/96)

         buttonData = T{} -- Text Line 1, Text Line 2, Command
         buttonContainer = T{} -- buttonUI, buttonData
         buttonUI = T{} -- buttonBg, buttonText_1

         -- Add data to buttonData table
         buttonData:append(barData[j][1]) -- Text Line 1
         buttonData:append(barData[j][2]) -- Text Line 2
         buttonData:append(barData[j][3]) -- command
         buttonData:append(barData[j][4]) -- modified command
         buttonData:append(barData[j][5]) -- Button type

         -- Create button background
         buttonBg = images.new()
         buttonBg:color(settings.buttonColorRed,settings.buttonColorGreen,settings.buttonColorBlue)
         buttonBg:alpha(settings.buttonAlpha)
         buttonBg:size(settings.buttonSizeX,settings.buttonSizeY)
         buttonBg:draggable(false)
         buttonBg:pos(buttonX, buttonY)
         buttonExtentsX, ButtonExtentsY = buttonBg:get_extents()

         -- Create button text line 1
         buttonText_1 = texts.new(buttonData[1])
         buttonText_1:bg_visible(false)
         buttonText_1:size(settings.buttonTextSize1)
         buttonText_1:stroke_alpha(100)
         buttonText_1.draggable = false
         textExtentsX_1, textExtentsY_1 = buttonText_1:extents()
         --buttonText_1:pos(buttonX, buttonY)

         -- Create button text line 2
         if not (buttonData[2] == nil) then
            buttonText_2 = texts.new(buttonData[2])
            buttonText_2:bg_visible(false)
            buttonText_2:size(settings.buttonTextSize2)
            buttonText_2:stroke_alpha(100)
            buttonText_2.draggable = false
            textExtentsX_2, textExtentsY_2 = buttonText_2:extents()
            --buttonText_2:pos(buttonX, buttonY + lineYOffset)
         end

         -- Center text lines horizontally and vertially
         textOffsetX_1 = ((buttonExtentsX - buttonX) - textExtentsX_1) / 4
         textOffsetY_1 = ((ButtonExtentsY - buttonY) - (textExtentsY_1 + textExtentsY_2)) / 4
         buttonText_1:pos(buttonX + textOffsetX_1, buttonY + textOffsetY_1)

         
         if not (buttonData[2] == nil) then
            textOffsetX_2 = ((buttonExtentsX - buttonX) - textExtentsX_2) / 4
            textOffsetY_2 = textOffsetY_1 + lineYOffset
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
   GetBarsXML()
   BuildActionBar()
   ChangeCursorColor()
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