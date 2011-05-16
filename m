Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56957 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab1EPRnj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 13:43:39 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] compat: backport PCI_EEPROM_WIDTH_93C86
Date: Mon, 16 May 2011 19:43:34 +0200
Message-Id: <1305567815-73528-2-git-send-email-nbd@openwrt.org> (sfid-20110516_194351_096440_01B31197)
In-Reply-To: <1305567815-73528-1-git-send-email-nbd@openwrt.org>
References: <1305567815-73528-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/compat-2.6.36.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 7a82522..2d756d1 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -123,6 +123,8 @@ static inline void tty_unlock(void) __releases(kernel_lock)
 
 #define __rcu
 
+#define PCI_EEPROM_WIDTH_93C86	8
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.3.2

