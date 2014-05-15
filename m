Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35316 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaEORFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:10 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so3788474wgh.14
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:09 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/24] iwlwifi: remove spurious newline in Kconfig
Date: Thu, 15 May 2014 20:04:28 +0300
Message-Id: <1400173481-9047-11-git-send-email-egrumbach@gmail.com> (sfid-20140515_190520_204633_D747E54E)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's an extra newline that shouldn't be there - remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index b82d30c..d216509 100644
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
1.8.3.2

