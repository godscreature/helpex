## ACTIVE RECORD HELPEX
[На головну](/README.md)
[На Ruby](index.md)

## `destroy` vs `delete`
* `delete`
  * просто намагається виконати `DELETE` запит до бази
  * не виконуючи ніяких інших ActiveRecord задач
  * повертає заморожений екземпляр
* `destroy`
  * аналізує клас та визначає що має робитися для залежностей
  * перевірки робляться та колбеки
  * видаляє з бази запис
  * якщо якісь перевірки не проходять - видалення не відбувається і повертається `false`

## Завантаження даних асоціацій
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

## Зв'язки

### в Ruby є 6 типів зв'язків:

#### 1. `belongs_to`
* встановлює зв'язок **one-to-one**, однонаправлений
* зв'язкова колонка створюється в цій моделі
* якщо треба двонаправлений зв'язок - маємо використати `has_one` чи `has_many` на іншій моделі
* на рівні бази треба додати (в міграції) `foreign_key: true`
* Зразу додається пачка **методів**, де `association` замінюється на переданий символ:
  * `association` - повертає зв'язаний об'єкт, якщо він є `@author = @book.author` - замість association - author
    * якщо об'єкт вже отримано - повертається з кешу, щоб це змінити - `@author = @book.reload_author`
  * `association=(associate)` - прив'язує зв'язаний об'єкт. Фактично - бере первинний ключ і пише його у звонішній ключ
    * `@book.author = @author`
  * `build_association(attributes = {})` - повертає новий зв'язаний об'єкт. Створює, зв'язує, але не зберагіє, приклад:
    * `@author = @book.build_author(author_number: 123, author_name: "John Doe")`
  * `create_association(attributes = {})` - повертає новий зв'язаний об'єкт. Створює, зв'язує і зберагіє, якщо пройдуть валідації приклад:
    * `@author = @book.create_author(author_number: 123, author_name: "John Doe")`
  * `create_association!(attributes = {})` - теж саме, що і `create_association`, але дає `ActiveRecord::RecordInvalid`, якщо не проходять валідації
  * `reload_association` - загружений об'єкт попадає в кеш, шоб рефрешнути використовується цей метод
  * `association_changed?` - повертає `true`, якщо назначений новий зв'язаний об'єкт і зовнішній ключ буде оновлено при наступному зберіганні
    * > @book.author # => #<Book author_number: 123, author_name: "John Doe">
      >
      > @book.author_changed? # => false`
      >
      > @book.author = Author.second # => #<Book author_number: 456, author_name: "Jane Smith">
      >
      > @book.author_changed? # => true
      >
      > @book.save!
      >
      > @book.author_changed? # => false
  * `association_previously_changed?` - повертає `true`, якщо пепереднє зберігання оновило зв'язок:
    * > @book.author # => #<Book author_number: 123, author_name: "John Doe">
      >
      > @book.author_previously_changed? # => false
      >
      > @book.author = Author.second # => #<Book author_number: 456, author_name: "Jane Smith">
      >
      > @book.save!
      >
      > @book.author_previously_changed? # => true
* В цьому зв'язку є такі **опції**
  * `:autosave`
    * `true` - все зберігається при збереженні основного об'єкту
    * `false` - не буде зберігати зв'язані об'єкти
    * не вказане - нові зв'язані об'єкти збережуться, оновлені - ні
  * `:class_name` - вказати назву класу, якщо його не можна прочитати з назви зв'язку
  * `:counter_cache`
    * якщо не вказано - то `@author.books.size` буде юзать `COUNT(*)`
    * `true` або назву нового стовпця - значення буде зберігатися в кеші і повертатися при виклику `size`
    * фактично цей віртуальний стовпець буде у моделі, де прописано `has_many`, хоча в коді - ця опція - у `belongs_to`
  * `:dependent`
    * `:destroy` - коли об'єкт видаляється, `destroy` викликається на його зв'язаних об'єктах
    * `:delete` - коли об'єкт видаляється, всі його зв'язані об'єкти зразу видаляються тупо з бази, без виклику `destroy`
    * `:destroy_async`
      * при видаленні об'єкту завдання `ActiveRecord::DestroyAssociationAsyncJob` ставиться в чергу, котре викличе `destroy` на зв'язаних
      * має стояти Active Job
  * `:foreign_key` - дозволяє встановити назву зовнішнього ключа, за замовчуванням - ім'я моделі + суфікс `_id`
  * `:primary_key`
    * дозволяє встановити назву первинного ключа, дефолтно `id`
    * User: `self.primary_key = 'guid' # primary key is guid and not id`
    * Todo: `belongs_to :user, primary_key: 'guid'`
    * при виконанні `@user.todos.create`. в об'єкта `@todo` буде значення `user_id` таке ж, як значенння `quid` у `@user`
  * `:inverse_of`
    * визначає назву зв'язку `has_many` або `has_one`, що протилежна до цього зв'язку
    * Author: `has_many :books, inverse_of: :author`
    * Book: `belongs_to :author, inverse_of: :books`
  * `:polymorphic` - якщо `true` - то це поліморфний зв'язок
  * `:touch`
    * якщо `true` або вказана назва атрибуту, то часові мітки `updated_at` чи `updated_on` на зв'язаному об'єкті будуть встановлені в поточний час кожного разу при збереженні або видаленні зв'язка
  * `:validate`
    * якщо `true`, то при збереженні основного об'єкту, зв'язані - проходять валідацію
  * `:optional` - якщо `true` - наявність зв'язаних об'єктів не валідується
* В цьому зв'язку є такі **скоупи**
  * `where` - `belongs_to :author, -> { where active: true }`
  * `includes`
    * можна юзать для визначення зв'язків 2го порядку, котрі мають ліниво грузитись при використанні цього зв'язку
    * якщо часто отримую авторів з розділів `@chapter.book.author`, то можна так:
    *        class Chapter < ApplicationRecord
               belongs_to :book, -> { includes :author }
             end
                 
             class Book < ApplicationRecord
               belongs_to :author
               has_many :chapters
             end

             class Author < ApplicationRecord
               has_many :books
             end
  * `readonly` - зв'язаний об'єкт буде тільки для читанння при отриманні через зв'язок
  * `select`
    * перевизначення SQL виразу SELECT, за замовчуванням - всі колонки
    * при юзанні `select` на `belongs_to` треба прописать `foreign_key` для гарантії правильних результатів

#### 2. `has_one`
* встановлює зв'язок **one-to-one**
* показує що в іншої моделі є лінк на цю модель
* відмінність від `belongs_to` в тому, що зв'язкова колонка - в іншій моделі
* на рівні бази треба зробити індекс унікальним і прописать зовнішній ключ `index: { unique: true }, foreign_key: true`
* Зразу додається пачка **методів**, де `association` замінюється на переданий символ:
  * `association` - повертає зв'язаний об'єкт (або `nil`), якщо він є `@author = @book.author` - замість association - author
    * якщо об'єкт вже отримано - повертається з кешу, щоб це змінити - `@author = @book.reload_author`
  * `association=(associate)` - прив'язує зв'язаний об'єкт. Фактично - бере первинний ключ і пише його у звонішній ключ
    * `@book.author = @author`
  * `build_association(attributes = {})` - повертає новий зв'язаний об'єкт. Створює, зв'язує, але не зберагіє, приклад:
    * `@author = @book.build_author(author_number: 123, author_name: "John Doe")`
  * `create_association(attributes = {})` - повертає новий зв'язаний об'єкт. Створює, зв'язує і зберагіє, якщо пройдуть валідації приклад:
    * `@author = @book.create_author(author_number: 123, author_name: "John Doe")`
  * `create_association!(attributes = {})` - теж саме, що і `create_association`, але дає `ActiveRecord::RecordInvalid`, якщо не проходять валідації
  * `reload_association` - загружений об'єкт попадає в кеш, шоб рефрешнути використовується цей метод
* В цьому зв'язку є такі **опції**
  * `:as` - показує, що це поліморфний зв'язок
  * `:autosave`
    * `true` - все зберігається при збереженні основного об'єкту
    * `false` - не буде зберігати зв'язані об'єкти
    * не вказане - нові зв'язані об'єкти збережуться, оновлені - ні
  * `:class_name` - вказати назву класу, якщо його не можна прочитати з назви зв'язку
  * `:dependent`
    * `:destroy` - коли об'єкт видаляється, `destroy` викликається на його зв'язаних об'єктах
    * `:delete` - коли об'єкт видаляється, всі його зв'язані об'єкти зразу видаляються тупо з бази, без виклику `destroy`
    * `:destroy_async`
      * при видаленні об'єкту завдання `ActiveRecord::DestroyAssociationAsyncJob` ставиться в чергу, котре викличе `destroy` на зв'язаних
      * має стояти Active Job
    * `:nullify` - зовнішній ключ буде встановлено в NULL, для поліморфного зв'язку теж, колбеки не викликаються
    * `:restrict_with_exception` - призведе до виключення `ActiveRecord::DeleteRestrictionError`, якщо є зв'язаний об'єкт
    * `:restrict_with_error` - паризведе до помилки, доданої до власника, якщо є зв'язаний об'єкт
  * `:foreign_key` - дозволяє встановити назву зовнішнього ключа, за замовчуванням - ім'я моделі + суфікс `_id`
  * `:primary_key`
    * дозволяє встановити назву первинного ключа, дефолтно `id`
    * User: `self.primary_key = 'guid' # primary key is guid and not id`
    * Todo: `belongs_to :user, primary_key: 'guid'`
    * при виконанні `@user.todos.create`. в об'єкта `@todo` буде значення `user_id` таке ж, як значенння `quid` у `@user`
  * `:inverse_of`
    * визначає назву зв'язку `has_many` або `has_one`, що протилежна до цього зв'язку
    * Author: `has_many :books, inverse_of: :author`
    * Book: `belongs_to :author, inverse_of: :books`
  * `:source` - визначає назву джерела зв'язку для зв'язку `has_one :through`
  * `:source_type`
    * визначає назву джерела зв'язку для зв'язку `has_one :through`, при поліморфному зв'язку
    *     class Author < ApplicationRecord
            has_one :book
            has_one :hardback, through: :book, source: :format, source_type: "Hardback"
            has_one :dust_jacket, through: :hardback
          end

          class Book < ApplicationRecord
            belongs_to :format, polymorphic: true
          end

          class Paperback < ApplicationRecord; end

          class Hardback < ApplicationRecord
            has_one :dust_jacket
          end

          class DustJacket < ApplicationRecord; end
  * `:through` - визначає поєднуючу модель, через котру виконується запрос
  * `:touch`
    * якщо `true` або вказана назва атрибуту, то часові мітки `updated_at` чи `updated_on` на зв'язаному об'єкті будуть встановлені в поточний час кожного разу при збереженні або видаленні зв'язка
  * `:validate`
    * якщо `true`, то при збереженні основного об'єкту, зв'язані - проходять валідацію
* В цьому зв'язку є такі **скоупи** - такі ж самі як і в `belongs_to`
* Збереження
  * якщо основний об'єкт новий, не зебережений ще, то зв'язки не зберігаються, але автоматом збережуться при збереженні основного
  * якщо основний об'єкт не новий, то коли я назначаю об'єкт зв'язком `has_one` - відбувається збереження
  * а якщо при цьому не проходить валідація - то призначення відміниться і буде повернуто `false`
  * якщо я хочу призначити об'єкт через `has_one` і не зберігати його - треба юзать `build_association`

#### 3. `has_many`
* встановлює зв'язок **one-to-many**
* ім'я моделі вказується в множині
* часто ця штука буває на іншому кінці `belongs_to`
* на рівні бази - робимо індекс `index: true` і можливо `foreign_key: true`
* Зразу додається пачка **методів**, де `collection` замінюється на переданий перший аргумент в `has_many`, а `collection_singular` - на версію в однині, будемо писати методи для `has_many :books`
  * `books` - повертає Relation всіх зв'язаних об'єктів
  * `books<<(object, ...)` - додає 1 або більше
  * `books.delete(object, ...)` - видаляє 1 або більше, встановлюючи їх зовнішні ключі в `NULL`
  * `books.destroy(object, ...)` - видаляє 1 або кілька, виконуючи `destroy` для кожного
  * `books=(objects)` - робить колекцію включаючою тільки задані об'єкти
  * `book_ids` - повертає масив id об'єктів
  * `book_ids=(ids)` - робить колекцію включаючою тільки задані об'єкти, але за допомогою id
  * `books.clear`
    * прибирає кожен об'єкт з колекції відповідно до стратегії, визначеної опцією `dependent`
    * якщо не визначено - то по замовчуванню
      * для `has_many :through` - це `delete_all`
      * для `has_many` - встановити зовнішні ключі в `NULL`
  * `books.empty?` - повертає `true`, якщо в колекції немає об'єктів
  * `books.size` - повертає кількість об'єктів в колекції
  * `books.find(...)` - шукає об'єкти в таблиці колекції
  * `books.where(...)`
    * шукає об'єкти в таблиці колекції, базуючись на переданих умовах, загрузка лінива - виконання SQL тільки коли звернення до об'єкту
    * > @available_books = @author.books.where(available: true) # Поки немає ріквесту
      >
      > @available_book = @available_books.first # Тепер база даних буде запрошена
  * `books.exists?(...)` - перевіряє, чи існує об'єкт в колекції, що відповідає умовам
  * `books.build(attributes = {}, ...)`
    * повертає 1 або масив об'єктів зв'язаного типу
    * об'єкти - екземпляри з переданими атрибутами
    * буде створено лінк через їх зовнішні ключі, але зв'язані об'єкти не будуть поки збережені
  * `books.create(attributes = {})`
    * повертає 1 або масив нових об'єктів зв'язаного типу
    * об'єкти - екземпляри з переданими атрибутами
    * буде створено лінк через їх зовнішні ключі, і якщо зв'язані об'єкти пройдуть валідацію вони будуть збережені
  * `books.create!(attributes = {})` - працює так само, окрім того, викликає `ActiveRecord::RecordInvalid`, якщо валідація не пройдена
  * `books.reload` - повертає Relation всіх зв'язаних об'єктів, примусово читаючи БД. Якщо об'єктів немає - повертає пустий Relation
* В цьому зв'язку є такі **опції**
  * `:as` - показує, що це поліморфний зв'язок
  * `:autosave`
    * `true` - все зберігається при збереженні основного об'єкту
    * `false` - не буде зберігати зв'язані об'єкти
    * не вказане - нові зв'язані об'єкти збережуться, оновлені - ні
  * `:class_name` - вказати назву класу, якщо його не можна прочитати з назви зв'язку
  * `:counter_cache` - використовується для настройки кастомного `:counter_cache`. Використовувати тільки якщт замінена назва `:counter_cache` у `belongs_to`
  * `:dependent`
    * `:destroy` - коли об'єкт видаляється, `destroy` викликається на його зв'язаних об'єктах
    * `:delete_all` - коли об'єкт видаляється, всі його зв'язані об'єкти зразу видаляються тупо з бази, без виклику `destroy`
    * `:destroy_async`
      * при видаленні об'єкту завдання `ActiveRecord::DestroyAssociationAsyncJob` ставиться в чергу, котре викличе `destroy` на зв'язаних
      * має стояти Active Job
    * `:nullify` - зовнішній ключ буде встановлено в NULL, для поліморфного зв'язку теж, колбеки не викликаються
    * `:restrict_with_exception` - призведе до виключення `ActiveRecord::DeleteRestrictionError`, якщо є зв'язаний об'єкт
    * `:restrict_with_error` - паризведе до помилки, доданої до власника, якщо є зв'язаний об'єкт
    * `:destroy` та `:delete_all` також впливають на роботу `collection.delete` та `collection=`
  * `:foreign_key` - дозволяє встановити назву зовнішнього ключа, за замовчуванням - ім'я моделі + суфікс `_id`
  * `:primary_key`
    * дозволяє встановити назву первинного ключа, дефолтно `id`
    * User: `self.primary_key = 'guid' # primary key is guid and not id`
    * Todo: `belongs_to :user, primary_key: 'guid'`
    * при виконанні `@user.todos.create`. в об'єкта `@todo` буде значення `user_id` таке ж, як значенння `quid` у `@user`
  * `:inverse_of`
    * визначає назву зв'язку `belongs_to`, що протилежна до цього зв'язку
    * Author: `has_many :books, inverse_of: :author`
    * Book: `belongs_to :author, inverse_of: :books`
  * `:source` - визначає назву джерела зв'язку для зв'язку `has_many :through`
  * `:source_type`
    * визначає назву джерела зв'язку для зв'язку `has_many :through`, при поліморфному зв'язку
  * `:through` - визначає поєднуючу модель, через котру виконується запрос
  * `:validate`
    * якщо `true`, то при збереженні основного об'єкту, зв'язані - проходять валідацію, дефолтно = `true`
* В цьому зв'язку є такі **скоупи**
  * `where`
    * дозволяє визначити умови, котрим має відповідати зв'язаний об'єкт
    * `has_many :confirmed_books, -> { where "confirmed = 1" }, class_name: "Book"`
    * можна задати умови хешем `has_many :confirmed_books, -> { where confirmed: true }, class_name: "Book"`
  * `extending` - визначає іменований модуль для розширення проксі-зв'язку
  * `group`
    * надає ім'я атрибута, по котрому групується результуючий набір, юзається GROUP BY
    * `has_many :chapters, -> { group 'books.id' }, through: :books`
  * `includes`
    * можна юзать для визначення зв'язків 2го порядку, котрі мають ліниво грузитись при використанні цього зв'язку
    * якщо часто отримую авторів з розділів `@chapter.book.author`, то можна так:
    *        class Chapter < ApplicationRecord
               belongs_to :book, -> { includes :author }
             end
                 
             class Book < ApplicationRecord
               belongs_to :author
               has_many :chapters
             end

             class Author < ApplicationRecord
               has_many :books
             end
  * `limit` - визначає к-сть об'єктів, що будуть вибрані через зв'язок
  * `offset` - визначає початкове зміщення для вибору об'єктів через зв'язок
  * `order`
    * визначає порядок, в якому будуть вибрані об'єкти
    * `has_many :books, -> { order "date_confirmed DESC" }`
  * `readonly` - зв'язаний об'єкт буде тільки для читанння при отриманні через зв'язок
  * `select`
    * перевизначення SQL виразу SELECT, за замовчуванням - всі колонки
  * `distinct`
    * прибирання дублікатів з колекції. Корисно в поєднанні з `through`
    * `has_many :articles, -> { distinct }, through: :readings`
* Коли зберігаються
  * зберігаються автоматично (щоб оновити зовнішній ключ), якщо назначаємо кілька об'єктів - то всі автосейвляться
  * якщо одне з цих зберігань падає ізза валідації тоді повертається `false` і все призначення скасовується
  * якщо основний об'єкт новий, не зебережений ще, то зв'язки не зберігаються, але автоматом збережуться при збереженні основного
  * якщо я хочу призначити об'єкт через `has_many` і не зберігати його - треба юзать `collection.build`

#### 4. `has_many :through`
* використовується для зв'язку **many-to-many** через третю модель:
  * User:
    * `has_many :user_books`
    * `has_many :books, through: :user_books`
  * Book:
    * `has_many :user_books`
    * `has_many :users, through: :user_books`
  * UserBook:
    * `belongs_to :user`
    * `belongs_to :book`
* також потрібна для настройки ярликів через вкладені зв'язки `has_many`:
  * Document
    * `has_many :sections`
    * `has_many :paragraphs, through: :sections`
  * Section
    * `belongs_to :document`
    * `has_many :paragraphs`
  * Paragraph
    * `belongs_to :section`

#### 5. `has_one :through`
* встановлює зв'язок **one-to-one** через третю модель
  * Supplier
    * `has_one :account`
    * `has_one :account_history, through: :account`
  * Account
    * `belongs_to :supplier`
    * `has_one :account_history`
  * AccountHistory
    * `belongs_to :account`

#### 6. `has_and_belongs_to_many`
* прямий зв'язок (без третьої моделі, але з додатковою таблицею в БД) **many-to-many**
  * Assembly
    * `has_and_belongs_to_many :parts`
  * Part
    * `has_and_belongs_to_many :assemblies`
* Зразу додається пачка **методів**, де `collection` замінюється на переданий перший аргумент в `has_and_belongs_to_many`, а `collection_singular` - на версію в однині, будемо писати методи для `has_many :books`
  * `books` - повертає Relation всіх зв'язаних об'єктів
  * `books<<(object, ...)` - додає 1 або більше
  * `books.delete(object, ...)` - видаляє 1 або більше, встановлюючи їх зовнішні ключі в `NULL`
  * `books.destroy(object, ...)` - видаляє 1 або кілька, виконуючи `destroy` для кожного
  * `books=(objects)` - робить колекцію включаючою тільки задані об'єкти
  * `book_ids` - повертає масив id об'єктів
  * `book_ids=(ids)` - робить колекцію включаючою тільки задані об'єкти, але за допомогою id
  * `books.clear`
    * прибирає кожен об'єкт з колекції відповідно до стратегії, визначеної опцією `dependent`
    * якщо не визначено - то по замовчуванню
      * для `has_many :through` - це `delete_all`
      * для `has_many` - встановити зовнішні ключі в `NULL`
  * `books.empty?` - повертає `true`, якщо в колекції немає об'єктів
  * `books.size` - повертає кількість об'єктів в колекції
  * `books.find(...)` - шукає об'єкти в таблиці колекції
  * `books.where(...)`
    * шукає об'єкти в таблиці колекції, базуючись на переданих умовах, загрузка лінива - виконання SQL тільки коли звернення до об'єкту
    * > @available_books = @author.books.where(available: true) # Поки немає ріквесту
      >
      > @available_book = @available_books.first # Тепер база даних буде запрошена
  * `books.exists?(...)` - перевіряє, чи існує об'єкт в колекції, що відповідає умовам
  * `books.build(attributes = {}, ...)`
    * повертає 1 або масив об'єктів зв'язаного типу
    * об'єкти - екземпляри з переданими атрибутами
    * буде створено лінк через їх зовнішні ключі, але зв'язані об'єкти не будуть поки збережені
  * `books.create(attributes = {})`
    * повертає 1 або масив нових об'єктів зв'язаного типу
    * об'єкти - екземпляри з переданими атрибутами
    * буде створено лінк через їх зовнішні ключі, і якщо зв'язані об'єкти пройдуть валідацію вони будуть збережені
  * `books.create!(attributes = {})` - працює так само, окрім того, викликає `ActiveRecord::RecordInvalid`, якщо валідація не пройдена
  * `books.reload` - повертає Relation всіх зв'язаних об'єктів, примусово читаючи БД. Якщо об'єктів немає - повертає пустий Relation
* В цьому зв'язку є такі **опції**
  * `:association_foreign_key` - дозволяє встановити назву зовнішнього ключа, за замовчуванням - ім'я моделі + суфікс `_id`
  * `:autosave`
    * `true` - все зберігається при збереженні основного об'єкту
    * `false` - не буде зберігати зв'язані об'єкти
    * не вказане - нові зв'язані об'єкти збережуться, оновлені - ні
  * `:class_name` - вказати назву класу, якщо його не можна прочитати з назви зв'язку `has_and_belongs_to_many :assemblies, class_name: "Gadget"`
  * `:foreign_key` - дозволяє встановити назву зовнішнього ключа, за замовчуванням - ім'я моделі + суфікс `_id`
  * `:join_table` - щоб прописати кастомне ім'я додаткової таблиці
  * `:validate`
    * якщо `true`, то при збереженні основного об'єкту, зв'язані - проходять валідацію, дефолтно = `true`
* В цьому зв'язку є такі **скоупи**
  * `where`
    * дозволяє визначити умови, котрим має відповідати зв'язаний об'єкт
    * `has_many :confirmed_books, -> { where "confirmed = 1" }, class_name: "Book"`
    * можна задати умови хешем `has_many :confirmed_books, -> { where confirmed: true }, class_name: "Book"`
  * `extending` - визначає іменований модуль для розширення проксі-зв'язку
  * `group`
    * надає ім'я атрибута, по котрому групується результуючий набір, юзається GROUP BY
    * `has_many :chapters, -> { group 'books.id' }, through: :books`
  * `includes`
    * можна юзать для визначення зв'язків 2го порядку, котрі мають ліниво грузитись при використанні цього зв'язку
    * якщо часто отримую авторів з розділів `@chapter.book.author`, то можна так:
    *        class Chapter < ApplicationRecord
               belongs_to :book, -> { includes :author }
             end
                 
             class Book < ApplicationRecord
               belongs_to :author
               has_many :chapters
             end

             class Author < ApplicationRecord
               has_many :books
             end
  * `limit` - визначає к-сть об'єктів, що будуть вибрані через зв'язок
  * `offset` - визначає початкове зміщення для вибору об'єктів через зв'язок
  * `order`
    * визначає порядок, в якому будуть вибрані об'єкти
    * `has_many :books, -> { order "date_confirmed DESC" }`
  * `readonly` - зв'язаний об'єкт буде тільки для читанння при отриманні через зв'язок
  * `select`
    * перевизначення SQL виразу SELECT, за замовчуванням - всі колонки
  * `distinct`
    * прибирання дублікатів з колекції. Корисно в поєднанні з `through`
    * `has_many :articles, -> { distinct }, through: :readings`
* Коли зберігаються
  * зберігаються автоматично (щоб оновити зовнішній ключ), якщо назначаємо кілька об'єктів - то всі автосейвляться
  * якщо одне з цих зберігань падає ізза валідації тоді повертається `false` і все призначення скасовується
  * якщо основний об'єкт новий, не зебережений ще, то зв'язки не зберігаються, але автоматом збережуться при збереженні основного
  * якщо я хочу призначити об'єкт через `has_many` і не зберігати його - треба юзать `collection.build`

### `belongs_to` vs `has_one`
* різниця в тому, де буде ключ, має бути в класі з `belongs_to`
* також є структура - якщо пишемо `has_one`, то цій ентіті має щось належати
  * наприклад user<->address - юзерові належить адреса: user - `has_one`, address - `belongs_to`

### `has_many :through` vs `has_and_belongs_to_many`
* в обох випадках в базі буде додаткова таблиця
* `has_many :through` треба використовувати, якщо треба працювати з моделлю зв'язків як з окремим об'єктом
  * якісь колбеки, валідації, або додаткові атрибути

### Поліморфні зв'язки
* модель може належати більше ніж одній моделі на одинарному зв'язку.
  * Picture
    * `belongs_to :imageable, polymorphic: true`
  * Employee
    * `has_many :pictures, as: :imageable`
  * Product
    * `has_many :pictures, as: :imageable`
* в даному випадку `belongs_to` шось типу інтерфейса, це може використовувати будь-яка інша модель
* в базі реалізовано - додатковими колонками `imageable_type` та `imageable_id`

### Self-related
* як наприклад категорія-підкатегорія або юзери з директор-підлеглий:
  * `has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"`
  * `belongs_to :manager, class_name: "Employee", optional: true`
* в базі маємо додати стовбець - лінк моделі на саму себе

### Кеш
* методи зв'язків побудовані навколо кешованих результатів
  * `author.books` - дістане і закешує, потім це буде з кешу `author.books.size` або `author.books.empty?`
* щоб перегрузити - треба заюзать `reload` - `author.books.reload.empty?`

### Схема
* для зв'язків `belongs_to` - треба створювати звонішні ключі за необхідності
* для `has_and_belongs_to_many` - треба створювати таблицю зв'язку вручну (має бути створена без первинного ключа)

### Область видимості
* якщо моделі в одному модулі - все ок
* якщо моделі в різних модулях - треба вказувати повне ім'я класу:
  * `has_one :account, class_name: "MyApplication::Billing::Account"`
  * `belongs_to :supplier, class_name: "MyApplication::Business::Supplier"`

### Двонаправленість
* якщо все дефолтно, то ActiveRecord - сам розрізняє двосторонність зв'язку
* але якщо є опції `:through` або `:foreign_key` - то двонаправленість не буде автоматом
* За допомогою `:inverse_of` можна явно вказати двонаправленість
  * Author: `has_many :books, inverse_of: 'writer'`
  * Book: `belongs_to :writer, class_name: 'Author', foreign_key: 'author_id'`

### Колбеки розширення зв'язків
* `before_add`
  * ось так колбек прописувать `has_many :books, before_add: :check_credit_limit`, і потім `def check_credit_limit(book)`
  * а так можна чергу методів в колбек `has_many :books, before_add: [:check_credit_limit, :calculate_shipping_charges]` і потім 2 методи пишемо
  * якщо в цьому колбеку викликається `:abort` - об'єкт не буде додано: `throw(:abort) if limit_reached?`
* `after_add`
* `before_remove`
  * якщо в цьому колбеку викликається `:abort` - об'єкт не буде видалено: `throw(:abort) if limit_reached?`
* `after_remove`
* Ці колбеки стосуються тільки зв'язків - коли в колекції додається або видаляється об'єкт:
  *     # Вызывает колбэк `before_add`
        author.books << book
        author.books = [book, book2]

        # Не вызывает колбэк `before_add`
        book.update(author_id: 1)

### Розширення зв'язку
* за допомогою анонімних модулів:
  *     class Author < ApplicationRecord
          has_many :books do
            def find_by_book_prefix(book_number)
              find_by(category_id: book_number[0..2])
            end
          end
        end
* якщо розширення має бути спільним - виносимо в іменований модуль:
  *     module FindRecentExtension
          def find_recent
            where("created_at > ?", 5.days.ago)
          end
        end

        class Author < ApplicationRecord
          has_many :books, -> { extending FindRecentExtension }
        end

        class Supplier < ApplicationRecord
          has_many :deliveries, -> { extending FindRecentExtension }
        end
  * розширення можуть ссилатися на внутрішні методи виданих об'єктів
    * `proxy_association.owner` - повертає об'єкт, в котрому об'явлений зв'язок
    * `proxy_association.reflection` - повертає об'єкт reflection, що описує зв'язок
    * `proxy_association.target` - повертає:
      * зв'язаний об'єкт для `belongs_to` чи `has_one`
      * колекцію зв'язаних об'єктів для `has_many` чи `has_and_belongs_to_many`

### Наслідування з однією таблицею (Single Table Inheritance)
* Створюємо модель Vehicle, в ній буде колонка `type` - в БД буде збережена модель в цій колонці
  * `class Vehicle; end`
  * консоль: `rails generate model vehicle type:string color:string price:decimal{10.2}`
* Тепер створимо кілька дочірніх моделей:
  * `class Car < Vehicle; end`
  * консоль: `rails generate model car --parent=Vehicle`
  * при вказуванні `--parent=PARENT` міграції не потрібно - вже є таблиця `vehicle` і колонка `type`
* Тепер працює все само:
  * `Car.create(color: 'Red', price: 10000)`
    * це згенерує таку кверю: `INSERT INTO "vehicles" ("type", "color", "price") VALUES ('Car', 'Red', 10000)`
  * `Car.all`
    * це згенерує таку кверю: `SELECT "vehicles".* FROM "vehicles" WHERE "vehicles"."type" IN ('Car')`
