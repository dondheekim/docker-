# -*- coding: utf-8 -*-
# Generated by Django 1.11.5 on 2017-12-23 06:52
from __future__ import unicode_literals

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('main_list', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='student',
            options={'managed': False, 'verbose_name': 'post', 'verbose_name_plural': 'posts'},
        ),
    ]
