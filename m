Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZF3Krm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 06:47:42 -0400
Subject: [PATCH] wireless: define AKM suites
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 12:47:42 +0200
Message-Id: <1246358862.16643.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We'll need these values for some drivers using connect API
and for wext compat code, so let's define them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h |    4 ++++
 1 file changed, 4 insertions(+)

--- wireless-testing.orig/include/linux/ieee80211.h	2009-06-30 12:46:11.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2009-06-30 12:46:18.000000000 +0200
@@ -1196,6 +1196,10 @@ enum ieee80211_sa_query_action {
 #define WLAN_CIPHER_SUITE_WEP104	0x000FAC05
 #define WLAN_CIPHER_SUITE_AES_CMAC	0x000FAC06
 
+/* AKM suite selectors */
+#define WLAN_AKM_SUITE_8021X		0x000FAC01
+#define WLAN_AKM_SUITE_PSK		0x000FAC02
+
 #define WLAN_MAX_KEY_LEN		32
 
 /**


