Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51929 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbaEIM70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:59:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] iwlwifi: remove spurious newline in Kconfig
Date: Fri,  9 May 2014 14:59:16 +0200
Message-Id: <1399640356-16983-1-git-send-email-johannes@sipsolutions.net> (sfid-20140509_145930_153630_5D710AE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's an extra newline that shouldn't be there - remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index b82d30c0f0c9..d216509d167e 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -128,7 +128,6 @@ config IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
 	  Enable use of experimental ucode for testing and debugging.
 
 config IWLWIFI_DEVICE_TRACING
-
 	bool "iwlwifi device access tracing"
 	depends on IWLWIFI
 	depends on EVENT_TRACING
-- 
2.0.0.rc0

