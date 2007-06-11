Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:38982 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757651AbXFKJ6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 05:58:48 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id D2E1D8D759
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2007 11:58:44 +0200 (CEST)
Message-Id: <20070611095846.408686769@warmcat.com>
References: <20070611095400.206844675@warmcat.com>
Date: Mon, 11 Jun 2007 10:54:02 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: Andy Green <andy@warmcat.com>
Subject: [PATCH Try#8 2/4] mac80211: Define present bitmap extend bit mask
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
