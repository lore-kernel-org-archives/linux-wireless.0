Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34957 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbcCHOSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 09:18:04 -0500
Received: by mail-pf0-f169.google.com with SMTP id x188so13929669pfb.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 06:18:04 -0800 (PST)
From: Moroo Akira <retrage01@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Akira Moroo <retrage01@gmail.com>
Subject: [PATCH] Fix typo in cfg80211.h
Date: Tue,  8 Mar 2016 23:17:42 +0900
Message-Id: <1457446662-27437-1-git-send-email-retrage01@gmail.com> (sfid-20160308_151809_867812_D2702EA5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Akira Moroo <retrage01@gmail.com>

This patch fix a structure name typo in cfg80211.h.

Signed-off-by: Moroo Akira <retrage01@gmail.com>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9bcaaf7..9570ade 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1609,17 +1609,17 @@ enum cfg80211_signal_type {
 struct cfg80211_inform_bss {
 	struct ieee80211_channel *chan;
 	enum nl80211_bss_scan_width scan_width;
 	s32 signal;
 	u64 boottime_ns;
 };
 
 /**
- * struct cfg80211_bss_ie_data - BSS entry IE data
+ * struct cfg80211_bss_ies - BSS entry IE data
  * @tsf: TSF contained in the frame that carried these IEs
  * @rcu_head: internal use, for freeing
  * @len: length of the IEs
  * @from_beacon: these IEs are known to come from a beacon
  * @data: IE data
  */
 struct cfg80211_bss_ies {
 	u64 tsf;
-- 
2.4.10

