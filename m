Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53613 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbZKGV7L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 16:59:11 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: John Linville <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 21:59:10 +0000
Message-ID: <1257631150.15927.458.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 48/75] ipw2200: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index e2af22b..d03ef19 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -81,6 +81,11 @@ MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("ipw2200-ibss.fw");
+#ifdef CONFIG_IPW2200_MONITOR
+MODULE_FIRMWARE("ipw2200-sniffer.fw");
+#endif
+MODULE_FIRMWARE("ipw2200-bss.fw");
 
 static int cmdlog = 0;
 static int debug = 0;
-- 
1.6.5.2



