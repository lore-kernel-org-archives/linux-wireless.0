Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:9703 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965764AbcBDJYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:24:43 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 18/70] staging: wilc1000: remove warnings line over 80 characters
Date: Thu, 4 Feb 2016 18:15:35 +0900
Message-ID: <1454577387-509-19-git-send-email-glen.lee@atmel.com> (sfid-20160204_104504_758006_206F331B)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
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
index f5f787e..1446b19 100644
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

