Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbaEZQGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 12:06:39 -0400
From: Jes.Sorensen@redhat.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] include/linux/ieee80211.h: Add missing WLAN_EID_BSS_INTOLERANT_CHL_REPORT
Date: Mon, 26 May 2014 18:06:34 +0200
Message-Id: <1401120394-22503-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20140526_180711_988780_4376D10C)
In-Reply-To: <1401120394-22503-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1401120394-22503-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 include/linux/ieee80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index f194ccb..6bff13f 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1711,6 +1711,7 @@ enum ieee80211_eid {
 	WLAN_EID_RRM_ENABLED_CAPABILITIES = 70,
 	WLAN_EID_MULTIPLE_BSSID = 71,
 	WLAN_EID_BSS_COEX_2040 = 72,
+	WLAN_EID_BSS_INTOLERANT_CHL_REPORT = 73,
 	WLAN_EID_OVERLAP_BSS_SCAN_PARAM = 74,
 	WLAN_EID_RIC_DESCRIPTOR = 75,
 	WLAN_EID_MMIE = 76,
-- 
1.9.3

