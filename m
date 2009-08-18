Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45774 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZHRDzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:55:46 -0400
Date: Tue, 18 Aug 2009 05:55:47 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 28/29] mwl8k: update copyright and version number
Message-ID: <20090818035547.GG18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index c8aa552..2150c32 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2,7 +2,7 @@
  * drivers/net/wireless/mwl8k.c
  * Driver for Marvell TOPDOG 802.11 Wireless cards
  *
- * Copyright (C) 2008 Marvell Semiconductor Inc.
+ * Copyright (C) 2008-2009 Marvell Semiconductor Inc.
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2.  This program is licensed "as is" without any
@@ -25,7 +25,7 @@
 
 #define MWL8K_DESC	"Marvell TOPDOG(R) 802.11 Wireless Network Driver"
 #define MWL8K_NAME	KBUILD_MODNAME
-#define MWL8K_VERSION	"0.9.1"
+#define MWL8K_VERSION	"0.10"
 
 MODULE_DESCRIPTION(MWL8K_DESC);
 MODULE_VERSION(MWL8K_VERSION);
-- 
1.5.6.4
