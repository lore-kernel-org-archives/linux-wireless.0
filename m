Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59077 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab2HFWg2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 18:36:28 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: fix undef syntax
Date: Tue,  7 Aug 2012 00:36:20 +0200
Message-Id: <1344292581-25959-1-git-send-email-hauke@hauke-m.de> (sfid-20120807_003631_497743_546C6183)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.36.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index 05b41c2..51486b0 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -133,7 +133,7 @@ int compat_schedule_delayed_work_on(int cpu,
 }
 EXPORT_SYMBOL_GPL(compat_schedule_delayed_work_on);
 
-#undef flush_scheduled_work(a)
+#undef flush_scheduled_work
 void compat_flush_scheduled_work(void)
 {
 	/*
-- 
1.7.9.5

