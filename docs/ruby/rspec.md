# RUBY SPEC HELPEX
[На головну](/README.md)

[На Ruby](index.md)


## Install
* Виконати `bundler add rspec-rails`
* Виконати `rails generate rspec:install`
* Воно створить папку `spec` та нагенерить хелперів
* Для тестів - ранаєм: `rspec spec/test_spec.rb`


## Групування тестів
* В одному тесті корінний блок:
  ```ruby
  RSpec.describe 'some title or class name'  do
  end
  ```
* В ньому отакий блок:
  ```ruby
  describe 'some title or class name' do
  end
  ```
* В ньому не обов'язковий такий:
  ```ruby
  context 'some title' do
  end
  ```
* В ньому вже сам example:
  ```ruby
  it 'some title' do
  end
  ```


## Структура тесту
* **Що маємо** - якісь вхідні дані або моки або ще щось
* **Що робимо** - щось викликаємо або обчислюємо
* **Що очікуємо** - `expect().to match /reg ex/i`
  * замість `to` можна інше - є наприклад `not_to`
  * **Матчер** - це є саме порівняння, наприклад `match /reg ex/` порівнює з регуляркою, є ще `eql` та купа інших


## Let
* Альтернатива `before: each`
* `let` - дозволяє присвоювати результат повернення блоку змінній
* Ці змінні видно тільки в поточному `describe`
* В наступних `let` можна використовувати змінні з попередніх
* Для присвоєння значення використовується мемоізація, `let` повертає мемоізований метод
* `let` - лінива загрузка - не вираховується до використання
* `let!` - якщо треба обов'язково виклик блоку до виконання тестів


## allow, expect
* `allow` і `expect` - наприклад є метод `call` в об'єкті `SecondService`, котрий буде викликатися
* `allow` - припускає шо метод може не викликатися, але якщо викликається, то перевіряється результат
  * `allow(SecondService).to receive(:call)` - просто мокає SecondService
* `expect` - валить тест, якщо метод не викликається
  * `expect(SecondService).to receive(:call)` - мокає SecondService і перевіряє чи викликається, якщо ні - ексепшн


## Shared examples
* Виділення спільної поведінки або винесення спільного функціоналу між об'єктами в окремий блок, щоб потім вставити
* Приклад:
  ```ruby
  RSpec.shared_examples 'A Ruby object with 4 elements' do
    it 'returns the number of items' do
      expect(subject.size).to eq(4)
    end
  end

  RSpec.describe Array do
    subject { [1, 2, 3, 4] }
    include_examples
  end
  ```


## Shared context
* Будь-який код налаштування, який можна використовувати для підготовки тестового прикладу.
* Виносить спільний функціонал в окреме місце. Якісь змінні, методи допоміжні
* Потім цей функціонал можна підтягувать за допомогою `include_context` в різні спеки
* Також, там доступні тулзи для доступу до інших складових того контексту:
  * `shared_method` - метод, що описаний в `shared_context`
  * `shared_let` - змінні, що описані в `shared_context` за допомогою `let`
  * `@var` - змінні, що могли б бути описані в `shared_context` в хуку `before`
  * `subject` - буде тим що описано в `shared_context`, якщо описано
  * Приклад:
    ```ruby
    RSpec.shared_context 'common' do 
      before do
        @people = [ "James Baldwin", "William F. Buckley" ]
      end

      def helper_method
        "This works"
      end

      let(:variable) { "This isn't real" }
    end

    RSpec.describe 'example group' do
      include_context 'common'

      it 'can use instance variables' do
        @people.pop
        expect(@people).to eq(["James Baldwin"])
      end

      it 'can use instance variables across different examples' do 
        expect(@people.length).to eq(2)
      end

      it 'can use shared helper methods' do 
        expect(helper_method).to eq("This works")
      end

      it 'can use regular vaiables too' do
        expect(variable).to eq("This isn't real") 
      end 
    end

    RSpec.describe 'second example group' do
      include_context 'common'

      it 'can also be used in different example groups' do
        expect(helper_method).to eq("This works")
      end
    end
    ```


## Різне
* `render_views`
  * Дефолтно - в'юхи не рендеряться, якщо в тестах викликати екшни контролеру, а цей запис робить так, що рендеряться
    * Ця штука треба для тесту в'юх - можна писати або в тесті, або глобально - в хелпері
* `subject` - це об'єкт, що перевіряється
  * `RSpec.describe UserController` - тут `subject` - це `UserController`
  * `RSpec.describe 'LOL'` - тут `subject` - це `String`
  * `subject { UserController }` - можна самому задати в любому блоці `describe` або `context`


## Швидкість тестів
* Не юзати [FactoryBot](#factorybot) якщо це не є необхідністю
* Робити `build` сутностей, а не `create` - достатньо просто створити об'єкт і потестить щось на ньому і нічого нікуди не писати


## Тестування 3rd API
* Не робиться ніяких http реквестів, треба застабити об'єкт який працює з API
* Робиться http реквест, треба застабити network, можна використати [Webmock](#webmock) для цього
* Піднімається свій локальний сервіс і всі реквести направляються йому - цей спосіб дає змогу максимально все потестити
* [VCR](#vcr) - джем, що дозволяє записувати відповідь API і потім юзать її, а не робити кожен раз реквести


## ActiveSupport TimeHelpers
* Це такі хелпери, які допомагають в роботі з часом
* `travel(time_difference)` - подорож у часі в майбутнє на різницю між поточним і майбутнім:
  * `expect(item.expired?).to eq(false)  travel 5.day  expect(item.expired?).to eq(true)` - current time > to future
* `travel_to(date_or_time)` - цей метод дозволяє здійснювати подорож як у майбутнє, так і в минуле
  * `travel_to(Time.current - 5.day) { expect(item.expired?).to eq(false) }`
  * `travel_to(Time.current + 5.day) { expect(item.expired?).to eq(true) }`
  * `travel_to Time.zone.local(2020, 10, 1, 00, 00, 00)` - також можна використовувати конкретну дату
* `travel_back` - повертається до початкового часу, видаляючи заглушки, додані `travel` і `travel_to`
* `freeze_time` - заморожує час, може приймати блок і морозити всередині блоку:
  * `Time.current; freeze_time; sleep(1); Time.current` - обидва покажуть однаковий час
  * `freeze_time { item = Item.create(name: "Lol", expiration_date: Time.current); expect(post.published_at).to eq(Time.current) }`


## FactoryBot
* Це такий gem, котрий являється спеціальним слоєм, в який виноситься створення об'єктів або колекцій об'єктів
* Джерело: https://github.com/thoughtbot/factory_bot


## VCR
* Це такий gem, що дозволяє записувати відповідь API
* Джерело: https://github.com/vcr/vcr


## WebMock
* Це такий gem, бібліотека для заглушки та встановлення очікувань для HTTP-запитів
* Джерело: https://github.com/bblimke/webmock
