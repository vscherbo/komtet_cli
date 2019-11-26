#!/usr/bin/env python
"""
    Test KOMTET couriers list
"""

from configparser import ConfigParser
import fire
from requests.exceptions import HTTPError
#from komtet_kassa_sdk import Client
#import komtet_kassa_sdk
from komtet_kassa_sdk import (
    Check, CorrectionCheck, Client, Intent, TaxSystem, VatRate, CorrectionType, PaymentMethod,
    Agent, AgentType, CalculationSubject, CalculationMethod
)

def main(shop_id, secret_key):
    """
    Just main
    """
    client = Client(shop_id, secret_key)

    # Отправка запроса
    try:
        cour_list = client.get_couriers()
    except HTTPError as exc:
        print(exc.response.text)
    else:
        print(cour_list._asdict())


if __name__ == '__main__':
    CFG = ConfigParser()
    CFG.read('komtet.conf')
    SHOP_ID = CFG['AUTH']['SHOP_ID']
    SECRET_KEY = CFG['AUTH']['SECRET_KEY']
    print(SHOP_ID)
    #main(SHOP_ID, SECRET_KEY)
    fire.Fire(Client(SHOP_ID, SECRET_KEY))
