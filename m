Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53118 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752548AbeEGJgM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 05:36:12 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 09/18] net: mac80211.h: fix a bad comment line
Date: Mon,  7 May 2018 06:35:45 -0300
Message-Id: <1b14ef4f63547c86c544e112b74acfff2b41f4af.1525684985.git.mchehab+samsung@kernel.org> (sfid-20180507_113715_507034_9227E1A4)
In-Reply-To: <cover.1525684985.git.mchehab+samsung@kernel.org>
References: <cover.1525684985.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1525684985.git.mchehab+samsung@kernel.org>
References: <cover.1525684985.git.mchehab+samsung@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sphinx produces a lot of errors like this:
	./include/net/mac80211.h:2083: warning: bad line:  >

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 include/net/mac80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d2279b2d61aa..b2f3a0c018e7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2080,7 +2080,7 @@ struct ieee80211_txq {
  *	virtual interface might not be given air time for the transmission of
  *	the frame, as it is not synced with the AP/P2P GO yet, and thus the
  *	deauthentication frame might not be transmitted.
- >
+ *
  * @IEEE80211_HW_DOESNT_SUPPORT_QOS_NDP: The driver (or firmware) doesn't
  *	support QoS NDP for AP probing - that's most likely a driver bug.
  *
-- 
2.17.0
