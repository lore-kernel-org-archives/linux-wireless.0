Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43511 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab1GQU6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 16:58:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat: backport ETH_P_LINK_CTL
Date: Sun, 17 Jul 2011 22:58:10 +0200
Message-Id: <1310936291-10275-2-git-send-email-hauke@hauke-m.de> (sfid-20110717_225823_335133_2195A1C9)
In-Reply-To: <1310936291-10275-1-git-send-email-hauke@hauke-m.de>
References: <1310936291-10275-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.38.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index 73f2aa4..84310eb 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -63,6 +63,8 @@ static inline int skb_checksum_start_offset(const struct sk_buff *skb)
 #define pr_cont_once(fmt, ...)					\
 	printk_once(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
 
+#define ETH_P_LINK_CTL	0x886c		/* HPNA, wlan link local tunnel */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38)) */
 
 #endif /* LINUX_26_38_COMPAT_H */
-- 
1.7.4.1

