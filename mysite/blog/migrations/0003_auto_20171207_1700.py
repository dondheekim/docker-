# -*- coding: utf-8 -*-
# Generated by Django 1.11.7 on 2017-12-07 08:00
from __future__ import unicode_literals

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('blog', '0002_post_owner'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='post',
            options={'ordering': ('-modify_date',), 'verbose_name': 'post', 'verbose_name_plural': 'posts'},
        ),
        migrations.AlterModelTable(
            name='post',
            table='my_post',
        ),
    ]
