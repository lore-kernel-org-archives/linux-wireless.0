Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59454 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934217Ab0GOSvD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jul 2010 14:51:03 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: refresh patch
Date: Thu, 15 Jul 2010 20:50:54 +0200
Message-Id: <1279219854-18193-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/03-rfkill.patch |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/patches/03-rfkill.patch b/patches/03-rfkill.patch
index 236891d..e8a9fe8 100644
--- a/patches/03-rfkill.patch
+++ b/patches/03-rfkill.patch
@@ -228,6 +228,6 @@ This would do the policing from within mac80211.
 +#else
 +#include <linux/rfkill_backport.h>
 +#endif
+ #include <linux/workqueue.h>
  
  #include "ath5k.h"
- #include "debug.h"
-- 
1.7.0.4

