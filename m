Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42833 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab1EWORB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 10:17:01 -0400
Received: by wya21 with SMTP id 21so4231353wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 07:17:00 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat: add an empty implementation for pm_wakeup_event()
Date: Mon, 23 May 2011 17:17:05 +0300
Message-Id: <1306160225-18317-1-git-send-email-eliad@wizery.com> (sfid-20110523_161706_292349_282A7B7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed for wl12xx compilation

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/linux/compat-2.6.36.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 7a82522..7bb2bb8 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -123,6 +123,8 @@ static inline void tty_unlock(void) __releases(kernel_lock)
 
 #define __rcu
 
+static inline void pm_wakeup_event(struct device *dev, unsigned int msec) {}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.0.4

