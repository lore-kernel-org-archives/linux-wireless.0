Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45838 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbbD0DNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2015 23:13:36 -0400
Message-ID: <553DA95E.7010406@infradead.org> (sfid-20150427_051611_280767_5C76737F)
Date: Sun, 26 Apr 2015 20:13:34 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] mac80211: fix 90 kernel-doc warnings
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Eliminate 90 of these warnings:

Warning(..//include/net/mac80211.h:1682): No description found for parameter 'drv_priv[0]'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 include/net/mac80211.h |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-41-rc1.orig/include/net/mac80211.h
+++ lnx-41-rc1/include/net/mac80211.h
@@ -1667,6 +1667,8 @@ struct ieee80211_tx_control {
  * @sta: station table entry, %NULL for per-vif queue
  * @tid: the TID for this queue (unused for per-vif queue)
  * @ac: the AC for this queue
+ * @drv_priv: data area for driver use, will always be aligned to
+ *	sizeof(void *).
  *
  * The driver can obtain packets from this queue by calling
  * ieee80211_tx_dequeue().
