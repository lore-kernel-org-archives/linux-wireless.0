Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33169 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1B0WbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 17:31:08 -0500
Received: by mail-ww0-f44.google.com with SMTP id 22so2383975wwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 14:31:07 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 7/7] wl12xx: Modify requested number of memory blocks
Date: Mon, 28 Feb 2011 00:30:45 +0200
Message-Id: <1298845845-12191-8-git-send-email-ido@wizery.com>
In-Reply-To: <1298845845-12191-1-git-send-email-ido@wizery.com>
References: <1298845845-12191-1-git-send-email-ido@wizery.com>
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
index 70995a1..07d702f 100644
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

