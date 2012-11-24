Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35929 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab2KXSe3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 13:34:29 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, zajec5@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: add more package IDs
Date: Sat, 24 Nov 2012 19:34:17 +0100
Message-Id: <1353782057-28153-1-git-send-email-hauke@hauke-m.de> (sfid-20121124_193438_436255_654F32DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/bcma/bcma.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index fd15d98..93b1e09 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -157,6 +157,7 @@ struct bcma_host_ops {
 
 /* Chip IDs of SoCs */
 #define BCMA_CHIP_ID_BCM4706	0x5300
+#define  BCMA_PKG_ID_BCM4706L	1
 #define BCMA_CHIP_ID_BCM4716	0x4716
 #define  BCMA_PKG_ID_BCM4716	8
 #define  BCMA_PKG_ID_BCM4717	9
@@ -166,7 +167,11 @@ struct bcma_host_ops {
 #define BCMA_CHIP_ID_BCM4749	0x4749
 #define BCMA_CHIP_ID_BCM5356	0x5356
 #define BCMA_CHIP_ID_BCM5357	0x5357
+#define  BCMA_PKG_ID_BCM5358	9
+#define  BCMA_PKG_ID_BCM47186	10
+#define  BCMA_PKG_ID_BCM5357	11
 #define BCMA_CHIP_ID_BCM53572	53572
+#define  BCMA_PKG_ID_BCM47188	9
 
 struct bcma_device {
 	struct bcma_bus *bus;
-- 
1.7.10.4

