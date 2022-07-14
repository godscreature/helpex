# RUBY SPEC HELPEX
[На головну](/README.md)

## Install
* виконати `bundler add rspec-rails`
* виконати `rails generate rspec:install`
* воно створить папку `spec` та нагенерить хелперів
* для тестів - ранаєм: `rspec spec/test_spec.rb`

## Групування тестів
* в одному тесті корінний блок - між `RSpec.describe 'some title or class name'  do end`
* в ньому отакий блок `describe 'some title or class name' do end`
* в ньому не обов'язковий такий `context 'some title' do end`
* в ньому вже сам example `it 'some title' do end`

## Структура тесту
* Що маємо - якісь входящі дані або моки або ще щось
* Що робимо - щось викликаємо або обчислюємо
* Що очікуємо - `expect().to match //i`
  * замість `to` можна інше - є наприклад `not_to`
  * Матчер - це є саме порівняння, наприклад `match /reg ex/` порявнює з регуляркою, є ще `eql` та купа інших

## Let
* `let`
.  * альтернатива `before: each`
  * лінива загрузка - не вираховується до використання
  * `let` и `let!` - дозволяє присвоювати результат повернення блоку змінній
  * ці змінні видно тільки в поточному `describe`
  * в последующих `let` можно использовать переменные из предыдущих
  * для присваивания значения используется memo-изация или другими словами `let` возвращает мемоизованный метод
  * это означает, что до обращения к переменной, блок переданный в let не будет исполнен
  * `let!` - если требуется обязательный вызов блока до выполнения тестов

## allow, expect
`allow` и `expect` - наприклад є метод, котрий буде викликатися
  * `allow` - припускає шо метод може не викликатися, але якшо викликається то перевіряється результат
  * `expect` - валить тест, якшо метод не викликається
  * `allow(SecondService).to receive(:call)` - просто мокає SecondService
  * `expect(SecondService).to receive(:call)` - мокає SecondService і перевіряє чи викликається, якщо ні - ексепшн

## Shared examples
* `shared_examples`
* виділення спільної поведінки  або винесення спільного функціоналу між об'єктами в окремий блок
* щоб потім вставити використовується `include_examples`
* приклад:
  *     RSpec.shared_examples 'A Ruby object with 4 elements' do
          it 'returns the number of items' do
            expect(subject.size).to eq(4)
          end
        end
  *     RSpec.describe Array do
          subject { [1, 2, 3, 4] }
          include_examples
        end

## Shared context
* `shared_context`
  * будь-який код налаштування, який можна використовувати для підготовки тестового прикладу.
  * Виносить спільний функціонал в окреме місце. Якісь змінні, методи допоміжні
  * Потім цей функціонал можна підтягувать за допомогою `include_context` в різні спеки
  * також там доступні тулзи для доступу до інших складових того контексту:
    * `shared_method` - метод, що описаний в `shared_context`
    * `shared_let` - змінні, що описані в `shared_context` за допомогою `let`
    * `@var` - змінні, що могли б бути описані в `shared_context` в хуку `before`
    * `subject` - буде тим що описано в `shared_context`, якщо описано
    * приклад:
      *     RSpec.shared_context 'common' do 
              before do
                @people = [ "James Baldwin", "William F. Buckley" ]
              end

              def helper_method
                "This works"
              end

              let(:variable) { "This isn't real" }
            end
      *     RSpec.describe 'example group' do
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
      *     RSpec.describe 'second example group' do
              include_context 'common'

              it 'can also be used in different example groups' do
                expect(helper_method).to eq("This works")
              end
            end

## Різне
* `render_views`
  * дефолтно вьюхи не рендеряться, якщо в тестах викликати екшни контролеру, а цей запис робить шо рендеряться
  * ця штука треба для тесту в'юх - можна писати або в тесті, або глобально - в хелпері
* `subject` - це об'єкт, що перевіряється.
  * `RSpec.describe UserController` - тут `subject` - це `UserController`
  * `RSpec.describe 'LOL'` - тут `subject` - це `String`

## Швидкість тестів
* Не юзати FactoryBot якщо це не є необхідністю
* Робити `build` сутностей, а не `create` - достатньо просто створити об'єкт і потестить шось на ньому і нічого нікуда не писати

## Тестування 3rd API
* Не робиться ніяких http реквестів, треба застабити об'єкт який працює з API
* Робиться http реквест, треба застабити network, можна використати Webmock для цього
* Піднімається свій локальний сервіс і всі реквести направляються йому - цей спосіб дає змогу максимально все потестити
* VCR - джем, що дозволяє записувати відповідь API і потім юзать її, а не робити кожен раз реквести

## ActiveSupport TimeHelpers
* Це такі хелпери, які допомагають в роботі з часом
  * `travel(time_difference)` - подорож у часі в майбутнє на різницю між поточним і майбутнім:
    * `expect(item.expired?).to eq(false)  travel 5.day  expect(item.expired?).to eq(true)` - current time > to future
  * `travel_to(date_or_time)` - цей метод дозволяє здійснювати подорож як у майбутнє, так і в минуле
    * `travel_to(Time.current - 5.day) { expect(item.expired?).to eq(false) }`
    * `travel_to(Time.current + 5.day) { expect(item.expired?).to eq(true) }`
    * `travel_to Time.zone.local(2020, 10, 1, 00, 00, 00)` - також можна використовувати конкретну дату
  * `travel_back` - повертається до початкового часу, видаляючи заглушки, додані `travel` і `travel_to`.
  * `freeze_time` - заморожує час, може приймати блок і морозити всередині блоку:
    * `Time.current; freeze_time; sleep(1); Time.current` - обидва покажуть однаковий час
    * `freeze_time { item = Item.create(name: "Lol", expiration_date: Time.current); expect(post.published_at).to eq(Time.current) }`

## Тестування навантаження
* Load testing - скільки одночасних користувачів може обробляти система протягом певного періоду.
* Stress testing - як система буде вести себе, коли буде досягнуто обмеження кількості користувачів.
* Performance testing - є основою стресового та навантажувального тестування. Отримати певний набір показників, для покращення коду програми.

