Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:33904 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZAIX24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 18:28:56 -0500
Date: Fri, 9 Jan 2009 15:25:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: more kernel-doc fixes
Message-Id: <20090109152509.47d11049.randy.dunlap@oracle.com> (sfid-20090110_002902_165001_E20D2F1B)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix (delete) more mac80211 kernel-doc:

Warning(linux-2.6.28-git13//include/net/mac80211.h:375): Excess struct/union/enum/typedef member 'retry_count' description in 'ieee80211_tx_info'
Warning(linux-2.6.28-git13//net/mac80211/sta_info.h:308): Excess struct/union/enum/typedef member 'last_txrate' description in 'sta_info'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/net/mac80211.h  |    1 -
 net/mac80211/sta_info.h |    1 -
 2 files changed, 2 deletions(-)

--- linux-2.6.28-git13.orig/include/net/mac80211.h
+++ linux-2.6.28-git13/include/net/mac80211.h
@@ -322,7 +322,6 @@ struct ieee80211_tx_rate {
  * @control: union for control data
  * @status: union for status data
  * @driver_data: array of driver_data pointers
- * @retry_count: number of retries
  * @ampdu_ack_len: number of aggregated frames.
  * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
  * @ampdu_ack_map: block ack bit map for the aggregation.
--- linux-2.6.28-git13.orig/net/mac80211/sta_info.h
+++ linux-2.6.28-git13/net/mac80211/sta_info.h
@@ -195,7 +195,6 @@ struct sta_ampdu_mlme {
  * @tx_packets: number of RX/TX MSDUs
  * @tx_bytes: number of bytes transmitted to this STA
  * @tx_fragments: number of transmitted MPDUs
- * @last_txrate: description of the last used transmit rate
  * @tid_seq: per-TID sequence numbers for sending to this STA
  * @ampdu_mlme: A-MPDU state machine state
  * @timer_to_tid: identity mapping to ID timers
