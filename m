Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:3216 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162174AbXECQvJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2007 12:51:09 -0400
Date: Thu, 3 May 2007 18:52:40 +0200
From: maximilian attems <max@stro.at>
To: yi.zhu@intel.com, jketreno@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [patch] iwp2200: make use of MODULE_FIRMWARE
Message-ID: <20070503165240.GA20914@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

modinfo output is helpful to build an nfsroot initramfs 

Signed-off-by: maximilian attems <max@stro.at>

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 7cb2052..6b181c6 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -81,6 +81,9 @@ MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("ipw2200-bss.fw");
+MODULE_FIRMWARE("ipw2200-ibss.fw");
+MODULE_FIRMWARE("ipw2200-sniffer.fw");
 
 static int cmdlog = 0;
 static int debug = 0;

