Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35907 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbbIOFHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:45 -0400
Received: by padhk3 with SMTP id hk3so164835299pad.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:45 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 18/18] staging: wilc1000: wilc_wfi_cfgoperations.h: align defines
Date: Tue, 15 Sep 2015 14:06:28 +0900
Message-Id: <1442293588-15323-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_071652_950343_054D7798)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix alignment of some defines in wilc_wfi_cfgoperations.h

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 44 +++++++++++------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 28858da..5fd0757 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -23,34 +23,34 @@
 #ifdef WILC_P2P
 
 /*Public action frame index IDs*/
-#define		FRAME_TYPE_ID					0
-#define		ACTION_CAT_ID					24
-#define		ACTION_SUBTYPE_ID				25
-#define		P2P_PUB_ACTION_SUBTYPE          30
+#define FRAME_TYPE_ID			0
+#define ACTION_CAT_ID			24
+#define ACTION_SUBTYPE_ID		25
+#define P2P_PUB_ACTION_SUBTYPE		30
 
 /*Public action frame Attribute IDs*/
-#define		ACTION_FRAME					0xd0
-#define		GO_INTENT_ATTR_ID			0x04
-#define		CHANLIST_ATTR_ID		0x0b
-#define		OPERCHAN_ATTR_ID                0x11
-#define		PUB_ACTION_ATTR_ID			0x04
-#define		P2PELEM_ATTR_ID                     0xdd
+#define ACTION_FRAME			0xd0
+#define GO_INTENT_ATTR_ID		0x04
+#define CHANLIST_ATTR_ID		0x0b
+#define OPERCHAN_ATTR_ID		0x11
+#define PUB_ACTION_ATTR_ID		0x04
+#define P2PELEM_ATTR_ID			0xdd
 
 /*Public action subtype values*/
-#define		GO_NEG_REQ					0x00
-#define		GO_NEG_RSP					0x01
-#define		GO_NEG_CONF					0x02
-#define		P2P_INV_REQ                         0x03
-#define		P2P_INV_RSP				0x04
-#define		PUBLIC_ACT_VENDORSPEC		0x09
-#define		GAS_INTIAL_REQ					0x0a
-#define		GAS_INTIAL_RSP					0x0b
+#define GO_NEG_REQ			0x00
+#define GO_NEG_RSP			0x01
+#define GO_NEG_CONF			0x02
+#define P2P_INV_REQ			0x03
+#define P2P_INV_RSP			0x04
+#define PUBLIC_ACT_VENDORSPEC		0x09
+#define GAS_INTIAL_REQ			0x0a
+#define GAS_INTIAL_RSP			0x0b
 
-#define		INVALID_CHANNEL					0
+#define INVALID_CHANNEL			0
 #endif
 
 #define nl80211_SCAN_RESULT_EXPIRE	(3 * HZ)
-#define SCAN_RESULT_EXPIRE				(40 * HZ)
+#define SCAN_RESULT_EXPIRE		(40 * HZ)
 
 static const u32 cipher_suites[] = {
 	WLAN_CIPHER_SUITE_WEP40,
@@ -105,8 +105,8 @@ int WILC_WFI_deinit_mon_interface(void);
 struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev);
 
 #ifdef TCP_ENHANCEMENTS
-#define TCP_ACK_FILTER_LINK_SPEED_THRESH 54
-#define DEFAULT_LINK_SPEED 72
+#define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
+#define DEFAULT_LINK_SPEED			72
 void Enable_TCP_ACK_Filter(bool value);
 #endif
 
-- 
2.5.1

