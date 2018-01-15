# ПРАВИЛА РАБОТЫ С VCS {#head}
### Цели
1. Организация удобной работы для неограниченного числа разработчиков
2. Получать более полную информацию при просмотре истории

## Формат сообщения коммитов {#format}
```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```
Любая строка сообщения коммита не должна быть длиннее 100 символов. Это позволяет легче читать сообщение в различных инструментах GIT.

Сообщение коммита состоит из заголовка, параметров задачи, тела и нижнего колонтитула, разделенных пустой строкой.

### Заголовок сообщения `<subject>`
Заголовок сообщения представляет собой одну строку, которая содержит краткое описание изменения, содержащего тип, область и сообщение.
- используйте настоящее время

- не используйте прописную букву

- не используйте точку в конце

##### Доступные `<type>`:

- feat (используется при добавлении новой функциональности)

- fix (исправление ошибки)

- docs (всё, что касается документации)

- typo (исправление опечаток)

- style (форматирование, пропущенная точка с запятой)

- refactor (рефакторинг кода приложения)

- test (добавление не достающего теста)

- chore (мелкие изменения без измений производственного кода, н-р: изменение задач сборщика Grunt)

##### Доступные `<scope>`:

Область может быть чем угодно указывать на место совершения изменений.

Например:

- Функция: `MakeName`, `main`

- Имя файла: `test_feature.go`

- Имя пакета: `httprequest`

### Тело сообщения `<body>`
Отделяется от заголовка пустой строкой

В теле сообщения описываем выполненные действия

Например:
```
Issue:
 - Portfolios with > 30 trades can cause significant slowdown on pageload
 - Majority of the bottleneck is in trade score / chart data

Fix:
This is a quick fix to prevent redundant lookups. This includes:
 - Memoize Trade #spy_price_on_transaction_date and #spy_current_price
 - Eager load Trade ticker
```

### Нижний колонтитул `<footer>`

Здесь вы можете ссылаться на:
 - закрытые задачи
 ```
 {id} - {summary}
 ```
 - issues
 ```
 closes #125
 ```
 - pull-requests&merge
 ```
 merge with @frontend
 ```
### Примеры


```
fix(main): add error check

Add check for error when serializing

closes #125
```

```
feat(GetAllPosts): new api method

Api method for get all posts

123123123123213 - Разработать метод для получения списка постов
```

## Автоматизация проверки коммитов {#auto}
Для удобства работы с использованием формата коммитов реализована возможность автоматизировать написание, проверку и коммит сообщений.

#### Для шаблонизирования коммитов можно использовать:
- [Git Commit Template](https://plugins.jetbrains.com/plugin/9861-git-commit-template) (Goland Plugin)

#### Для проверки коммита перед созданием:
- [commitlint](https://github.com/marionebl/commitlint) (cli-tool) Этот инструмент не даст сделать коммит в неправильном формате

    * По-умолчанию используются правила из спецификации [Angular](https://github.com/marionebl/commitlint/tree/master/@commitlint/config-angular)
    * Сменить конфиг можно в файле `commitlint.config.js` в корне проекта
    * С помощью [husky](https://github.com/typicode/husky) добавлен **git-hook** в `package.json`
    * Для интеграции с Goland нужно настроить секцию **Before Commit** так:

        ![Конфиг VCS](Before_commit_settings.png)

## Автогенерация CHANGELOG.md {#changelog}
Стандартизация коммитов позволяет нам генерировать **CHANGELOG.md** на основе *git metadata*

На основе `<type>` в заголовках коммитов формируются секции
 - "Feature"
 - "Fix"
 - "Performance Improvement"
 - "Breaking Changes"

Для ручной генерации изменений в **CHANGELOG.md** нужно использовать команду
```sh
$ npm version patch
```
*P.S. Команду нужно выполнять после коммита всех изменений*

Автоматическая генерация **CHANGELOG.md** происходит перед коммандой
```sh
$ git push
```

