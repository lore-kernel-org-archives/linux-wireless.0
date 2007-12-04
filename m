Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4504 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbXLDWYv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 17:24:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: correct "skb_buff" typo
Date: Tue,  4 Dec 2007 17:24:35 -0500
Message-Id: <1196807075-28518-1-git-send-email-linville@tuxdriver.com> (sfid-20071204_222454_622411_AA52D2A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Jeff,

I found this one when pushing the latest round of wireless bits
into rawhide.  Wanna just go ahead and apply it to netdev-2.6#upstream?

John

 drivers/net/wireless/rt2x00/rt2x00lib.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 0bf10ff..108488d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -91,7 +91,7 @@ static inline void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 }
 
 static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
-					  struct skb_buff *skb)
+					  struct sk_buff *skb)
 {
 }
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
-- 
1.5.3.3

