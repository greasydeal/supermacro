# SuperMacro beta 0.1
SuperMacro is an addon for Windower 4 that provides a customizable macro palette when the "Win" key is pressed. Each character can have multiple global and job specific macro bars displayed at one time.

## Installing SuperMacro

- The contents of this repository need to be copied to `(WindowerInstallPath)/addons/supermacro`.
    
## Loading SuperMacro

 - Super macro can be loaded by typing `//lua load supermacro` into the FFXI chat input or by typing `lua load supermacro` directly into the Windower console.

## Using SuperMaco
 - ### Profiles

    - The first time SuperMacro is loaded on a character it will generate a global profile `.xml` file named `(CharacterName).xml` under the `/data/profiles` folder. It will also generate a job specific profile `.xml` file named `(CharacterName)_(JOB).xml` under the `/data/profiles/ folder.

        - By default these files will contain (1) `<bar>` element referencing the default macro bar `.xml` file.

    - Profile `.xml` files will contain `<bar>` elements that reference macro bar `.xml` files.

    - The character's global and job specific profiles `.xml` files will both be used to create your custom macro palette. Each bar will stack on above previous bar starting with the globar bars and ending with job specific bars. For example, a global profile with 2 bars and a job specific profile with 1 bar would create the following layout on screen:

        ```
        [JOB SPECIFIC BAR #1]
        [   GLOBAL BAR #1   ]
        [   GLOBAL BAR #2   ]
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

    - <a href='https://github.com/greasydeal/supermacro/tree/main/data/profiles'>Click here</a> for more information on setting up profiles.

- ### Macro Bars

    - Macro bar `.xml` files are stored in `/data/bars` and can be named whatever you like so long as they have a `.xml` file extension.
    
    - Macro bar `.xml` files are referenced in profile `.xml` files to give the addon the data required to build your custom macro palette.

    - Unlike profiles, macro bar `.xml` files are not automatically generated.

        - To generate a new macro bar `.xml` file use `//sm create bar (FileName)`

            - A new macro bar template will be generated with the given file name with enough button elements to match your `<buttonCount>` element in your `/data/settings.xml` file.

            - Once the new macro bar `.xml` file is generated you will need to edit the file using your favorite text editor.
    
    - Macro bar `.xml` files are formatted as follows:

        ```xml
        <bar>
            <1> <!-- Button #1 open -->
                <text1>Example 1</text1> <!-- Button text line 1 -->
                <text2>Button 1</text> <!-- Button text line 2 -->
                <action>/echo test 1</action> <!-- Action performed -->
                <modAction></modAction> <!-- Action performed in modified mode -->
                <modText1></modText1> <!-- Unused at this time -->
                <modText2></modText2> <!-- Unused at this time -->
            </1> <!-- Button #1 close -->
            <2> <!-- Button #2 open -->
                <text1>Example 1</text1>
                <text2>Button 2</text>
                <action>/echo test 2</action>
                <modAction></modAction>
                <modText1></modText1>
                <modText2></modText2>
            </2> <!-- Button #2 close -->
        </bar>
        ```
        
        - NOTE: Comments in the `.xml` will cause cause it to not load property. Do not use comments in your `.xml` file. The comments in the example above are for educational purposes only.
        

