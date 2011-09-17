Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32772 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab1IQWQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 18:16:56 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so2775973fxe.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2011 15:16:55 -0700 (PDT)
From: Alexander Simon <an.alexsimon@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Simon <an.alexsimon@googlemail.com>
Subject: [PATCH v3 1/1] mac80211: fix indentation
Date: Sun, 18 Sep 2011 00:16:45 +0200
Message-Id: <75426bb99dfa5cca7ae3b3ed9fbf955bb9b8d564.1316297749.git.an.alexsimon@googlemail.com> (sfid-20110918_001659_597713_C3D42941)
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Alexander Simon <an.alexsimon@googlemail.com>
---
 include/net/mac80211.h |    2 +-
 net/mac80211/ibss.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9edba09..c0f63fd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -171,7 +171,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_ERP_CTS_PROT	= 1<<1,
 	BSS_CHANGED_ERP_PREAMBLE	= 1<<2,
 	BSS_CHANGED_ERP_SLOT		= 1<<3,
-	BSS_CHANGED_HT                  = 1<<4,
+	BSS_CHANGED_HT			= 1<<4,
 	BSS_CHANGED_BASIC_RATES		= 1<<5,
 	BSS_CHANGED_BEACON_INT		= 1<<6,
 	BSS_CHANGED_BSSID		= 1<<7,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 56c24ca..836b275 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -417,7 +417,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
  * must be callable in atomic context.
  */
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid,u8 *addr, u32 supp_rates,
+					u8 *bssid, u8 *addr, u32 supp_rates,
 					gfp_t gfp)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-- 
1.7.3.4

