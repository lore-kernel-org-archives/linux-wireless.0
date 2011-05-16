Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56959 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab1EPRnk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 13:43:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] compat: add an empty definition for __rcu
Date: Mon, 16 May 2011 19:43:33 +0200
Message-Id: <1305567815-73528-1-git-send-email-nbd@openwrt.org> (sfid-20110516_194350_055038_1C87B8B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/compat-2.6.36.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 806993b..7a82522 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -120,6 +120,9 @@ static inline void tty_unlock(void) __releases(kernel_lock)
 #define tty_locked()           (kernel_locked())
 
 #define usleep_range(_min, _max)	msleep((_max) / 1000)
+
+#define __rcu
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.3.2

