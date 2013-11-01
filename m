Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:53228 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3KATga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 15:36:30 -0400
Received: by mail-ea0-f170.google.com with SMTP id q10so1855452eaj.29
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 12:36:29 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 3/3] mac80211_hwsim: VHT add 160MHz width support
Date: Fri,  1 Nov 2013 20:36:00 +0100
Message-Id: <1383334560-10672-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131101_203633_420654_3964F204)
In-Reply-To: <1383334560-10672-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1383334560-10672-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 160MHz width support. This could be
usefull for testing VHT160 and DFS functionality.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 085d165..1d4e3e3 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2387,6 +2387,7 @@ static int __init init_mac80211_hwsim(void)
 			sband->vht_cap.cap =
 				IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
 				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
+				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ |
 				IEEE80211_VHT_CAP_RXLDPC |
 				IEEE80211_VHT_CAP_SHORT_GI_80 |
 				IEEE80211_VHT_CAP_SHORT_GI_160 |
-- 
1.7.9.5

