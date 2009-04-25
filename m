Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:2698 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZDYAYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 20:24:36 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1183566wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 24 Apr 2009 17:24:36 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] cfg80211: remove duplicated #include
Date: Sat, 25 Apr 2009 08:24:24 +0800
Message-Id: <1240619064-2472-1-git-send-email-weiyi.huang@gmail.com> (sfid-20090425_022441_192798_32E42813)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove duplicated #include in net/wireless/core.h.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 0a592e4..fcee83a 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -10,7 +10,6 @@
 #include <linux/netdevice.h>
 #include <linux/kref.h>
 #include <linux/rbtree.h>
-#include <linux/mutex.h>
 #include <net/genetlink.h>
 #include <net/wireless.h>
 #include <net/cfg80211.h>

