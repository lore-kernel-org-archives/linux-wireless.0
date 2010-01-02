Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49879 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab0ABJbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 04:31:51 -0500
Date: Sat, 2 Jan 2010 10:31:50 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mwl8k: update version number to 0.11
Message-ID: <20100102093150.GT1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 59f9210..c251505 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -26,7 +26,7 @@
 
 #define MWL8K_DESC	"Marvell TOPDOG(R) 802.11 Wireless Network Driver"
 #define MWL8K_NAME	KBUILD_MODNAME
-#define MWL8K_VERSION	"0.10"
+#define MWL8K_VERSION	"0.11"
 
 /* Register definitions */
 #define MWL8K_HIU_GEN_PTR			0x00000c10
-- 
1.5.6.4
