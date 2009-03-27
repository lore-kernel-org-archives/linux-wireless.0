Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:34464 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbZC0OVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 10:21:45 -0400
Received: by ti-out-0910.google.com with SMTP id i7so824702tid.23
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 07:21:43 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 3/3] nl80211: remove duplicated #include
Date: Fri, 27 Mar 2009 22:21:36 +0800
Message-Id: <1238163696-308-1-git-send-email-weiyi.huang@gmail.com> (sfid-20090327_152146_565617_3232870F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove duplicated #include in net/wireless/core.h.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 net/wireless/core.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 6acd483..ed3a5b9 100644
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
-- 
1.6.1.3

