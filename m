Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZBRI4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 03:56:54 -0500
Subject: [PATCH] mac80211: add missing kernel-doc
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 09:56:47 +0100
Message-Id: <1234947407.4149.17.camel@johannes.local> (sfid-20090218_095658_311470_DF76BD10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Document the new shutdown member.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Randy, just so you know I've found it already.

 net/mac80211/sta_info.h |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/net/mac80211/sta_info.h	2009-02-18 09:53:44.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-02-18 09:55:00.000000000 +0100
@@ -90,6 +90,7 @@ struct tid_ampdu_tx {
  * @buf_size: buffer size for incoming A-MPDUs
  * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
+ * @shutdown: this session is being shut down due to STA removal
  */
 struct tid_ampdu_rx {
 	struct sk_buff **reorder_buf;


