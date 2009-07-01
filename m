Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35994 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbZGATgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:36:00 -0400
Message-Id: <20090701193420.585201739@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:53 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/20 v4] wireless: define AKM suites
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We'll need these values for some drivers using connect API
and for wext compat code, so let's define them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h |    4 ++++
 1 file changed, 4 insertions(+)

--- wireless-testing.orig/include/linux/ieee80211.h	2009-07-01 08:55:05.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2009-07-01 09:01:21.000000000 +0200
@@ -1196,6 +1196,10 @@ enum ieee80211_sa_query_action {
 #define WLAN_CIPHER_SUITE_WEP104	0x000FAC05
 #define WLAN_CIPHER_SUITE_AES_CMAC	0x000FAC06
 
+/* AKM suite selectors */
+#define WLAN_AKM_SUITE_8021X		0x000FAC01
+#define WLAN_AKM_SUITE_PSK		0x000FAC02
+
 #define WLAN_MAX_KEY_LEN		32
 
 /**

-- 

