Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48890 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761158AbaGYTwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:52:43 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so1536638wib.14
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:52:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/12] staging: vt6656: change driver version to mac80211
Date: Fri, 25 Jul 2014 20:51:52 +0100
Message-Id: <1406317916-21884-8-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215248_160388_EFD20C53)
In-Reply-To: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
References: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 2ec086c..5a7ca52 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -81,7 +81,7 @@
 #define DEVICE_NAME			"vt6656"
 #define DEVICE_FULL_DRV_NAM		"VIA Networking Wireless LAN USB Driver"
 
-#define DEVICE_VERSION			"1.19_12"
+#define DEVICE_VERSION			"mac80211"
 
 #define CONFIG_PATH			"/etc/vntconfiguration.dat"
 
-- 
2.0.1

