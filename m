Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57117 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab1HWLii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 07:38:38 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: add PMSG_IS_AUTO
Date: Tue, 23 Aug 2011 13:38:29 +0200
Message-Id: <1314099509-6123-2-git-send-email-hauke@hauke-m.de> (sfid-20110823_133841_619124_775D2D8C)
In-Reply-To: <1314099509-6123-1-git-send-email-hauke@hauke-m.de>
References: <1314099509-6123-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.2.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
index 9cba461..d10495c 100644
--- a/include/linux/compat-3.2.h
+++ b/include/linux/compat-3.2.h
@@ -22,6 +22,8 @@
 #define br_port_exists(dev)	(dev->br_port)
 #endif
 
+#define PMSG_IS_AUTO(msg)	(((msg).event & PM_EVENT_AUTO) != 0)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)) */
 
 #endif /* LINUX_3_2_COMPAT_H */
-- 
1.7.4.1

