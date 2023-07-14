from django.conf import settings
from django.conf.urls.static import static
from django.urls import path

# from voyage.views.login import RegisterAPI
from .views.user_views import CreateUser

from .views import pubViews as views
from .views import chatViews as chat
from .views import authViews as user

urlpatterns = [
    # Publication
    path("publications/", views.publications, name="publications"),
    path("publication/<int:pk>", views.publication, name="publication"),
    path("publication/create/", views.pub_creation, name="pub_creation"),
    path("publication/update/<int:pk>", views.pub_update, name="pub_update"),
    path('publication/delete/<int:pk>', views.del_pub, name="del_pub"),
    path("pub/spec", views.pub_spec, name="pub_specification"),

    # Discussion
    path("chats/", chat.dicussions, name="dicussions"),
    path("chat/<int:pk>", chat.dicussion, name="dicussion"),
    path("chat/create/", chat.chat_creation, name="chat_creation"),
    path("chat/update/<int:pk>", chat.chat_update, name="chat_update"),
    path('chat/delete/<int:pk>', chat.del_chat, name="del_chat"),
    path('chat/history/<int:pk>', chat.chat_history, name="chat_history"),

    # User
    path('api/registration/', CreateUser.as_view()),
    path('api/users/', user.all_users, name='all_users'),
    path('api/create-user/', user.create_user, name="create_user"),
    path('api/get-user/<int:pk>', user.get_user, name="get_user"),
    path('api/update-user/<int:pk>', user.update_user, name="update_user"),
    path('api/delete-user/<int:pk>', user.delete_user, name="delete_user"),
    path('api/login/', user.login, name='login'),
    path('api/images/<str:filename>/', user.ImageView.as_view()),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)