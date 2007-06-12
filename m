Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:58176 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbXFLJ5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 05:57:03 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id DF0AC8D761
	for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2007 11:56:57 +0200 (CEST)
Message-Id: <20070612095657.975137760@warmcat.com>
References: <20070612095551.323709697@warmcat.com>
Date: Tue, 12 Jun 2007 10:55:53 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: Andy Green <andy@warmcat.com>
Subject: [PATCH Try#10 2/4] mac80211: Define present bitmap extend bit mask
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Used to detect if the field presence mask is extended

Signed-off-by: Andy Green <andy@warmcat.com>

---
 include/net/ieee80211_radiotap.h |    2 ++
 1 file changed, 2 insertions(+)

Index: wireless-dev/include/net/ieee80211_radiotap.h
===================================================================
--- wireless-dev.orig/include/net/ieee80211_radiotap.h
+++ wireless-dev/include/net/ieee80211_radiotap.h
@@ -90,6 +90,8 @@ struct ieee80211_radiotap_header {
 				 */
 };
 
+#define IEEE80211_RADIOTAP_PRESENT_EXTEND_MASK 0x80000000
+
 /* Name                                 Data type    Units
  * ----                                 ---------    -----
  *

-- 
