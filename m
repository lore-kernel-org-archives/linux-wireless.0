Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53491 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426Ab0BMRL2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 12:11:28 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] ssb: fix typo in ifdef comment
Date: Sat, 13 Feb 2010 18:10:54 +0100
Message-Id: <1266081054-4910-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1266081054-4910-1-git-send-email-hauke@hauke-m.de>
References: <1266081054-4910-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Cc:	Michael Buesch <mb@bu3sch.de>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/ssb_private.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 56054be..0331139 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -196,7 +196,7 @@ extern int ssb_devices_thaw(struct ssb_freeze_context *ctx);
 #ifdef CONFIG_SSB_B43_PCI_BRIDGE
 extern int __init b43_pci_ssb_bridge_init(void);
 extern void __exit b43_pci_ssb_bridge_exit(void);
-#else /* CONFIG_SSB_B43_PCI_BRIDGR */
+#else /* CONFIG_SSB_B43_PCI_BRIDGE */
 static inline int b43_pci_ssb_bridge_init(void)
 {
 	return 0;
@@ -204,6 +204,6 @@ static inline int b43_pci_ssb_bridge_init(void)
 static inline void b43_pci_ssb_bridge_exit(void)
 {
 }
-#endif /* CONFIG_SSB_PCIHOST */
+#endif /* CONFIG_SSB_B43_PCI_BRIDGE */
 
 #endif /* LINUX_SSB_PRIVATE_H_ */
-- 
1.6.3.3

