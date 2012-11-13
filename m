Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54986 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2KMR26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:28:58 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so4133183eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:28:57 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 05/17] staging: rtl8187se: Simplified function GetSupportedWirelessMode8185()
Date: Tue, 13 Nov 2012 19:28:11 +0200
Message-Id: <1352827703-4659-6-git-send-email-maxtram95@gmail.com> (sfid-20121113_182909_794819_DB9F812F)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed unnecessary variable in GetSupportedWirelessMode8185() and
shortened its code

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8185b_init.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 8fa42de..cf9bcd5 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -927,10 +927,7 @@ static void MacConfig_85BASIC(struct net_device *dev)
 
 u8 GetSupportedWirelessMode8185(struct net_device *dev)
 {
-	u8 btSupportedWirelessMode = 0;
-
-	btSupportedWirelessMode = (WIRELESS_MODE_B | WIRELESS_MODE_G);
-	return btSupportedWirelessMode;
+	return WIRELESS_MODE_B | WIRELESS_MODE_G;
 }
 
 void ActUpdateChannelAccessSetting(struct net_device *dev,
-- 
1.7.10.4

