# RAILS HELPEX
[На головну](../../README.md)

## Rails design patterns
* Service
  * відповідає лише за одну річ
* Value object
  * простий клас, який відповідатиме за надання методів, які повертають лише значення
  * простий об'єкт для зберігання величин, з логікою для порівняння або ще якоюсь логікою
* Presenter
  * між контролером і в'юхою, в нього запихується логіка для в'юхи
* Decorator
  * змінює початковий клас, не впливаючи на поведінку вихідного класу
* Builder
  * забезпечити простий спосіб повернення даного класу або екземпляра залежно від випадку
* Form object
  * винести логіку або валідацію з моделі, стосується створення, редагування, тощо
* Policy object
  * винести логіку з моделі, що не стосується безпосередньо моделі, перевірки умов перед діями
* Query object
  * винести додаткові опції sql запиту в окремий клас, один клас - одне бізнес-правило
* Observer
  * дозволяє виконувати задану дію щоразу, коли подія викликається на моделі (при створенні юзера - писать лог)
* Interactor
  * є послідовність дій, котра припиняється, коли десь fail, також є можливість ролбеку
* Null object
  * схожі на Value object - надати значення для неіснуючих записів, типу обробка empty values

## Installation flow
* Resources
  * https://rvm.io/
  * https://gorails.com/setup/ubuntu/20.04#ruby-rvm
* Install related things:
  * `sudo apt install curl` 
  * `sudo apt-get install -y gnupg2`
  * `sudo apt-get update`
  * `curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -`
  * `curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -`
  * `echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee`
  * `/etc/apt/sources.list.d/yarn.list`
  * `sudo apt-get update`
  * `sudo apt-get install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn`
* Add keys, to confirm sources:
  * `gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB`
* Install RVM
  * `\curl -sSL https://get.rvm.io | bash -s stable`
* Reload env vars
  * `source ~/.rvm/scripts/rvm`
* Install Ruby
  * `rvm install 3.0.2`
  * `rvm use 3.0.2 --default`
* Install Bundler
  * `Gem install bundler`
* Move to the project folder:
  * `cd project01`
* Create empty Gemfile:
  * `bundle init`
* Install gems
  * `bundle install`
* Install Rails
  * `gem install rails`
* Create new app
  * `rails new my_app`
* Cleanup/recompile frontend
  * `bin/rails assets:clobber`
  * `bin/rails webpacker:compile`
