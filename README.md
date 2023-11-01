## MyV&A 

MyV&A is a website where users can view collections from the V&A API archive. They can search the archive, view random artefacts and save artefacts to their own collection.
This project was created to practice using APIs and formatting data with CSS styling.

<img src="/Site-screenshot" style="width: 100vh; height: auto;"/>

### Tech

Design: Excalladraw, Figma
Planning: Trello
languages: Ruby, HTML, JavaScript
Gems: sinatra, webrick, rspec, httparty
Server: rack-test

#### Useful links

V&A developer site: https://developers.vam.ac.uk
V&A API guide: https://developers.vam.ac.uk/guide/v2/quick-start.html
V&A API blog post: https://www.vam.ac.uk/blog/digital/va-launches-new-developer-api
Introduction of integrating API data into websites: https://programminghistorian.org/en/lessons/introduction-to-populating-a-website-with-api-data
JSON visualiser: https://jsonviewer.stack.hu 

### Run the project

```shell
# This assumes you have Ruby & RVM installed. If you don't, visit:
# https://rvm.io/ to install RVM.

# Install gem dependencies 
$ bundle install

# Start the server
$ rackup

In your browser, visit `http://localhost:9292` 
```


### Potential improvements

- Option to remove artefacts from my collection
- Option to display images from my collection as an image gallery
- Add friends to view their collection
- Multiple collections
- Search filtering for different art mediums


Copyright compliance:
© Victoria and Albert Museum, London
