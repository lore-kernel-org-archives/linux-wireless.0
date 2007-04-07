Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:45158 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965780AbXDGKvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 06:51:42 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 11F528D149
	for <linux-wireless@vger.kernel.org>; Sat,  7 Apr 2007 12:51:37 +0200 (CEST)
Message-Id: <20070407105139.214467168@warmcat.com>
References: <20070407105058.762762192@warmcat.com>
Date: Sat, 07 Apr 2007 11:51:03 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: Andy Green <andy@warmcat.com>
Subject: [PATCH 5/7] mac80211: Define present bitmap extend bit mask
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy@warmcat.com>

Signed-off-by: Andy Green <andy@warmcat.com>

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index a0c2b41..44024a3 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -90,6 +90,8 @@ struct ieee80211_radiotap_header {
 				 */
 };
 
+#define IEEE80211_RADIOTAP_PRESENT_EXTEND_MASK 0x80000000
+
 /* Name                                 Data type    Units
  * ----                                 ---------    -----
  *

-- 
