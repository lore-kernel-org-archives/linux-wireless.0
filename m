Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:50151 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935312Ab3E3LnP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 07:43:15 -0400
Received: by mail-bk0-f50.google.com with SMTP id ik5so82986bkc.23
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 04:43:13 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 May 2013 19:43:13 +0800
Message-ID: <CAPgLHd8NLmToy54gYtB-LKX9aKx59BnLBbH-Y6hp_6z-EQwq+A@mail.gmail.com> (sfid-20130530_134324_100973_D2762699)
Subject: [PATCH -next] cw1200: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: pizza@shaftnet.org, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/cw1200/cw1200_spi.c  | 1 -
 drivers/net/wireless/cw1200/cw1200_sdio.c | 1 -
 drivers/net/wireless/cw1200/cw1200.h      | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 04af685..ab7a2d5 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -13,7 +13,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>

diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
index f6e2219..c658f1b 100644
--- a/drivers/net/wireless/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -9,7 +9,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>

diff --git a/drivers/net/wireless/cw1200/cw1200.h b/drivers/net/wireless/cw1200/cw1200.h
index 2aa17ca..e9424e6 100644
--- a/drivers/net/wireless/cw1200/cw1200.h
+++ b/drivers/net/wireless/cw1200/cw1200.h
@@ -19,7 +19,6 @@
 #define CW1200_H
 
 #include <linux/wait.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <net/mac80211.h>

