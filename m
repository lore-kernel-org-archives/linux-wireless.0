Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51624
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756686AbYGQMQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 08:16:04 -0400
Date: Thu, 17 Jul 2008 05:16:04 -0700 (PDT)
Message-Id: <20080717.051604.22239818.davem@davemloft.net> (sfid-20080717_141609_476528_AC9E63DC)
To: netdev@vger.kernel.org
CC: kaber@trash.net, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: [PATCH 5/31]: mac80211: Temporarily mark QoS support BROKEN.
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We will undo this after a few changsets.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/mac80211/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index d203841..10579de 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -15,6 +15,7 @@ config MAC80211_QOS
 	def_bool y
 	depends on MAC80211
 	depends on NET_SCHED
+	depends on BROKEN
 
 comment "QoS/HT support disabled"
 	depends on MAC80211 && !MAC80211_QOS
-- 
1.5.6.2.255.gbed62

