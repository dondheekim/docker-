"""mysite URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url
from bookmark.views import *

urlpatterns = [

    url(r'^bookmark/$', BookmarkLV.as_view(), name='index'),
    url(r'^bookmark/(?P<pk>\d+)/$', BookmarkDV.as_view(), name='detail'),
    url(r'^add/$', BookmarkCreateView.as_view(), name='add'),
    url(r'^change/$', BookmarkChangeLV.as_view(), name='change'),
    url(r'^/(?P<pk>[0-9]+)/update/$', BookmarkUpdateView.as_view(), name='update'),
    url(r'^/(?P<pk>[0-9]+)/delete/$', BookmarkDeleteView.as_view(), name='delete'),

]