Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:45541 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965921AbXDIPxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 11:53:37 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 95F628D131
	for <linux-wireless@vger.kernel.org>; Mon,  9 Apr 2007 17:53:31 +0200 (CEST)
Message-Id: <20070409155335.414073189@warmcat.com>
References: <20070409154802.470925215@warmcat.com>
Date: Mon, 09 Apr 2007 16:48:06 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: Andy Green <andy@warmcat.com>
Subject: [PATCH 4/7] mac80211: Define present bitmap extend bit mask
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
