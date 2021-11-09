![](https://github.com/nkzwlab/SmileX-client/workflows/Flutter%20CI/badge.svg)

# Smile-City-Report-App
## Overview
Smartphones have become popular for people all over the world. In addition, people used to use Social Networking Services (SNS).
SmileCityReport application proposes a new value for people via the applications. 
SmileCityReport proposes characteristic communication for users.

This is the timeline page. The header indicates the theme of a theme.
many icons are shown the friends of joining the same theme.

The main part of a timeline of the SmileCityReport describes the photo.
Users can share their taken pictures among friends, and users can comment on each post.
This comment can translate automatically into English, Spanish, and Japanese, so users in a different country can communicate via this application.

<img width="331" alt="スクリーンショット 2021-11-09 22 54 27" src="https://user-images.githubusercontent.com/13267712/140936598-d20cad53-cc7a-4286-ab40-3c1e4121c67a.png">
  
In addition, this application connects some web APIs. These are the posting page.  
When you take a photo with this application, it takes a background camera and front camera.
The front camera's photo includes your face, so you can delete it freely.
If you upload the front camera's photo, your smile degree is stored database.  
<img width="331" alt="スクリーンショット 2021-11-09 23 01 01" src="https://user-images.githubusercontent.com/13267712/140937647-2475aac5-290d-4193-a05f-76a92db159fa.png">  

In addition, you turn on (a) "Ganonymize the scene photo" and (b) "Distribute your report to the IoT Marketplace".
If you turn on (a), you use the function on Ganonymizer (https://github.com/MSec-H2020/GANonymizer).
This means this application can upload data removed privacy information! This is a very strong point.  

Besides, if you turn on (b), you upload the photo to the IoT-Marketplace (https://github.com/MSec-H2020/IoT_Marketplace) via the SOXFire (https://github.com/MSec-H2020/Secure_SOXFire) and the SOXStore-server (https://github.com/MSec-H2020/SOXStore-Server).

These features are only SmileCityReport! 

<img width="331" alt="スクリーンショット 2021-11-09 23 01 34" src="https://user-images.githubusercontent.com/13267712/140937714-a2163863-eecd-4cd7-bd33-5136b85f8eb9.png">

## System Architecture
SmileCityReport connects to several servers, but all of them are implemented in M-Sec Project, so if you want to use them, you can download them on this project.

The following image just discribes connecting the SmileCityServer.
About the server application of SmileCityReport describe this page. (https://github.com/MSec-H2020/Smile-City-Report-Server)
<img width="952" alt="smilecityreport_system_architecture" src="https://user-images.githubusercontent.com/13267712/140935922-8ffcd802-d9f9-431a-a76f-589f8fee0ede.png">

In addition, if you want to connect Ganonymizer, SOXFire, and IoT-Marketplace, you must download each program, and you have to modify the configuration of all of them.
If you don't modify them, those application doesn't run correctly.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


## Environment (master)
Doctor summary (to see all details, run flutter doctor -v):

[✓] Flutter (Channel unknown, 2.0.3, on macOS 11.2.3 20D91 darwin-x64, locale ja-JP)

[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.3)

[✓] Xcode - develop for iOS and macOS

[✓] Chrome - develop for the web

[✓] Android Studio (version 4.1)

[✓] IntelliJ IDEA Ultimate Edition (version 2020.3.3)

[✓] IntelliJ IDEA Community Edition (version 2020.3.3)

[✓] Connected device (1 available)

• No issues found!

## Enviornment (gym)
Flutter version 1.22.6


