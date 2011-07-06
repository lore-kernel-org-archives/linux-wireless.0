Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:35348 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab1GFAzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 20:55:45 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: modify SDIO aggregation Tx/Rx buffer size
Date: Tue,  5 Jul 2011 18:01:11 -0700
Message-Id: <1309914071-13613-1-git-send-email-bzhao@marvell.com> (sfid-20110706_025550_386066_61AEB3CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The SDIO aggregation buffer size has been modified to an optimum
value which gives good throughput results.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index c925376..524f78f 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -54,10 +54,10 @@
 
 #define SDIO_MP_AGGR_DEF_PKT_LIMIT	8
 
-#define SDIO_MP_TX_AGGR_DEF_BUF_SIZE        (4096)	/* 4K */
+#define SDIO_MP_TX_AGGR_DEF_BUF_SIZE        (8192)	/* 8K */
 
 /* Multi port RX aggregation buffer size */
-#define SDIO_MP_RX_AGGR_DEF_BUF_SIZE        (4096)	/* 4K */
+#define SDIO_MP_RX_AGGR_DEF_BUF_SIZE        (16384)	/* 16K */
 
 /* Misc. Config Register : Auto Re-enable interrupts */
 #define AUTO_RE_ENABLE_INT              BIT(4)
-- 
1.7.0.2

