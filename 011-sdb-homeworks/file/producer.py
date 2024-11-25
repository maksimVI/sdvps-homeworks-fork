#!/usr/bin/env python
# coding=utf-8
import pika

from settings import URL

connectionParameters = pika.URLParameters(URL)


connection = pika.BlockingConnection(connectionParameters)
channel = connection.channel()
channel.queue_declare(queue='later')
channel.basic_publish(exchange='', routing_key='later', body='See you later Netology!')
connection.close()
