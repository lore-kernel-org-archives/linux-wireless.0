Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22226 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1KBVgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 17:36:07 -0400
Date: Wed, 2 Nov 2011 23:34:56 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ieee80211: Define cipher suite selector for WPI-SMS4
Message-ID: <20111102213456.GA21460@jouni.qca.qualcomm.com> (sfid-20111102_223612_433280_323897C8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This value is used for WPI-SMS4 in ISO/IEC JTC 1 N 9880.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/linux/ieee80211.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 48363c3..80cba03 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1552,6 +1552,8 @@ enum ieee80211_sa_query_action {
 #define WLAN_CIPHER_SUITE_WEP104	0x000FAC05
 #define WLAN_CIPHER_SUITE_AES_CMAC	0x000FAC06
 
+#define WLAN_CIPHER_SUITE_SMS4		0x00147201
+
 /* AKM suite selectors */
 #define WLAN_AKM_SUITE_8021X		0x000FAC01
 #define WLAN_AKM_SUITE_PSK		0x000FAC02
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
