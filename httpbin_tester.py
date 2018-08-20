# -*- coding: utf-8 -*-
try:
    from urllib.parse import urljoin, urlencode
except ImportError:
    from urlparse import urljoin, urlencode
import requests


def _do_request(url, method="GET", **kwargs):
    """
    Функция-обертка для обращения к requests
    """
    host = 'http://httpbin.org/'
    full_url = urljoin(host, url)
    return requests.request(url=full_url, method=method, **kwargs)


def test_auth(user, password):
    """
    Функция выполняющая базовую авторизацию
    по заданным имени пользователя и паролю
    """
    url = '/basic-auth/{user}/{password}'.format(user=user, password=password)
    return _do_request(url, auth=(user, password))


def test_get(params, headers):
    """
    Функция выполняющая GET запрос с заданными параметрами
    """
    params_encode = urlencode(params)
    url = '/get?{params}'.format(params=params_encode)
    return _do_request(url, headers=headers)


def test_stream(count):
    """
    Функция выполняющая GET запрос по пути /stream/:n
    """
    url = '/stream/{count}'.format(count=count)
    return _do_request(url)
