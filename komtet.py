#!/usr/bin/env python
"""
    KOMTET client
"""

from configparser import ConfigParser
import fire
from komtet_kassa_sdk import Client
"""
from komtet_kassa_sdk import (
    Check, CorrectionCheck, Client, Intent, TaxSystem, VatRate, CorrectionType, PaymentMethod,
    Agent, AgentType, CalculationSubject, CalculationMethod
)
"""


if __name__ == '__main__':
    CFG = ConfigParser()
    CFG.read('/opt/komtet-cash/komtet.conf')
    SHOP_ID = CFG['AUTH']['SHOP_ID']
    SECRET_KEY = CFG['AUTH']['SECRET_KEY']
    #print(SHOP_ID)
    fire.Fire(Client(SHOP_ID, SECRET_KEY))
