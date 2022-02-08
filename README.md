# SuperMacro beta 0.1
SuperMacro is an addon for Windower 4 that provides a customizable macro palette when the "Win" key is pressed. Each character can have multiple global and job specific macro bars displayed at one time.

## Installing SuperMacro

- The contents of this repository need to be copied to `(WindowerInstallPath)/addons/supermacro`.
    
## Loading SuperMacro

 - SuperMacro can be loaded by typing `//lua load supermacro` into the FFXI chat input or by typing `lua load supermacro` directly into the Windower console.

 - `//lua reload supermacro` will reload SuperMacro

## Setting Up SuperMaco
 - ### Profiles

    - The first time SuperMacro is loaded on a character it will generate a global profile `.xml` file named `(CharacterName).xml` under the `/data/profiles` folder. It will also generate a job specific profile `.xml` file named `(CharacterName)_(JOB).xml` under the `/data/profiles/` folder.

        - By default these files will contain (1) `<bar>` element referencing the default macro bar `.xml` file.

    - Profile `.xml` files will contain `<bar>` elements that reference macro bar `.xml` files.

    - The character's global and job specific profiles `.xml` files will both be used to create your custom macro palette. Each bar will stack on above previous bar starting with the globar bars and ending with job specific bars. For example, a global profile with 2 bars and a job specific profile with 1 bar would create the following layout on screen:

        ```
        [JOB SPECIFIC BAR #1]
        [   GLOBAL BAR #2   ]
        [   GLOBAL BAR #1   ]
        ```

    - You can add more bars to a profile by adding `<bar>` elements to the character's profile `.xml` file. `EXAMPLE: <bar>SomeBarFile.xml</bar>`.

    - EXAMPLE CODE: 
        - (CharacterName).xml or (CharacterName_JOB).xml
            ```xml
            <bars> <!-- Open the bar element - REQUIRED -->
                <bar>SomeFile.xml</bar> <!-- Creates a macro bar from data in SomeFile.xml -->
                <bar>SomeOtherFile.xml</bar> <!-- Creates another macro bar using SomeOtherFile.xml -->
                <bar>SubDirectory/SomeFile.xml</bar> <!-- Subdirectory example -->
            </bars> <!-- Close the bar element - REQUIRED -->
            ```

        - NOTE: Comments in the `.xml` will cause cause it to not load property. Do not use comments in your `.xml` file. The comments in the example above are for educational purposes only.

    - Reload SuperMacro to make changes to profile `.xml` files take effect.

    - <a href='https://github.com/greasydeal/supermacro/tree/main/data/profiles'>Click here</a> for more information on setting up profiles.

- ### Macro Bars

    - Macro bar `.xml` files are stored in `/data/bars` and can be named whatever you like so long as they have a `.xml` file extension.
    
    - Macro bar `.xml` files are referenced in profile `.xml` files to give the addon the data required to build your custom macro palette.

    - Unlike profiles, macro bar `.xml` files are not automatically generated.

        - To generate a new macro bar `.xml` file use `//sm create bar (FileName)`

            - A new macro bar template will be generated with the given file name with enough button elements to match your `<buttonCount>` element in your `/data/settings.xml` file.

            - Once the new macro bar `.xml` file is generated you will need to edit the file using your favorite text editor. 

            - Reload SuperMacro to make changes to macro bar `.xml` files take effect.
    
    - Macro bar `.xml` files are formatted as follows:

        ```xml
        <bar>
            <1> <!-- Button #1 open -->
                <text1>Example 1</text1> <!-- Button text line 1 -->
                <text2>Button 1</text> <!-- Button text line 2 -->
                <action>/echo test 1</action> <!-- Action performed -->
                <modAction>/echo modified test 1</modAction> <!-- Action performed in modified mode -->
                <modText1></modText1> <!-- Unused at this time -->
                <modText2></modText2> <!-- Unused at this time -->
            </1> <!-- Button #1 close -->
            <2> <!-- Button #2 open -->
                <text1>Example 1</text1>
                <text2>Button 2</text>
                <action>/echo test 2</action>
                <modAction>/eacho modified test 2</modAction>
                <modText1></modText1>
                <modText2></modText2>
            </2> <!-- Button #2 close -->
        </bar>
        ```

        - NOTE: Comments in the `.xml` will cause cause it to not load property. Do not use comments in your `.xml` file. The comments in the example above are for educational purposes only.
    
    - Each macro bar `.xml` file will only contain one `<bar>` element. 
        
        - Nested within the `<bar>` element will be a series of button elements. These elements will be named the corrisponding button number. 

    - Each button element will contain 1 of each of the following elements:

        - `<text1>` - This will be the first (top) line of text on the macro button.

        - `<text2>` - This will be the second (bottom) line of text on the macro button. 

        - `<action>` - This will be the action that is performed when the macro button is triggered. This will take commands that would be used in the FFXI chat input. (NOT WINDOWER CONSOLE COMMANDS. If you want to use windower console commands in your macros use // or /con preceding the command.)

        - `<modAction>` - This is the action that is performed when the macro button is triggered while in modified mode (\`).

        - `<modText1>` - Currently not used.

        - `<modText2>` - Currently not used.

- ## Customizing SuperMacro

    - The first time you load SuperMacro it with generate `settings.xml` under the `/data` folder. This file can be edited in your favorite text editor to cusomize the look of SuperMacro. Reload SuperMacro to make changes to this file take effect.

    - `settings.xml` will contain the following elements, all of which can be customized:

         - `<buttonAlpha>` - Range 0-255. Controls the alpha of the button background. `(Default: 255)`

         - `<buttonColor(Blue/Green/Red)>` - Range 0-255. Controls the color values Blue, Green, and Red respectively of the button background. `(Defaults: 0/0/0)`

         - `<buttonCount>` - Range 1-16. Controls the number of buttons displayed per macro bar. This is the number of buttons that will be displayed regardless of the number of button elements in your macro bar `.xml` file. `(Default: 10)`

         - `<buttonSize(X/Y)>` - Range 1-500. Controls X and Y size dimensions respectively of all macro buttons. `(Default: 60/45)`

         - `<buttonTextAlpha>` - Range 0-255. Controls the alpha of all button text. `(Default: 0)`

        - `<buttonText(Blue/Green/Red)>` - Range 0-255. Controls the color values Blue, Green, and Red respectively of the button text. `(Default: 0/0/0)`

        - `<buttonTextCharLimit(1/2)>` - Range 1-255. Controls aximum number of characters that will be displayed on lines 1 and 2 respectively. `(Default: 10/10)`

        - `<buttonTextSize(1/2)>` - Range 1-48. Controls font size of text lines 1 and 2 respectively. `(Default: 10/12)`

        - `<cursorAlpha>` - Range 0-255. Controls the alpha of the selected button's background. `(Default: 255)`

        - `<cursorColor(Blue/Green/Red)>` - Range 0-255. Range 0-255. Controls the color values Blue, Green, and Red respectively of the selected button's background. `(Defaults: 0/0/100)`

        - `<mCursorAlpha>` - Range 0-255. Controls the alpha of the selected button's background when in modified mode. `(Default: 255)`

        - `<mCursorColor(Blue/Green/Red)>` - Range 0-255. Range 0-255. Controls the color values Blue, Green, and Red respectively of the selected button's background when in modified mode. `(Defaults: 0/100/0)`

        - `<pos(X/Y)>` - Controls the position of the macro palette. The origin point of the palette is the bottom left corner of the first button of the bottom macro bar.

        - `<spacing(X/Y)>` - Controls the X and Y spacing respectively between macro buttons.

- ## Commands

    - `//supermacro create bar (FileName).xml` - This will create an empty macro bar `.xml` template with the given file name.

    - `//supermacro reload` - Reloads the addon

