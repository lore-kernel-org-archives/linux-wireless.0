Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55841 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2KLV65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:58:57 -0500
Received: by mail-ea0-f174.google.com with SMTP id o11so438714eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:58:56 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 05/17] Simplified function GetSupportedWirelessMode8185()
Date: Mon, 12 Nov 2012 23:58:19 +0200
Message-Id: <1352757511-26957-6-git-send-email-maxtram95@gmail.com> (sfid-20121112_225901_101546_D24B434E)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8185b_init.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/r8185b_init.c b/r8185b_init.c
index 1ab8513..0b5c34b 100644
--- a/r8185b_init.c
+++ b/r8185b_init.c
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

