---
layout: post
title: "使用Let's Encrypt 來申請憑證並且建立憑證鍊 "
date: 2020-01-15 11:00:00
image: '![cover_photo](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/cover_photo.jpg)'
description:
category: 'Certificate'
tags:
- Let's Encrypt
- certificate
introduction:
---

# 使用Let's Encrypt 來申請憑證並且建立憑證鍊
---
## 憑證是什麼？

在網際網路這個世界中，所有人都可以購買網域來建立伺服器，能夠讓大家透過網域來進行瀏覽網站或使用各種服務，但是在這之間安全是很重要的，要如何確認是不是安全的呢？

上一篇 802.1x 文章中有介紹如何建立自簽憑證（self-sign certificate)，但是在網際網路中使用自簽憑證是非常不安全的，必須要由 **數位憑證認證機構** 所簽發的憑證才是安全，這篇教學就要來教大家如何向信任機構申請憑證以及建立憑證串鍊。

## 什麼是 Let's Encrypt

[Let's Encrypt](https://letsencrypt.org/zh-tw/) 是由非營利性網際網路安全研究小組，他提供了免費、自動化且開放的憑證頒發機構，缺點是  **90天** 會過期，所以請務必在 90 天前更新憑證。

一般在申請憑證的時候必須先建立 CSR 檔案來向數位憑證認證機構來購買憑證，Let's Encrypt 必須要先熟悉 UNIX 指令才能夠在主機下指令來取得憑證，雖然不難，但是對於從來沒有使用過會需要一些時間來熟悉。

好在有開發者推出了一款線上工具 [SSL For Free](https://www.sslforfree.com/)，可以簡單而且快速的申請到 Let's Encrypt 憑證。

## 向 Let's Encrypt 申請憑證

在向 Let's Encrypt 申請憑證前，請先確定要申請的網域是自己所有，因為在後續的教學會需要進入到網域的 DNS 管理介面去新增資料來驗證網域。

▼ 打開 [SSL For Free](https://www.sslforfree.com) 線上工具
![sslforfree1](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree1.png)
▼ 在網址列輸入網域名稱(這邊以 TWDC 的官網來做示範，輸入完成後點選 Create Free SSL Certificate
![sslforfree2](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree2.png)
▼ 這個網站提供了 ３種驗證方式，Automatic FTP Verification是當主機有開啟 FTP 服務就可以使用、Manual Verification是把檔案放入主機內來驗證，Manual Verification(DNS)就是在DNS 管理頁面中新增 TXT 記錄來驗證，本教學以這個方法進行驗證
![sslforfree3](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree3.png)
▼ 點選 Manually Verify Domain
![sslforfree4](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree4.png)
▼ 另外打開您購買網域的 DNS 管理，點選新增 TXT record
![sslforfree5](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree5.png)
▼ 複製第一個欄位
![sslforfree6](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree6.png)
▼ 在 hostname 的位置貼上
![sslforfree7](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree7.png)
▼ 複製第二個欄位
![sslforfree8](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree8.png)
▼ 在 value 的位置貼上
![sslforfree9](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree9.png)
▼ TTL 設定為 1 小時
![sslforfree10](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree10.png)
▼ 點選 Save
![sslforfree11](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree11.png)
▼ 每個 DNS 紀錄更新的時間不一定，可以點選下面的連結確認 DNS 是否有更新
![sslforfree12](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree12.png)
▼ 確認更新後就可以點選 Download SSL Certificate
![sslforfree13](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree13.png)
▼ 這裡可以申請帳號當憑證快要到期時會發信通知您記得更新
![sslforfree14](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree14.png)
▼ 從網頁最下方點選 Download All SSL Certificate Files
![sslforfree15](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree15.png)
▼ 下載檔案會有三個
![sslforfree16](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/sslforfree16.png)
1. ca_bundle.crt 為根憑證(Root CA certificate)＋中繼憑證(Intermediate CA certificate)
2. certificate.crt 為憑證(Server certificate)
3. private.key 為私鑰

當出現這些檔案的時候憑證就申請成功囉，不過要放到伺服器還需要使用 openSSL 建立憑證鏈才會是安全的。

## 憑證鍊(Certificate Chain)

憑證鍊是大家比較陌生但是對於安全來說是非常重要的，為了要驗證網域憑證的有效性，還需要藉由驗證憑證機構的憑證之有效性，來確認該憑證機構所簽發憑證之有效性，如果該憑證機構的憑證又是由其他憑證機構所簽發的，則必須再驗證上一層憑證機構的憑證之有效性，不斷的重複此驗證步驟，一直驗證到根憑證機構為止(Root CA certificate)。

看起來很複雜，舉個例子來看
首先，打開 Safari 找一個有 https 的網址，例如 https://aatp.com.tw ，點擊網址旁邊的鎖頭，點選 Show Certificate，這時我們會看到一個階梯式架構，第一層就是根憑證(Root CA certificate)，根憑證會內建在網頁瀏覽器裡，第二層就是中繼憑證(Intermediate CA certificate)，第三層則是伺服器的憑證(Server certificate)
![aatp.com.tw](https://raw.githubusercontent.com/henry510859/TWDC_blog_photo/master/certificate%20chain/aatp.com.tw.png)

再來教大家如何從剛才向Let's Encrypt 申請憑證來建立憑證鍊

▼ 打開 Terminal(終端機)，輸入以下指令
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
▼ 安裝 openSSL
```
brew install openSSL
```
▼ 輸入合併憑證指令
```
cat ca_bundle.crt certificate.crt > chain.pem
```
▼ 如果伺服器要求必須把私鑰合併到憑證裡的可以輸入下列指令
```
openssl pkcs12 -in chain.pem -inkey private.key -export -out server.pfx -password pass:yourPassword
```
一般來說合併憑證必須照著順序 **根憑證 -> 中繼憑證 -> 憑證** 來合併，但是Let's Encrypt 已經先把根憑證跟中繼憑證合併了，所以只需要再合併憑證進去就可以囉。
