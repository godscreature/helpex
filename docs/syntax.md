# MD syntax
[На головну](../README.md)


## Break line
* use 3 minuses
---


## Code
* use quotes `nano`


## Code block
> code
> 
> next line in code
>> code in code


## Code blocks
    <title>Should start from 2 tabs</title>

## Code block + highlighting
```
{
    "first_name": "Bob",
    "last_name": "Dilan",
    "age": "100"
}
```
```json
{
    "first_name": "Bob",
    "last_name": "Dilan",
    "age": "100"
}
```
```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```


## Emoji
* Tent :tent: and :joy:
* [List of emoji codes](https://gist.github.com/rxaviers/7360908)


## Font
* This is *italic* font
* This is **bold** font 
* This is ***italic and bold*** font
* This is ~~strikethrough~~ font


## Headers
# Hi
## Hi
### Hi
#### Hi
##### Hi
###### Hi


## Highlight
* I need to highlight these ==very important words==


## Images
![title of image](../assets/image001.jpg)


## Link
* [Lol](https://google.com)


## List numbered
1. First
2. Second
3. Third
    1. Third.First
    2. Third.Second


## List unnumbered
- sdfip.
- sdfsdf.
  - sdlkfjh
  - sdlkfjasasdf


## Table and alignment
| Syntax | Description | Test |
|:-------|:-----------:|-----:|
| Header |    Title    |   Ok |
| Lol    |  Something  |  Box |


## Task list
- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media
