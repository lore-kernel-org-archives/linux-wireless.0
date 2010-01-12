Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:44312 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0ALMvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:51:39 -0500
Date: Tue, 12 Jan 2010 13:51:38 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 17/17] mwl8k: update version number (to 0.12) and copyright
Message-ID: <20100112125138.GG1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 06dc7a0..68546ca 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2,7 +2,7 @@
  * drivers/net/wireless/mwl8k.c
  * Driver for Marvell TOPDOG 802.11 Wireless cards
  *
- * Copyright (C) 2008-2009 Marvell Semiconductor Inc.
+ * Copyright (C) 2008, 2009, 2010 Marvell Semiconductor Inc.
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2.  This program is licensed "as is" without any
@@ -26,7 +26,7 @@
 
 #define MWL8K_DESC	"Marvell TOPDOG(R) 802.11 Wireless Network Driver"
 #define MWL8K_NAME	KBUILD_MODNAME
-#define MWL8K_VERSION	"0.11"
+#define MWL8K_VERSION	"0.12"
 
 /* Register definitions */
 #define MWL8K_HIU_GEN_PTR			0x00000c10
-- 
1.5.6.4
