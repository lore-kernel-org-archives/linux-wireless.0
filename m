Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:50152 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaFXTwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:30 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so932332wes.38
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:29 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/27] iwlwifi: bump API version for 8000 devices
Date: Tue, 24 Jun 2014 22:51:55 +0300
Message-Id: <1403639541-4621-1-git-send-email-egrumbach@gmail.com> (sfid-20140624_215234_563175_0A8B83C0)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 51c4153..0a1bb5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -67,7 +67,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	8
+#define IWL8000_UCODE_API_MAX	9
 
 /* Oldest version we won't warn about */
 #define IWL8000_UCODE_API_OK	8
-- 
1.8.3.2

