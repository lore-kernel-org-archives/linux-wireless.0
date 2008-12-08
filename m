Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbYLHNBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 08:01:18 -0500
Subject: [PATCH] mac80211: improve sta_notify documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 11:18:32 +0100
Message-Id: <1228731512.22164.72.camel@johannes.berg> (sfid-20081208_140120_799731_4325B51B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mention more possible STA entries and document the atomic requirement.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-12-08 11:16:25.000000000 +0100
+++ everything/include/net/mac80211.h	2008-12-08 11:17:24.000000000 +0100
@@ -1257,8 +1257,8 @@ enum ieee80211_ampdu_mlme_action {
  *	the device does fragmentation by itself; if this method is assigned then
  *	the stack will not do fragmentation.
  *
- * @sta_notify: Notifies low level driver about addition or removal
- *	of associated station or AP.
+ * @sta_notify: Notifies low level driver about addition or removal of an
+ *	associated station, AP, IBSS/WDS/mesh peer etc. Must be atomic.
  *
  * @sta_ps_notify: Notifies low level driver about the power state transition
  *	of a associated station. Must be atomic.


