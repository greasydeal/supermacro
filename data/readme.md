- Use `(character name).xml` to assign global bar profiles to your characters.
- Use `(character name)_(job).xml` or `(character name)_(job)_(subjob).xml` to assign job specific bar profiles to your characters.
- Substitude `(character name)` with the actual names of your characters.
- Substitude `(job)` and `(subjob)` with their respective 3 character abbrivation. EXAMPLE: WAR,THF,WHM,MNK
- If either a global or job specific xml does not exist for your character/job at the time of load one will be generated.
- These files must be formatted correctly or else they will not load.
- Format as follows:

```xml
<bars>
    <bar>SomeFile.xml</bar>
    <bar>SomeOtherFile.xml</bar>
</bars>
```

- Substitude `SomeFile.xml`, `SomeotherFile.xml`, and `YetAnotherFile.xml` with actual files.
- Each `<bar>` element nested within a character element will add a action bar for that character.
- The value within a `<bar>` element should be an xml file that contains button data for the action bar. 
- The xml file referenced needs to be stored under `/data/bars/` or a subdirectory of `/dat/bars/`.
- If the xml file is saved in a subdirectory of `/data/bars/` then the subdirectory must be included as well.

- EXAMPLE: `<bar>SubDirectory/SomeFile.xml</bar>`

- Refer to `/data/bars/example.xml` for more information.