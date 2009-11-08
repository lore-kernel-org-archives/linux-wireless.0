Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48319 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbZKHMHS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 07:07:18 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: IvDoorn@gmail.com, gwingerde@gmail.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	bzolnier@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] rt2x00: fix build of rt2800lib
Date: Sun,  8 Nov 2009 13:07:01 +0100
Message-Id: <1257682021-23810-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00usb.h uses lots of definitions from linux/usb.h.
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 5c7d74a..b601a1a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -29,6 +29,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/usb.h>
 
 #include "rt2x00.h"
 #ifdef CONFIG_RT2800USB
-- 
1.6.3.3

