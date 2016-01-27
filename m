Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14350 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbcA0C5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 21:57:53 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/13] staging: wilc1000: remove warnings line over 80 characters
Date: Wed, 27 Jan 2016 11:50:32 +0900
Message-ID: <1453863037-31073-8-git-send-email-glen.lee@atmel.com> (sfid-20160127_035755_907243_C42F3A04)
In-Reply-To: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
References: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the warnings reported by checkpatch.pl
for line over 80 characters.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4b544df..f03daff 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -25,7 +25,8 @@
 
 #include <linux/semaphore.h>
 
-static int dev_state_ev_handler(struct notifier_block *this, unsigned long event, void *ptr);
+static int dev_state_ev_handler(struct notifier_block *this,
+				unsigned long event, void *ptr);
 
 static struct notifier_block g_dev_notifier = {
 	.notifier_call = dev_state_ev_handler
@@ -57,7 +58,8 @@ static const struct net_device_ops wilc_netdev_ops = {
 
 };
 
-static int dev_state_ev_handler(struct notifier_block *this, unsigned long event, void *ptr)
+static int dev_state_ev_handler(struct notifier_block *this,
+				unsigned long event, void *ptr)
 {
 	struct in_ifaddr *dev_iface = (struct in_ifaddr *)ptr;
 	struct wilc_priv *priv;
-- 
1.9.1

