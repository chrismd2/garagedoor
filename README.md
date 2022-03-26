# Garagedoor

Start in ```iex -S mix``` to test
  * Most actions require a valid access_code to be executed
    - default access_code after ```Garagedoor.Door.init``` is 19999

Testing use-cases after running ```Garagedoor.Door.init```
  1. View current door state, and how long its been in that state, and who set the state
    - ```Garagedoor.state```
      > {"open", 6, "init"}

  2. Open door with an access code
    - ```Garagedoor.open(19999)```
      > "Door already open"

      > true

  3. Close door with an access code
    - ```Garagedoor.close(19999)```
      > true

      > "Door already closed"

  4. Create a door access code, with associated person metadata
    - ```Garagedoor.new_code("tester", 19999)```
      > %{access_code: 27254, id: 2, name: "tester", used_count: 0}

  5. Remove a door access code
    - ```Garagedoor.remove_code("init", 27254)```
      > true

  6. View how many times an access code is used
    - ```Garagedoor.used_count(27254)```
      > 3
