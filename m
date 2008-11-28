Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20277 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbYK1Qwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 11:52:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 08:52:45 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18736.8486.733161.756572@gargle.gargle.HOWL> (sfid-20081128_175249_199991_32EACAAA)
Date: Fri, 28 Nov 2008 22:19:42 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/5] ath9k: Remove includes that are not needed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 50bef47..4493879 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -17,27 +17,8 @@
 #ifndef CORE_H
 #define CORE_H
 
-#include <linux/version.h>
-#include <linux/autoconf.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/errno.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/ip.h>
-#include <linux/tcp.h>
-#include <linux/in.h>
-#include <linux/delay.h>
-#include <linux/wait.h>
 #include <linux/pci.h>
-#include <linux/interrupt.h>
-#include <linux/sched.h>
-#include <linux/list.h>
-#include <asm/byteorder.h>
-#include <linux/scatterlist.h>
-#include <asm/page.h>
 #include <net/mac80211.h>
 #include <linux/leds.h>
 #include <linux/rfkill.h>
-- 
1.6.0.3

