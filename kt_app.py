#!/usr/bin/env python

"""
    KOMTET application class
"""

import logging
import argparse
import configparser
import sys
from komtet_kassa_sdk import Client
sys.path.append('/opt/pg_app')
from pg_app import PGapp

class KTapp(PGapp):
    """
    KOMTET application class
    """
    log_format = '[%(filename)-21s:%(lineno)4s - %(funcName)20s()] \
            %(levelname)-7s | %(asctime)-15s | %(message)s'

    def __init__(self, args):
        self.args = args
        logging.getLogger(__name__).addHandler(logging.NullHandler())
        numeric_level = getattr(logging, self.args.log_level, None)
        if not isinstance(numeric_level, int):
            raise ValueError('Invalid log level: %s' % numeric_level)

        if self.args.log_file == 'stdout':
            logging.basicConfig(stream=sys.stdout, format=self.log_format, level=numeric_level)
        else:
            logging.basicConfig(filename=self.args.log_file, format=self.log_format,
                                level=numeric_level)

        config = configparser.ConfigParser(allow_no_value=True)
        config.read(self.args.conf)

        self.shop_id = config['AUTH']['SHOP_ID']
        self.secret_key = config['AUTH']['SECRET_KEY']
        self.kt_cli = Client(self.shop_id, self.secret_key)
        super(KTapp, self).__init__(self.args.pg_srv, 'arc_energo')





CONF_FILE_NAME = "komtet.conf"
parser = argparse.ArgumentParser()
parser.add_argument('--conf', type=str, default=CONF_FILE_NAME, help='conf file')
parser.add_argument('--pg_srv', type=str, default='localhost', help='PG hostname')
parser.add_argument('--log_file', type=str, default='stdout', help='log destination')
parser.add_argument('--log_level', type=str, default="DEBUG", help='log level')
