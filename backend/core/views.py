from rest_framework import generics, permissions, response, status, authentication
from rest_framework.settings import api_settings
from rest_framework.views import APIView
from rest_framework.authtoken.views import ObtainAuthToken, Token, Response
from . import serializer, models
from django.shortcuts import get_object_or_404




class RegisterUser(APIView):
    serializer_class = serializer.UserSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            # Create a new token for the user
            token, created = Token.objects.get_or_create(user=user)
            # You can customize the response as needed
            return Response(
                {
                    'token': token.key,
                    'message': 'User registered successfully.',
                },
                status=status.HTTP_201_CREATED
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class Login(ObtainAuthToken):
    serializer_class = serializer.AuthTokenSerializer
    renderer_classes = api_settings.DEFAULT_RENDERER_CLASSES


class UserInfoAPIView(generics.RetrieveAPIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user

        user_data = {
            'id': user.id,
            'email': user.email,
            'name':user.name
        }

        return response.Response(user_data, status=status.HTTP_200_OK)


class ListCategories(generics.ListAPIView):
    serializer_class = serializer.CategorySerializer
    queryset = models.Category.objects.all()


class ListProducts(generics.ListAPIView):
    serializer_class = serializer.ProductSerializer
    queryset = models.Product.objects.all()



class ProductDetail(generics.RetrieveAPIView):
    serializer_class = serializer.ProductSerializer
    queryset = models.Product.objects.all()
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        comments = models.Comment.objects.filter(product=instance)
        comment_serializer = serializer.CommentSerializer(comments, many=True)
        product_serializer = self.get_serializer(instance)
        return response.Response({
            'product': product_serializer.data,
            'comments': comment_serializer.data
        })


class FilterProducts(generics.ListAPIView):
    serializer_class = serializer.ProductSerializer
    
    def get_queryset(self):
        category_id = self.kwargs.get('category_id')  
        if category_id:
            return models.Product.objects.filter(category__id=category_id)
        else:
            return models.Product.objects.all()

 
 
    
class CreateOrder(generics.CreateAPIView):
    serializer_class = serializer.OrderSerializer
    permission_classes = [permissions.IsAuthenticated]


class ListOrders(generics.ListAPIView):
    serializer_class = serializer.OrderSerializer
    permission_classes = [permissions.IsAuthenticated]
    def get_queryset(self):
        
        user_id = self.kwargs.get('user_id')  
        return models.Order.objects.filter(user_id=user_id)


class CancelOrder(generics.DestroyAPIView):
    serializer_class = serializer.OrderSerializer
    permission_classes = [permissions.IsAuthenticated]
    queryset = models.Order.objects.all()
    def destroy(self, request, *args, **kwargs):
        try:
            instance = self.get_object()
            self.perform_destroy(instance)
            return response.Response(status=status.HTTP_204_NO_CONTENT)
        except models.Order.DoesNotExist:
            return response.Response({"detail": "Cart not found."}, status=status.HTTP_404_NOT_FOUND)

    def perform_destroy(self, instance):
        instance.delete()


class ListComment(generics.ListAPIView):
    serializer_class = serializer.CommentSerializer

    def get_queryset(self):
        comment_pk = self.kwargs.get('pk')
        return models.Comment.objects.filter(product_id=comment_pk)



class CreateComment(generics.CreateAPIView):
    serializer_class = serializer.CommentSerializer
    permission_classes = [permissions.IsAuthenticated]


class DeleteComment(generics.DestroyAPIView):
    serializer_class = serializer.CommentSerializer  
    permission_classes = [permissions.IsAuthenticated]

    
    def get_object(self):
        comment_id = self.kwargs.get('pk')  
        return models.Comment.objects.get(pk=comment_id)



class AddCart(generics.CreateAPIView):
    serializer_class = serializer.CartSerializer
    permission_classes = [permissions.IsAuthenticated]

    def create(self, request, *args, **kwargs):
        product_id = request.data.get('product', None)

        
        cart_entry = models.Cart.objects.filter(user_id=request.user.id, product_id=product_id).first()

        if cart_entry:
        
            cart_entry.count += 1
            cart_entry.save()
        else:
        
            if request.user.id is not None:
                cart_entry = models.Cart.objects.create(user_id=request.user.id, product_id=product_id, count=1)
        

        
        serializer = self.get_serializer(cart_entry)
        headers = self.get_success_headers(serializer.data)

        return response.Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)






class ReduceCartItemAPIView(generics.UpdateAPIView):
    serializer_class = serializer.CartSerializer
    permission_classes = [permissions.IsAuthenticated]

    def update(self, request, *args, **kwargs):
        try:
            cart_entry = models.Cart.objects.get(user_id=request.user.id, product_id=self.kwargs['product_id'])

            if cart_entry.count > 1:
                cart_entry.count -= 1
                cart_entry.save()

                serializer = self.get_serializer(cart_entry)
                return response.Response(serializer.data, status=status.HTTP_200_OK)
            else:
                cart_entry.delete()
                return response.Response({"detail": "Cart entry deleted successfully."}, status=status.HTTP_200_OK)

        except models.Cart.DoesNotExist:
            return response



class DeleteCart(generics.DestroyAPIView):
    serializer_class = serializer.CartSerializer
    permission_classes = [permissions.IsAuthenticated]
    queryset = models.Cart.objects.all()

    def destroy(self, request, *args, **kwargs):
        try:
            instance = self.get_object()
            self.perform_destroy(instance)
            return response.Response(status=status.HTTP_204_NO_CONTENT)
        except models.Cart.DoesNotExist:
            return response.Response({"detail": "Cart not found."}, status=status.HTTP_404_NOT_FOUND)

    def perform_destroy(self, instance):
        instance.delete()


class GetCarts(generics.ListAPIView):
    serializer_class = serializer.CartSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user_id = self.kwargs.get('user_id') 

        return models.Cart.objects.filter(user_id=user_id)
    
    
    
class LikeProductView(generics.UpdateAPIView):
    serializer_class = serializer.ProductSerializer
    permission_classes = [permissions.IsAuthenticated]
    queryset = models.Product.objects.all()

    def update(self, request, *args, **kwargs):
        product = self.get_object()
        user = self.request.user  # Assuming user is authenticated
        product.is_liked = True
        product.save()
        user.liked_products.add(product)
        return Response({'is_liked': True}, status=status.HTTP_200_OK)

class UnlikeProductView(generics.UpdateAPIView):
    queryset = models.Product.objects.all()
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = serializer.ProductSerializer

    def update(self, request, *args, **kwargs):
        product = self.get_object()
        user = self.request.user  # Assuming user is authenticated
        product.is_liked = False
        product.save()
        user.liked_products.remove(product)
        return Response({'is_liked': False}, status=status.HTTP_200_OK)

class LikedProductsView(generics.ListAPIView):
    serializer_class = serializer.ProductSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user_id = self.kwargs['user_id']
        user = get_object_or_404(models.User, pk=user_id)
        return user.liked_products.all()