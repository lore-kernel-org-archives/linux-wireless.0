Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55261 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab3GOLP1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:15:27 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] bcma: add constants for new ARM based SoCs
Date: Mon, 15 Jul 2013 13:15:06 +0200
Message-Id: <1373886908-4460-4-git-send-email-hauke@hauke-m.de> (sfid-20130715_131531_183073_C45768E9)
In-Reply-To: <1373886908-4460-1-git-send-email-hauke@hauke-m.de>
References: <1373886908-4460-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are the chipIDs of some ARM based SoCs from the BCM47xx line.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/bcma/bcma.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 8fee028..4d043c3 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -189,6 +189,11 @@ struct bcma_host_ops {
 #define  BCMA_PKG_ID_BCM5357	11
 #define BCMA_CHIP_ID_BCM53572	53572
 #define  BCMA_PKG_ID_BCM47188	9
+#define BCMA_CHIP_ID_BCM4707	53010
+#define  BCMA_PKG_ID_BCM4707	1
+#define  BCMA_PKG_ID_BCM4708	2
+#define  BCMA_PKG_ID_BCM4709	0
+#define BCMA_CHIP_ID_BCM53018	53018
 
 /* Board types (on PCI usually equals to the subsystem dev id) */
 /* BCM4313 */
-- 
1.7.10.4

