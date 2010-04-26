Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34506 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab0DZUK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 16:10:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: remove usage of deprecated noise value
Date: Mon, 26 Apr 2010 16:09:27 -0400
Message-Id: <1272312567-22853-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b93731b..33c2f5f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -434,7 +434,6 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	rx_status->mactime = rxdesc.timestamp;
 	rx_status->rate_idx = rate_idx;
 	rx_status->signal = rxdesc.rssi;
-	rx_status->noise = rxdesc.noise;
 	rx_status->flag = rxdesc.flags;
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
-- 
1.6.6.1

