#!/usr/bin/env python
"""
    Test KOMTET couriers list
"""

from configparser import ConfigParser
from requests.exceptions import HTTPError
from komtet_kassa_sdk import Client


def main(shop_id, secret_key):
    """
    Just main
    """
    client = Client(shop_id, secret_key)

    # Отправка запроса
    try:
        task = client.get_couriers()
    except HTTPError as exc:
        print(exc.response.text)
    else:
        print(task)


if __name__ == '__main__':
    CFG = ConfigParser()
    CFG.read('komtet.cfg')
    SHOP_ID = CFG['AUTH']['SHOP_ID']
    SECRET_KEY = CFG['AUTH']['SECRET_KEY']
    print(SHOP_ID)
    main(SHOP_ID, SECRET_KEY)
