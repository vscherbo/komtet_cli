#!/usr/bin/env python

"""
    Test KOMTET create order
"""

import logging
from requests.exceptions import HTTPError
from komtet_kassa_sdk import Order, Client
import kt_app

UPD_SQL_TEMPL = 'UPDATE shp.kt_q SET id_komtet=%s WHERE bill_no=%s'

class KTorder(kt_app.KTapp):
    """ KOMTET order application
    """
    def __init__(self, args):
        self.order = None
        super(KTorder, self).__init__(args)
        self.client = Client(self.shop_id, self.secret_key)

    def prepare_order(self, bill_no):
        """ Set order params from PG
        """
        get_order_params = """SELECT
        external_id,
        client_name,
        client_address,
        client_phone,
        client_email,
        is_paid,
        description,
        state,
        date_start,
        date_end,
        sno,
        courier_id,
        prepayment,
        payment_type
        FROM shp.kt_order_params({});""".format(bill_no)

        # actions
        while True:
            res = self.run_query(get_order_params, dict_mode=True)
            if res == 0:
                break
            elif res in ('57P01', '57P02', '57P03'):
                # try reconnect in loop
                self.wait_pg_connect()
            else:
                break
        data = self.curs_dict.fetchone()
        logging.info('data=%s', data)
        logging.info('client_name=%s', data['client_name'])

        self.order = Order(order_id=str(bill_no),
                           state='new',
                           sno=data['sno'],
                           is_paid=data['is_paid'],
                           payment_type=data['payment_type']
                          )
        self.order.set_client(address=data['client_address'],
                              phone=data['client_phone'],
                              email=data['client_email'],
                              name=data['client_name']
                             )
        self.order.set_delivery_time(date_start=data['date_start'],
                                     date_end=data['date_end']
                                    )
        if data['description']:
            self.order.set_description(data['description'])
        self.order.add_courier_id(int(data['courier_id']))

        self.set_order_items(bill_no)
        logging.debug('End of function')

    def set_order_items(self, bill_no):
        """ Get order items from PG
        """
        get_order_items = "SELECT * FROM shp.kt_order_items({});".format(bill_no)
        while True:
            res = self.run_query(get_order_items, dict_mode=True)
            if res == 0:
                break
            elif res in ('57P01', '57P02', '57P03'):
                # try reconnect in loop
                self.wait_pg_connect()
            else:
                break
        order_pos = self.curs_dict.fetchall()
        for pos in order_pos:
            logging.debug('data=%s', pos['name'])
            self.order.add_position(oid=pos['oid'],
                                    name=pos['name'],
                                    price=pos['price'],
                                    quantity=pos['quantity'],
                                    vat=pos['vat'],
                                    measure_name=pos['measure_name'],
                                    type=pos['type']
                                   )

        logging.debug('End of function')


    def place_order(self):
        """ Send order to KOMTET
        """
        # Отправка запроса
        try:
            logging.debug('dict(self.order)=%s', dict(self.order))
            #res = self.order
            res = self.client.create_order(self.order)
        except HTTPError:
            logging.exception('FAILED')
        else:
            logging.debug('type(res)=%s', type(res))
            logging.debug('res=%s', res)

            for k, val in res.items():
                logging.debug('for loop %s=%s', k, val)

            if 'id' in dict(res).keys():
                if res['id']:
                    logging.debug('получен id=%s от КОМТЕТ', res['id'])
                    upd_sql = self.curs.mogrify(UPD_SQL_TEMPL,
                                                (res['id'],
                                                 res['external_id']))
                    logging.info('upd_sql=%s', upd_sql)
                    while True:
                        res = self.run_query(upd_sql)
                        if res == 0:
                            break
                        elif res in ('57P01', '57P02', '57P03'):
                            # try reconnect in loop
                            self.wait_pg_connect()
                        else:
                            break


    def get_order_info(self, oid):
        """ Get order info from KOMTET
        """


def main():
    """
    Just main
    """
    kt_app.parser.add_argument('--bill_no', type=int, required=True,
                               help='Номер счёта')
    # 55236708
                               # help='id доставки через ПР')
    args = kt_app.parser.parse_args()

    kt_order_app = KTorder(args)
    logging.info("args=%s", args)

    kt_order_app.wait_pg_connect()
    kt_order_app.set_session(autocommit=True)

    kt_order_app.prepare_order(args.bill_no)

    kt_order_app.place_order()



if __name__ == '__main__':
    main()
