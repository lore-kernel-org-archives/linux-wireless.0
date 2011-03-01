Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50118 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1CANQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 08:16:06 -0500
Received: by wyg36 with SMTP id 36so4637678wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 05:16:04 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 7/7] wl12xx: Modify requested number of memory blocks
Date: Tue,  1 Mar 2011 15:14:44 +0200
Message-Id: <1298985284-6048-8-git-send-email-ido@wizery.com>
In-Reply-To: <1298985284-6048-1-git-send-email-ido@wizery.com>
References: <1298985284-6048-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tests have shown that the requested number of memory blocks is
sub-optimal. Slightly modify the requested number of memory blocks for
TX.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 4e4aa42..165ed1e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -304,7 +304,7 @@ static struct conf_drv_settings default_conf = {
 		.rx_block_num                 = 70,
 		.tx_min_block_num             = 40,
 		.dynamic_memory               = 0,
-		.min_req_tx_blocks            = 104,
+		.min_req_tx_blocks            = 100,
 		.min_req_rx_blocks            = 22,
 		.tx_min                       = 27,
 	}
-- 
1.7.1

