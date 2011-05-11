Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35960 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab1EKQSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:18:06 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p4B9DDqN000685
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 04:13:13 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: Add Notification to 80211h support
Date: Wed, 11 May 2011 12:12:56 +0300
Message-Id: <1305105176-12427-1-git-send-email-shahar_levi@ti.com> (sfid-20110511_181817_012465_7E903222)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set Spectrum Management Bit in association request in
order to support 80211h spec

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7126506..2618a57 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3536,6 +3536,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_CONNECTION_MONITOR |
 		IEEE80211_HW_SUPPORTS_CQM_RSSI |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_AP_LINK_PS;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
-- 
1.7.0.4

