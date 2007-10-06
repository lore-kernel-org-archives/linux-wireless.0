Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:17023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbXJFMEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:08 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605537ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:04:07 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/16] rt2x00: Cut lines down to 80 characters
Date: Sat, 6 Oct 2007 14:15:20 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061415.21077.IvDoorn@gmail.com> (sfid-20071006_130412_982257_D1987616)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt61pci contained 1 line of 88 characters width,
this needs to be cut down.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 62f1297..b9051a1 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2495,7 +2495,8 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * Write entire beacon with descriptor to register,
 	 * and kick the beacon generator.
 	 */
-	rt2x00pci_register_multiwrite(rt2x00dev, HW_BEACON_BASE0, skb->data, skb->len);
+	rt2x00pci_register_multiwrite(rt2x00dev, HW_BEACON_BASE0,
+				      skb->data, skb->len);
 	rt61pci_kick_tx_queue(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
 
 	return 0;
-- 
1.5.3.4

