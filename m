Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44695 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab2KGKWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 05:22:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: include export.h in aes_cmac
Date: Wed,  7 Nov 2012 11:22:37 +0100
Message-Id: <1352283757-20384-1-git-send-email-johannes@sipsolutions.net> (sfid-20121107_112219_331594_B0D9B679)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is needed since this file exports functions.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/aes_cmac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/aes_cmac.c b/net/mac80211/aes_cmac.c
index 4933535..537488c 100644
--- a/net/mac80211/aes_cmac.c
+++ b/net/mac80211/aes_cmac.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/crypto.h>
+#include <linux/export.h>
 #include <linux/err.h>
 #include <crypto/aes.h>
 
-- 
1.8.0

