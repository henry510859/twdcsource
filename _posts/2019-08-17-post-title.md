---
layout: post
title: "使用 Jamf 與 classroom 管理 macOS"
date: 2019-08-17 06:38:38
image: 'https://res.cloudinary.com/dm7h7e8xj/image/upload/c_fill,h_399,w_760/v1501268554/sunrise_ttb9nk.jpg'
description:
category: 'blog'
tags:
- blog
twitter_text:
introduction:
---
macOS 
在要開始進行管理之前，先確定要管理的所有 Mac 裝置都已進入監管

App 購買＆派送
Mac 都確定有進入監管之後我們就可以開始為每一台 Mac 或是特定的 Mac 安裝 App。
我們首先要先進入 Apple Business Manager 或是 Apple School Manager  
點選 App 頁面，搜尋課堂後點選，填寫需要的數量來購買。 
課堂只需要在老師的 Mac 下載，學生的不需要。
進入 Jamf 管理頁面，點選 Computers ，點選選單裡的 Mac App  Store Apps。 
點選剛才購買的 classroom (課堂）

點選右下角 Edit 來變更設定 
把 Distribution Method 的設定改成 Install Automatically/Prompt Users to install，這樣子課堂 App 才會自動下載到 Mac 裡。   

再來選擇要派送課堂 App 的電腦，點選 Scope，再點選右下角 Edit 

在 Target Computers 中選擇 Specific Computers ，並且新增要派送 App 的電腦，完成之後點選 Save。
 課堂 classroom 只需要在教師的 Mac 安裝 

再來點選 VPP，把 Assign VPP Content 勾選起來之後點選  Save，這樣App 才會自動派發到指定的裝置進行下載。

建立教師以及學生使用者
在建立教師以及學生使用者之前，先到教師以及學生的 Mac  把使用者帳號名稱記起來。
先打開系統偏好設定，點選使用者與群組。


再來我們要在 Jamf 的系統裡面建立教師與學生的使用者，等等才可以指定到課堂裡面。
打開 Jamf ，點選 Users，選擇 Search Users，再來點選 Search。 
使用者顯示出來之後，點選右邊的 ＋New  來新增教師以及學生。


在 Username 填入剛才的使用者帳戶名稱，Email Address 填入學校的Email，完成之後點選 Save。 
只要新增新的電腦就要增加使用者，建議一台 Mac 只設定一個使用者。


建立課堂
再來我們要在 Jamf 裡面建立課堂，這樣老師以及學生的 Mac 就可以自動加入到課堂 classroom 裡面。 
打開 Jamf ，點選 Computers ，選擇 Classes ，點選 ＋New。
 
在 Display Name 裡面輸入課堂名稱，完成之後點選 Save 。
再來選擇 Students，把剛才建立的學生使用者勾選起來，完成後點選  Save。

再來選擇 Teachers，把剛才建立的教師使用者勾選起來，完成後點選  Save。


大功告成，再來只要打開教師 Mac 的課堂 App  就可以看到學生加入了。


疑難排解

Ｑ：為什麼我的課堂沒有在課堂 App 裡面顯示出來？
Ａ：先確定在系統偏好設定裡面的描述檔有 EDU 教育設定描述檔，
      如果沒有出現的話請打開 terminal ，輸入下列指令
	sudo Jamf recon
      再重新進入描述檔裡面查看有沒有出現EDU 教育設定描述檔。 
