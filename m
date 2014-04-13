Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:62063 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbaDMTVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:14 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so7364427wes.9
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:12 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 43/47] iwlwifi: 7000: bump firmware API version to 9
Date: Sun, 13 Apr 2014 22:19:58 +0300
Message-Id: <1397416802-32403-43-git-send-email-egrumbach@gmail.com> (sfid-20140413_213515_744830_3B239F4B)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Also warn if an older firmware is loaded.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 3ab21ef..2c9b6fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -67,12 +67,12 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL7260_UCODE_API_MAX	8
-#define IWL3160_UCODE_API_MAX	8
+#define IWL7260_UCODE_API_MAX	9
+#define IWL3160_UCODE_API_MAX	9
 
 /* Oldest version we won't warn about */
-#define IWL7260_UCODE_API_OK	8
-#define IWL3160_UCODE_API_OK	8
+#define IWL7260_UCODE_API_OK	9
+#define IWL3160_UCODE_API_OK	9
 
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	8
-- 
1.8.3.2

