# TESTS HELPEX
[На головну](../../README.md)

## Загальне
* unit tests
  * тестування якогось шматка коду в ізоляції від інших шматків коду
* integration tests
  * тестування якогось шматка коду у взаємодії з іншими шматками коду
  * тут вже може бути TDD
    * суть в тому, що ми спочатку визначаємо тести, котрі має проходити система, а потім вже пишемо систему і дивимося, щоб тести були зелені
  * тут також може бути BDD
    * ще більше абстрагуємося від коду
    * пишемо сценарії у вигляді текстових файлів
      * сценарій: що маємо на вході, що робимо, що повертаємо
      * реалізація - cucumber
* system tests
  * зустрічається рідше, якщо є, то це показник крутості проєкту
  * більш високий рівень тестування
  * тестування в бойовому режимі, на якомусь тест-кластері
  * швидше за все - це робить QA відділ
