#!/usr/bin/env python
# coding=utf-8
import pika

from settings import URL

connectionParameters = pika.URLParameters(URL)


connection = pika.BlockingConnection(connectionParameters)
channel = connection.channel()
channel.queue_declare(queue='later')


def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)


channel.basic_consume(queue='later', on_message_callback=callback, auto_ack=True)
channel.start_consuming()
