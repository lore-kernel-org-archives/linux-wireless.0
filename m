Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:34431 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646Ab0EUSam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 14:30:42 -0400
Date: Fri, 21 May 2010 11:28:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] wireless: fix sta_info.h kernel-doc warnings
Message-Id: <20100521112841.86d6757c.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sta_info.h kernel-doc warnings:

Warning(net/mac80211/sta_info.h:164): No description found for parameter 'tid_active_rx[STA_TID_NUM]'
Warning(net/mac80211/sta_info.h:164): Excess struct/union/enum/typedef member 'tid_state_rx' description in 'sta_ampdu_mlme'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/sta_info.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.34-git6.orig/net/mac80211/sta_info.h
+++ linux-2.6.34-git6/net/mac80211/sta_info.h
@@ -145,7 +145,7 @@ enum plink_state {
 /**
  * struct sta_ampdu_mlme - STA aggregation information.
  *
- * @tid_state_rx: TID's state in Rx session state machine.
+ * @tid_active_rx: TID's state in Rx session state machine.
  * @tid_rx: aggregation info for Rx per TID
  * @tid_state_tx: TID's state in Tx session state machine.
  * @tid_tx: aggregation info for Tx per TID
