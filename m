Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYILHyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 03:54:01 -0400
Subject: [PATCH] mac80211: fix sta_info kernel-doc warning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 09:53:27 +0200
Message-Id: <1221206007.11204.7.camel@johannes.berg> (sfid-20080912_095406_865631_961E711C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, forgot to run kernel-doc and just got the output from the nightly
run by email, this fixes a warning which I introduced when doing the
first RC API cleanups.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/sta_info.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/mac80211/sta_info.h	2008-09-12 09:50:48.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-09-12 09:51:09.000000000 +0200
@@ -197,7 +197,7 @@ struct sta_ampdu_mlme {
  * @tx_packets: number of RX/TX MSDUs
  * @tx_bytes: TBD
  * @tx_fragments: number of transmitted MPDUs
- * @txrate_idx: TBD
+ * @last_txrate_idx: Index of the last used transmit rate
  * @tid_seq: TBD
  * @wme_tx_queue: TBD
  * @ampdu_mlme: TBD


