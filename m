Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51896 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab0JGVWh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 17:22:37 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: rename member in struct mmc_host.
Date: Thu,  7 Oct 2010 23:22:24 +0200
Message-Id: <1286486544-18975-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1286486544-18975-1-git-send-email-hauke@hauke-m.de>
References: <1286486544-18975-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.37.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index 3bb9228..716f528 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -110,6 +110,9 @@ int genl_unregister_family(struct genl_family *family);
 #define genl_register_mc_group(_fam, _grp) genl_register_mc_group(&(_fam)->family, _grp)
 #define genl_unregister_mc_group(_fam, _grp) genl_unregister_mc_group(&(_fam)->family, _grp)
 
+/* rename member in struct mmc_host in include/linux/mmc/host.h */
+#define max_segs	max_hw_segs
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)) */
 
 #endif /* LINUX_26_37_COMPAT_H */
-- 
1.7.0.4

