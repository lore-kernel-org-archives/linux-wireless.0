Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55852 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754824AbeD0BRc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 21:17:32 -0400
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] mac80211: fix kernel-doc "bad line" warning
Message-ID: <a248f969-311b-1a4b-4b11-c0b90134527f@infradead.org> (sfid-20180427_031747_547557_8EAFF5CF)
Date: Thu, 26 Apr 2018 18:17:31 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix 88 instances of a kernel-doc warning:
  ../include/net/mac80211.h:2083: warning: bad line:  >

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20180426.orig/include/net/mac80211.h
+++ linux-next-20180426/include/net/mac80211.h
@@ -2080,7 +2080,7 @@ struct ieee80211_txq {
  *	virtual interface might not be given air time for the transmission of
  *	the frame, as it is not synced with the AP/P2P GO yet, and thus the
  *	deauthentication frame might not be transmitted.
- >
+ *
  * @IEEE80211_HW_DOESNT_SUPPORT_QOS_NDP: The driver (or firmware) doesn't
  *	support QoS NDP for AP probing - that's most likely a driver bug.
  *
