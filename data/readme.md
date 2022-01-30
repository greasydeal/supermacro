- Use `(character name).xml` to assign global bar profiles to your characters.
- Use `(character name)_(job).xml` or `(character name)_(job)_(subjob).xml` to assign job specific bar profiles to your characters.
- Substitude `(character name)` with the actual names of your characters.
- Substitude `(job)` and `(subjob)` with their respective 3 character abbrivation. `EXAMPLE: WAR,THF,WHM,MNK`
- If either a global or job specific `.xml` file does not exist for your character/job at the time of load one will be generated.
- SuperMacro will always attempt to load a global and job specific profile for the character. 
- Action bars from both profiles will be added to the character's screen with the job specific bars on top.
- These files must be formatted correctly or else they will not load.

- Format as follows:

```xml
<bars>
    <bar>SomeFile.xml</bar>
    <bar>SomeOtherFile.xml</bar>
    <bar>SubDirectory/SomeFile.xml</bar>
</bars>
```

- The above code would add (3) action bars. 
- Each `<bar>` element nested within the `<bars>` element will add an action bar for the character.
- The value within a `<bar>` element should be an `.xml` file that contains button data for the action bar. 
- Substitude `SomeFile.xml` and `SomeOtherFile.xml` in the code above with your actual file names.
- The buttons on the action bars are dictated by the contents of the referenced `.xml` file.
- The referenced `.xml` file needs to be stored under `/data/bars/` or a subdirectory of `/dat/bars/`.
- If the referenced `.xml` file is saved in a subdirectory of `/data/bars/` then the subdirectory must be included as well. `EXAMPLE: <bar>SubDirectory/SomeFile.xml</bar>`

- Refer to `/data/bars/example.xml`.