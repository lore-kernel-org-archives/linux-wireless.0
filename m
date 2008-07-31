Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:45929 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751529AbYGaUQi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 16:16:38 -0400
Received: from shark.he.net ([66.160.160.2]) by xenotime.net for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 13:16:30 -0700
Date: Thu, 31 Jul 2008 13:16:30 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
To: linux-wireless@vger.kernel.org
cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: add missing kernel-doc
Message-ID: <Pine.LNX.4.64.0807311315100.3067@shark.he.net> (sfid-20080731_221642_032582_97BC9A50)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mac80211 kernel-doc missing struct field:

Warning(linux-2.6.27-rc1-git2//net/mac80211/sta_info.h:329): No description found for parameter 'tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1]'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/mac80211/sta_info.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.27-rc1-git2.orig/net/mac80211/sta_info.h
+++ linux-2.6.27-rc1-git2/net/mac80211/sta_info.h
@@ -204,6 +204,7 @@ struct sta_ampdu_mlme {
  * @tx_fragments: number of transmitted MPDUs
  * @txrate_idx: TBD
  * @last_txrate_idx: TBD
+ * @tdi_seq: TBD
  * @wme_tx_queue: TBD
  * @ampdu_mlme: TBD
  * @timer_to_tid: identity mapping to ID timers
