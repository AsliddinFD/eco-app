from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.db import models
from datetime import date



class UserManager(BaseUserManager):
    def create_user(self, email, name, password=None, **extra_fields):
        if not email:
            raise ValueError('You must enter your email')
        user = self.model(email = self.normalize_email(email), name = name)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, name, password=None,  **extra_fields):
        if name is None:
            raise ValueError('Superuser must have a name.')

        user = self.create_user(email, name, password, **extra_fields)
        
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)
        return user
        




class Category(models.Model):
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class Product(models.Model):
    name = models.CharField(max_length=255)
    category = models.ForeignKey(Category, on_delete = models.CASCADE)
    images = models.CharField(max_length=1000)
    description = models.TextField(blank = True)
    price = models.DecimalField(default = 0, max_digits = 20, decimal_places = 2)
    is_liked = models.BooleanField(default=False)
    def __str__(self):
        return self.name
    

class User(AbstractBaseUser):
    name = models.CharField(max_length=255)
    email = models.EmailField(unique = True)
    is_staff = models.BooleanField(default=False)
    liked_products = models.ManyToManyField(Product, related_name='liked_users')

    objects  = UserManager()
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name']

    def has_perm(self, perm, obj=None):
        return True

    def has_module_perms(self, app_label):
        return True
    
    def __str__(self):
        return self.email


class Comment(models.Model):
    product = models.ForeignKey(Product, on_delete = models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE, default=1)
    text = models.TextField(blank=True)
    user_name = models.CharField(max_length=255)
    
    


class Order(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete = models.CASCADE)
    count = models.IntegerField(default=1)
    date = models.DateField(default=date.today)
    price = models.DecimalField(decimal_places=2, max_digits=100)
    

class Cart(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    count = models.IntegerField(default=1)
    