from django.urls import path
from . import views

urlpatterns = [
    path('user/create/', views.RegisterUser.as_view()),
    path('user/login/', views.Login.as_view()),
    path('user/', views.UserInfoAPIView.as_view()),
    path('categories/', views.ListCategories.as_view()),
    path('products/', views.ListProducts.as_view()),
    path('product/<int:pk>/', views.ProductDetail.as_view()),
    path('products/<int:category_id>/', views.FilterProducts.as_view()),
    path('orders/<int:user_id>/', views.ListOrders.as_view()),
    path('orders/create/', views.CreateOrder.as_view()),
    path('orders/cancel/<int:pk>', views.CancelOrder.as_view()),
    path('comments/<int:pk>/', views.ListComment.as_view()),
    path('comments/create/', views.CreateComment.as_view()),
    path('comment/delete/<int:pk>/', views.DeleteComment.as_view()),
    path('cart/add/', views.AddCart.as_view()),
    path('cart/delete/<int:pk>', views.DeleteCart.as_view()),
    path('cart/reduce/<int:product_id>/', views.ReduceCartItemAPIView.as_view()),
    path('cart/get/<int:user_id>/', views.GetCarts.as_view()),
    path('like/<int:pk>/', views.LikeProductView.as_view()),
    path('unlike/<int:pk>/', views.UnlikeProductView.as_view()),
    path('liked-products/<int:user_id>/', views.LikedProductsView.as_view()),
]
