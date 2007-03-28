Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:43423 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbXC1VIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 17:08:52 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HWfLv-0007Il-8A
	for linux-wireless@vger.kernel.org; Wed, 28 Mar 2007 17:06:43 -0400
Received: from localhost ([127.0.0.1] helo=dv.roinet.com)
	by gnu.org with esmtp (Exim 4.66)
	(envelope-from <proski@gnu.org>)
	id 1HWfNz-0007RP-Gv
	for linux-wireless@vger.kernel.org; Wed, 28 Mar 2007 17:08:51 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] Remove comment about IEEE80211_RADIOTAP_FCS
To: linux-wireless@vger.kernel.org
Date: Wed, 28 Mar 2007 17:08:51 -0400
Message-ID: <20070328210851.28590.49264.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE80211_RADIOTAP_FCS is obsolete and should not be used.  It's no
longer defined.  Remove it from the comment too.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
That's for wireless-2.6
---

 include/net/ieee80211_radiotap.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index f3bc00e..a0c2b41 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -186,9 +186,6 @@ struct ieee80211_radiotap_header {
  *
  *     Number of unicast retries a transmitted frame used.
  *
- * IEEE80211_RADIOTAP_FCS           	__le32       data
- *
- *	FCS from frame in network byte order.
  */
 enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_TSFT = 0,


