Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51576 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZKJAlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 19:41:06 -0500
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/2] Libertas: coding style cleanup in ethtool.c
Date: Mon,  9 Nov 2009 18:04:12 -0800
Message-Id: <1257818653-13460-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/ethtool.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index 039b555..6efa388 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -175,10 +175,14 @@ static int lbs_ethtool_set_wol(struct net_device *dev,
 	if (wol->wolopts & ~(WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY))
 		return -EOPNOTSUPP;
 
-	if (wol->wolopts & WAKE_UCAST) criteria |= EHS_WAKE_ON_UNICAST_DATA;
-	if (wol->wolopts & WAKE_MCAST) criteria |= EHS_WAKE_ON_MULTICAST_DATA;
-	if (wol->wolopts & WAKE_BCAST) criteria |= EHS_WAKE_ON_BROADCAST_DATA;
-	if (wol->wolopts & WAKE_PHY)   criteria |= EHS_WAKE_ON_MAC_EVENT;
+	if (wol->wolopts & WAKE_UCAST)
+		criteria |= EHS_WAKE_ON_UNICAST_DATA;
+	if (wol->wolopts & WAKE_MCAST)
+		criteria |= EHS_WAKE_ON_MULTICAST_DATA;
+	if (wol->wolopts & WAKE_BCAST)
+		criteria |= EHS_WAKE_ON_BROADCAST_DATA;
+	if (wol->wolopts & WAKE_PHY)
+		criteria |= EHS_WAKE_ON_MAC_EVENT;
 
 	return lbs_host_sleep_cfg(priv, criteria, (struct wol_config *)NULL);
 }
-- 
1.5.3.6

