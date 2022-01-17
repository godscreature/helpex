# RAILS HELPEX
[На головну](../../README.md)

## ActiveRecord
* `destroy` vs `delete`
  * `delete`
    * просто намагається виконати `DELETE` запит до бази
    * не виконуючи ніяких інших ActiveRecord задач
    * повертає заморожений екземпляр
  * `destroy`
    * аналізує клас та визначає що має робитися для залежностей
    * перевірки робляться та колбеки
    * видаляє з бази запис
    * якщо якісь перевірки не проходять - видалення не відбувається і повертається `false`
* Завантаження даних асоціацій
  * `preload` - `User.preload(:posts).to_a`
    * грузить асоціації окремим реквестом
    * але ми не можемо умови дописати до вибірки асоціацй
  * `iuncludes` - `User.includes(:posts).where('posts.desc = "ruby is awesome"').to_a`
    * грузить асоціації окремим реквестом
    * використовує `LEFT OUTER JOIN`
  * `eagler_load` - `User.eager_load(:posts).to_a`
    * грузить усе одним реквестом
    * використовує `LEFT OUTER JOIN`
  * `joins` - `User.joins(:posts)`
    * використовує `INNER JOIN`
    * може призвести до дублювання в результатах
    * щоб запобігти дублюванню: `User.joins(:posts).select('distinct users.*').to_a`
* Active Model Dirty
  * Забезпечує спосіб відстеження змін у вашому об’єкті так же, як це робить Active Record
* в ActiveRecord можна писати таке:
  * асоціації
  * валідації
  * скопи
* Зв'язки
  * в Ruby є 6 типів зв'язків:
    * `belongs_to`
      * встановлює зв'язок **one-to-one**, однонаправлений
      * зв'язкова колонка створюється в цій моделі
      * якщо треба двонаправлений зв'язок - маємо використати `has_one` чи `has_many` на іншій моделі
      * на рівні бази треба додати (в міграції) `foreign_key: true`
    * `has_one`
      * встановлює зв'язок **one-to-one**
      * показує що в іншої моделі є лінк на цю модель
      * відмінність від `belongs_to` в тому, що зв'язкова колонка - в іншій моделі
      * на рівні бази треба зробити індекс унікальним і прописать зовнішній ключ `index: { unique: true }, foreign_key: true`
    * `has_many`
      * встановлює зв'язок **one-to-many**
      * ім'я моделі вказується в множині
      * часто ця штука буває на іншому кінці `belongs_to`
      * на рівні бази - робимо індекс `index: true` і можливо `foreign_key: true`
    * `has_many :through`
      * використовується для зв'язку **many-to-many** через третю модель:
        * User:
          * `has_many :user_books`
          * `has_many :books, through: :user_books`
        * Book:
          * `has_many :user_books`
          * `has_many :users, through: :user_books`
        * UserBook:
          * `belongs_to :user`
          * `belongs_to book`
      * також потрібна для настройки ярликів через вкладені зв'язки `has_many`:
        * Document
          * `has_many :sections`
          * `has_many :paragraphs, through: :sections`
        * Section
          * `belongs_to :document`
          * `has_many :paragraphs`
        * Paragraph
          * `belongs_to :section`
    * `has_one :through`
      * встановлює зв'язок **one-to-one** через третю модель
        * Supplier
          * `has_one :account`
          * `has_one :account_history, through: :account`
        * Account
          * `belongs_to :supplier`
          * `has_one :account_history`
        * AccountHistory
          * `belongs_to :account`
    * `has_and_belongs_to_many`
      * прямий зв'язок (без третьої моделі) **many-to-many**
        * Assembly
          * `has_and_belongs_to_many :parts`
        * Part
          * `has_and_belongs_to_many :assemblies`
  * `belongs_to` vs `has_one`
    * різниця в тому, де буде ключ, має бути в класі з `belongs_to`
    * також є структура - якщо пишемо `has_one`, то цій ентіті має щось належати
      * наприклад user<->address - юзерові належить адреса: user - `has_one`, address - `belongs_to`
  * `has_many :through` vs `has_and_belongs_to_many`
    * в обох випадках в базі буде додаткова таблиця
    * `has_many :through` треба використовувати, якщо треба працювати з моделлю зв'язків як з окремим об'єктом
      * якісь колбеки, валідації, або додаткові атрибути
  * Поліморфні зв'язки
    * модель може належати більше ніж одній моделі на одинарному зв'язку.
      * Picture
        * `belongs_to :imageable, polymorphic: true`
      * Employee
        * `has_many :pictures, as: :imageable`
      * Product
        * `has_many :pictures, as: :imageable`
    * в даному випадку `belongs_to` шось типу інтерфейса, це може використовувати будь-яка інша модель
    * в базі реалізовано - додатковими колонками `imageable_type` та `imageable_id`
  * Self-related
    * як наприклад категорія-підкатегорія або юзери з директор-підлеглий:
      * `has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"`
      * `belongs_to :manager, class_name: "Employee", optional: true`
    * в базі маємо додати стовбець - лінк моделі на саму себе
  * Кеш
    * методи зв'язків побудовані навколо кешованих результатів
      * `author.books` - дістане і закешує, потім це буде з кешу `author.books.size` або `author.books.empty?`
    * щоб перегрузити - треба заюзать `reload` - `author.books.reload.empty?`
  * Схема
    * для зв'язків `belongs_to` - треба створювати звонішні ключі за необхідності
    * для `has_and_belongs_to_many` - треба створювати таблицю зв'язку вручну (має бути створена без первинного ключа)
  * Область видимості
    * якщо моделі в одному модулі - все ок
    * якщо моделі в різних модулях - треба вказувати повне ім'я класу:
      * `has_one :account, class_name: "MyApplication::Billing::Account"`
      * `belongs_to :supplier, class_name: "MyApplication::Business::Supplier"`
  * Двонаправленість
    * якщо все дефолтно, то ActiveRecord - сам розрізняє двосторонність зв'язку
    * але якщо є опції `:through` або `:foreign_key` - то двонаправленість не буде автоматом
    * За допомогою `:inverse_of` можна явно вказати двонаправленість
      * Author: `has_many :books, inverse_of: 'writer'`
      * Book: `belongs_to :writer, class_name: 'Author', foreign_key: 'author_id'`

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

## RSpec
* `let` и `let!` - позволяет присваивать результат возврата блока переменной
  * эти переменные видны только в текущем `describe`
  * в последующих `let` можно использовать переменные из предыдущих
  * для присваивания значения используется memo-изация
  * это означает, что до обращения к переменной, блок переданный в let не будет исполнен
  * `let!` - если требуется обязательный вызов блока до выполнения тестов
* `allow` и `expect` - наприклад є метод, котрий буде викликатися
  * `allow` - припускає шо метод може не викликатися, але якшо викликається то перевіряється результат
  * `expect` - валить тест, якшо метод не викликається
  * `allow(SecondService).to receive(:call)` - просто мокає SecondService
  * `expect(SecondService).to receive(:call)` - мокає SecondService і перевіряє чи викликається, якщо ні - ексепшн

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
