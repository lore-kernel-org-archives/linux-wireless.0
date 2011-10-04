Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41113 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1JDLL5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 07:11:57 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: add ETH_P_TDLS
Date: Tue,  4 Oct 2011 13:11:45 +0200
Message-Id: <1317726707-23497-1-git-send-email-hauke@hauke-m.de> (sfid-20111004_131200_213003_06A30B03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.2.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
index 009e341..859a2e3 100644
--- a/include/linux/compat-3.2.h
+++ b/include/linux/compat-3.2.h
@@ -58,6 +58,8 @@ static inline dma_addr_t skb_frag_dma_map(struct device *dev,
 			    frag->page_offset + offset, size, dir);
 }
 
+#define ETH_P_TDLS	0x890D          /* TDLS */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)) */
 
 #endif /* LINUX_3_2_COMPAT_H */
-- 
1.7.4.1

