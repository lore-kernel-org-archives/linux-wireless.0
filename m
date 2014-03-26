Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36838 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbaCZT5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 15:57:11 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so2079837eek.3
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 12:57:09 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 02/20] rtl8180: add rtl8187se chip type
Date: Wed, 26 Mar 2014 20:58:14 +0100
Message-Id: <1395863894-4368-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_205716_684323_78E6B7CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add back rtl8187se chip type to the enum for known chips.
This causes unhandled switch/case warning that will be fixed
in following patch

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
index ad64c5e..e7127f3 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
@@ -92,6 +92,7 @@ struct rtl8180_priv {
 	enum {
 		RTL818X_CHIP_FAMILY_RTL8180,
 		RTL818X_CHIP_FAMILY_RTL8185,
+		RTL818X_CHIP_FAMILY_RTL8187SE,
 	} chip_family;
 	u32 anaparam;
 	u16 rfparam;
-- 
1.8.3.2

