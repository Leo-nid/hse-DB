# Визуализация гео-данных 

## Запуск сервера базы данных

Для запуска сервера базы данных необходимо настроить `settings.env`. Для этого необходимо указать свой пароль в `settings.env.template`. Затем в терминале выполнить команду:
```
    ./deploy.sh up
```
После этого будет запущен сервер PostGres на который можно зайти с логином `postgres` и паролем, который вы указали. 

## Загрузка `.osm` файла в базу данных 

Для загрузки `.osm` файла в базу данных необходимо настроить `psql_config.json`. Для этого в файле `psql_config.json.template` нужно указать host, login, `traffic` в качестве названия базы данных и ваш пароль. 

В файле `example.ipynb` вы найдете пример использования нашего сервиса. 