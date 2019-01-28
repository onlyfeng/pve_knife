# pve_knife
一些让操作Proxmox更简单的jio本

# 功能
* 替换企业版源为社区源  
* 替换Debian更新源为国内镜像(阿里云)  
* 替换完成,后升级系统(可选)  
* SNIProxy反代升级服务器(可选)  
* 安装常用的命令  
* 在bash配置文件里用别名添加对rm cp mv命令执行时的确认  
* 去除登陆的时候那个没有订阅的弹窗  
* 加快SSH登陆(去掉UseDNS)  

# 写出来但是还没有加入到菜单的功能 
* 快速安装NodeJS(可选附加Yarn,可选切换至清华源) 
* 为NodeJS启用淘宝镜像(可选)
* 快速安装Docker

# 接下来的计划
* 支持快速安装更多的软件(Webmin,Portainer,FRP,Syncthing)
* 将写好的功能摆到菜单里
* 实现IP检测,自动判断国内外并且使用相应的源
* 实现检测函数文件是否存在,若不存在则下载,使脚本更加精简(参考LinuxGSM的思想)

# 食用方法
克隆本项目,执行pve_knife.sh即可.会有菜单让你选择
