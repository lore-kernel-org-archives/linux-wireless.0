Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:46391 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaIAHNA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:13:00 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so4960188wev.20
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 00:12:59 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] iwlwifi: bump firmware API version to 10 for 7000 and 8000
Date: Mon,  1 Sep 2014 10:12:50 +0300
Message-Id: <1409555570-18567-3-git-send-email-egrumbach@gmail.com> (sfid-20140901_091305_663517_DBAE6A8A)
In-Reply-To: <54041C13.7000905@gmail.com>
References: <54041C13.7000905@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

New firmware on the way.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 4 ++--
 drivers/net/wireless/iwlwifi/iwl-8000.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 4873006..d67a37a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -67,8 +67,8 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL7260_UCODE_API_MAX	9
-#define IWL3160_UCODE_API_MAX	9
+#define IWL7260_UCODE_API_MAX	10
+#define IWL3160_UCODE_API_MAX	10
 
 /* Oldest version we won't warn about */
 #define IWL7260_UCODE_API_OK	9
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 44b19e0..e93c697 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -67,7 +67,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	9
+#define IWL8000_UCODE_API_MAX	10
 
 /* Oldest version we won't warn about */
 #define IWL8000_UCODE_API_OK	8
-- 
1.9.1

