*** Settings ***
Documentation     Тесты для сайта http://httpbin.org/.
...
...               == Зависимости ==
...               - [ https://github.com/dmizverev/robot-framework-library/blob/master/library/JsonValidator.py | JsonValidator ]
...               - [ http://robotframework.org/robotframework/latest/libraries/String.html | String ]
Library           String
Library           JsonValidator
Library           httpbin_tester.py

*** Variables ***
${count_stream_lines}=  ${4}

*** Test Cases ***
Test Auth   [Template]         Check auth
            [Documentation]    Тесты для проверки метода /basic-auth
            user1              pass1
            user2              pass2

Test Get
            [Documentation]    Тест для проверки метода /get
            Comment    Создание необходимых словарей для передачу в функцию
            ${headers}=    Create dictionary    Content-Type=application/json; charset=UTF-8
            ${params}=    Create dictionary    param1=val1         param2=val2
            Comment    Отправка запроса
            ${resp}=    Test Get      params=${params}      headers=${headers}
            Comment    Проверка кода ответа
            Should be equal as strings    ${resp.status_code}    200
            Comment    Проверка полученного контента на соответствие параметров
            Element should exist    ${resp.content}    .args .param1:contains("val1")
            Element should exist    ${resp.content}    .args .param2:contains("val2")
            Element should exist    ${resp.content}    .headers .Content-Type:contains("application/json; charset=UTF-8")

Test Stream
            [Documentation]    Тест для проверки метода /stream
            Comment    Отправка запроса
            ${resp}=   Test Stream      count=${count_stream_lines}
            Comment    Проверка кода ответа
            Should be equal as strings    ${resp.status_code}    200
            Comment    Проверка полученного контента на соответствие установленному количеству строк
            ${rec_count} =   Get Line Count    ${resp.content}
            Should Be Equal    ${count_stream_lines}    ${rec_count}

*** Keywords ***
Check auth
            [Documentation]    Шаблон для проверки /basic-auth/:user/:passwd
            [Arguments]    ${user}    ${password}
            Comment    Отправка запроса
            ${resp}=    Test Auth      user=${user}      password=${password}
            Comment    Проверка кода ответа
            Should be equal as strings    ${resp.status_code}    200
            Comment    Проверка полученного контента на соответствие параметров
            Element should exist    ${resp.content}    .user:contains("${user}")
            Should Be True          ${resp.content}    .authenticated
