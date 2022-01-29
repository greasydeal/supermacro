- Use <<Character Name>>.xml to assign bar profiles to your characters.
- This file must be formatted correctly or else it will not load.
- Format as follows:

<bars>

    <CharacterName>
        <bar>SomeFile.xml</bar>
        <bar>SomeOtherFile.xml</bar>
    </CharacterName>

    <AnotherCharacterName>
        <bar>SomeFile.xml</bar>
        <bar>YetAnotherFile.xml</bar>
    </AnotherCharacterName>

</bars>

- Substitude CharacterName and AnotherCharacter for the actual names of your characters.
- Each <bar> element nested within a character element will add a action bar for that character.
- The value within a <bar> element should be an xml file that contains button data for the action bar. 
- The xml file referenced needs to be stored under /data/bars/ or a subdirectory of /dat/bars/
- If the xml file is saved in a subdirectory of /data/bars/ then the subdirectory but be included as well

- EXAMPLE: <bar>SubDirectory/SomeFile.xml</bar>

- Refer to /data/bars/example.xml for more information.