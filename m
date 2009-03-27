Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:34464 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZC0OVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 10:21:37 -0400
Received: by ti-out-0910.google.com with SMTP id i7so824702tid.23
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 07:21:34 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 2/3] cfg80211: remove duplicated #include
Date: Fri, 27 Mar 2009 22:20:27 +0800
Message-Id: <1238163627-1148-1-git-send-email-weiyi.huang@gmail.com> (sfid-20090327_152141_536909_064D0A36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove duplicated #include in include/net/cfg80211.h.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 include/net/cfg80211.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 50f3fd9..e7e1f1b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -10,7 +10,6 @@
 #include <net/iw_handler.h>
 #include <net/genetlink.h>
 /* remove once we remove the wext stuff */
-#include <net/iw_handler.h>
 
 /*
  * 802.11 configuration in-kernel interface
-- 
1.6.1.3

