Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49362 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab3HAGSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 02:18:48 -0400
Received: by mail-pd0-f172.google.com with SMTP id z11so888924pdj.3
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 23:18:48 -0700 (PDT)
From: Fred Zhou <fred.zy@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Fred Zhou <fred.zy@gmail.com>
Subject: [PATCH] ieee80211: add definition for 802.11ac information elements
Date: Thu,  1 Aug 2013 14:16:28 +0800
Message-Id: <1375337788-6822-1-git-send-email-fred.zy@gmail.com> (sfid-20130801_081851_982870_92A81D55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added element IDs for Extended BSS Load, VHT TX Power Envelope, AID, and Quiet Channel

Signed-off-by: Fred Zhou <fred.zy@gmail.com>
---
 include/linux/ieee80211.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b0dc87a..6b9e663 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1709,6 +1709,10 @@ enum ieee80211_eid {
 	WLAN_EID_OPMODE_NOTIF = 199,
 	WLAN_EID_WIDE_BW_CHANNEL_SWITCH = 194,
 	WLAN_EID_CHANNEL_SWITCH_WRAPPER = 196,
+	WLAN_EID_EXTENDED_BSS_LOAD = 193,
+	WLAN_EID_VHT_TX_POWER_ENVELOPE = 195,
+	WLAN_EID_AID = 197,
+	WLAN_EID_QUIET_CHANNEL = 198,
 
 	/* 802.11ad */
 	WLAN_EID_NON_TX_BSSID_CAP =  83,
-- 
1.7.9.5

