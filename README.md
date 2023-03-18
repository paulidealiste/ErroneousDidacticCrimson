# ErroneousDidacticCrimson

A randomizer of personal names and surnames, with web-scapper, a database, a dedicated web app, a simple cli interface and a ton of fun. Hmm, I think I already have one github repo for an erroneous-type app...but let's say the crimson beats the blue.

# Rationale

Not just for generating spoof names, this app is meant to be uses with multiple, many, a plethora of name/surnames sources from all over the world of internet and beyond. By combining the seemingly disparate sources of names it is easy to forge new and exciting names, previously unthinked of, transcending all the boundaries, both of space and time.

## Enter Ruby
This is a Ruby app so any sensible ruby > 3.x along with some wonderful gems are required.  
```bash
bundle install
```
File *edc.rb* is a sort-of-entry-point and as simple cli. All options are visible with --help flag
```bash
ruby ./bin/edc.rb -h
Hello and welcome. This app is used like profspof [options].
    -s, --scrape                     Web scraping from the pre-configured targers to stdout.
    -c, --csv=PATH                   Read in one csv data file from the specified PATH to stdout.
    -d, --database                   Start simplified database REPL.
    -w, --webapp                     Start dedicated localhost webapp.
```

## Web scraper
It is a configurable web scraper, for fetching names and surnames from various web sources. It is controlled via .yml configuration file from ./lib/config/scraper.yml. Each entry under targets has the form of:
```yaml
    - name: French names # The name of the collection
      slug: ffn # The slug used internally for labeling
      type: NAMES # Can be either NAMES of SURNAMES
      content:
        - address: https://en.wikipedia.org/w/index.php?title=Category:French_feminine_given_names&pageuntil=Paule+%28name%29#mw-pages # Web page
          selectors: # A list of CSS selectors used for extracting the names
            - .mw-category-group ul li > a 
          regexp: ^\S* # A regex that will be applyed on the HTML result from the CSS selector
```
Note that there can be multiple addresses under content, as well as multiple collections overall.

## Database
A simple database REPL enables the following options:
```bash
connect - connects to an existing or creates a new database
from_scrape - perform web scraping with preconfigured targerts and store the the results
from_csv [path slug description] - read csv file and store the results as NAMES or SURNAMES
retreive [n] - retreive n randomized name/surname pairs
stats - print some database statistics
quit - quit this repl and disconnect from the database
help - prints this help
```
Please note that database should be connected or created first via connect, and that it will be created in the project's root if it does not exist. Database can be populated either *from_scrape* or *from_csv*. The most interesting and raison d'etre is the function *retreive* which takes n randomly connected names and surnames from the database and prints them. 

## Web app
Simple Sinatra webapp to show the randomized, fictional, crazy and didactic NAME/SURNAME pairs, i.e. some interesting non-existent or accidentally existen people's names. It can be accessed via localhost.