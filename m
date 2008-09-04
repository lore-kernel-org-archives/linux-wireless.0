Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:32944 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbYIDQ0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2008 12:26:21 -0400
Message-ID: <48C00BD5.9030704@oracle.com> (sfid-20080904_182625_473091_F3621247)
Date: Thu, 04 Sep 2008 09:24:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH] mac80211: add missing kernel-doc
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mac80211 kernel-doc missing struct field:

Warning(linux-2.6.27-rc1-git2//net/mac80211/sta_info.h:329): No description found for parameter 'tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1]'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/mac80211/sta_info.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.27-rc5-git6.orig/net/mac80211/sta_info.h
+++ linux-2.6.27-rc5-git6/net/mac80211/sta_info.h
@@ -204,6 +204,7 @@ struct sta_ampdu_mlme {
  * @tx_fragments: number of transmitted MPDUs
  * @txrate_idx: TBD
  * @last_txrate_idx: TBD
+ * @tid_seq: TBD
  * @wme_tx_queue: TBD
  * @ampdu_mlme: TBD
  * @timer_to_tid: identity mapping to ID timers
