# EPlay
跟其他启动器比起来，EPlay只是个小玩具
# 本项目由 [YxVM](https://yxvm.com/) 赞助
高性能稳定VPS，就选YxVm！
# EPlay代码请使用reopenlua+运行！
# 移植教程仅适用于Release中的Apk，其他方法自行摸索

0. 准备工作 MT管理器 ApkEditor(同类型apk编辑器都行) 下载好Release中的Apk 游戏图标 解压好的游戏文件 
1. 打开ApkEditor，选择下载好的Apk，选择通用编辑
2. 自行修改图标，软件名称，安装包名，版本号，版本名(其他就不要动)，然后保存(不要安装！)
3. MT管理器打开目录/storage/emulated/0/ApkEditor/tmp/
4. 找到刚刚编辑过的Apk(不知道怎么找就按最新时间找)然后点击，再点查看
5. 打开assets文件夹，将图标文件名修改为icon.png，然后放入
6. 复制一个Apk作为副本，并改名为launcher.apk，然后放入未改名的Apk的assets文件夹中
7. 修改Apk的assets文件夹中的init.lua中的appname，packagename，appver为游戏名，第二步的安装包名，游戏版本
8. 找到解压的游戏文件，找到index.html所在的文件夹，将该文件夹名修改为game，并将该文件夹(game放入Apk的assets文件夹) 此时的index.html应该路径应该是/assets/game/index.html
9. 应该没有了，大概？
后面空了再完善