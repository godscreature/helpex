# Md syntax
[На головну](../README.md)


## Break line
* пишемо 3 мінуси
---


## Code
* пишемо лапки `nano`


## Code block
> code
> 
> next line in code
>> code in code


## Code block
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
* [Список кодів](https://gist.github.com/rxaviers/7360908)


## Font
* Це *курсив*
* Це **жирний** 
* Це ***курсив і жирний***
* Це ~~перекреслений~~


## Headers
# Привіт
## Привіт
### Привіт
#### Привіт
##### Привіт
###### Привіт


## Header link
* Робиться як звичний лінк, але url пишеться з самого заголовка:
  * Lowercase
  * Пробіли, крапки заміняються на мінус
  * Кілька мінусів підряд - заміняються на 1 мінус
  * Наприклад: `My header` -> `#my-header`


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
