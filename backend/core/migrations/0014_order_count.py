# Generated by Django 4.2.1 on 2024-01-11 10:49

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0013_rename_product_cart_product_alter_cart_count'),
    ]

    operations = [
        migrations.AddField(
            model_name='order',
            name='count',
            field=models.IntegerField(default=1),
        ),
    ]