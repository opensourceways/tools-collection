# Create Image

# 目录

 * [介绍](#introduction)
 * [用法](#usage)
   * [前置条件](#preconditions)
   * [开始使用](#start_use)

## 介绍 <a id ="introduction"/>

该文档是利用terraform来自动创建镜像。镜像中包含了所需要的环境。这个镜像是提供给jenkins中的HuaweiCloud ECS plugin这个插件使用的



## 使用<a id="usage"/>

### 前置条件 <a id="preconditions"/>

开始使用之前，您应具备以下条件：



1. [华为云 AccessKey/SecretKey/region](https://support.huaweicloud.com/devg-apisign/api-sign-provide-aksk.html)

  ![image](https://user-images.githubusercontent.com/78532744/137423308-202d5c2e-5dcd-44fa-a83a-0ebe8e4dddd7.png)

   

2. 创建密钥对，获取私钥和公钥信息

![image](https://user-images.githubusercontent.com/78532744/137423328-25b51e17-b47c-40a9-8039-d4c6a4da70ac.png)

3.子网

![image](https://user-images.githubusercontent.com/78532744/137423353-b5d3d8f1-fc9a-4d2c-bcf4-dcacc7208c55.png)


![image](https://user-images.githubusercontent.com/78532744/137423388-fb4e18c5-8792-4f68-95d7-a2e34b50913c.png)









### 开始使用 <a id="start_use"/>

#### 步骤一：在jenkins安装并配置HuaweiCloud ECS plugin

1. 在GitHub上搜索huaweicloud-ecs-plugin

   ![image](https://user-images.githubusercontent.com/78532744/137423433-2ede9922-8d3e-4480-86b8-1cb621b1a88e.png)

   2. 在jenkins按照插件文档配置，配置完成继续下一步操作

#### 步骤二：在jenkins中创建一个job，在job完成配置

进行参数化构建，创建5个密码参数ak/sk/public/region/subnet，第一个ak是华为云 AccessKey，第二个sk指的是SecretKey，第三个public为密钥对中公钥内容，第四个region指的是华为云的区域，第5个指的是子网的名字

![image](https://user-images.githubusercontent.com/78532744/137423493-556e08f0-add4-44d1-85c9-d05cedde81fe.png)


之后配置私钥，这些参数在shell中有使用，如果改变名字需要在shell中也一起改变

![image](https://user-images.githubusercontent.com/78532744/137423509-5ee9682c-39df-4288-ab80-5018c42b3b69.png)

​       

#### 步骤三：在shell中添加脚本信息，然后对这个job进行构建

​         
![image](https://user-images.githubusercontent.com/78532744/137423549-56cc6de2-2f13-484b-9b23-88e41e9ee35d.png)

![image](https://user-images.githubusercontent.com/78532744/137423571-1b3e1e12-cc92-42ca-a4bb-54591c5a44bd.png)

​      将job.txt内容复制到shell中，之后构建job











​     









