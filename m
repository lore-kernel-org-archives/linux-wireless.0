Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:48621 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaDMNCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:02:17 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 05/13] iwlwifi: 7000: bump API to 9
Date: Sun, 13 Apr 2014 16:01:55 +0300
Message-Id: <1397394123-25102-5-git-send-email-egrumbach@gmail.com> (sfid-20140413_150226_314097_A61526A7)
In-Reply-To: <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
References: <534A8A49.2030100@gmail.com>
 <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This will allow to load the new firmware.

Cc: <stable@vger.kernel.org> [3.14]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 003a546..8425130 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -67,8 +67,8 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL7260_UCODE_API_MAX	8
-#define IWL3160_UCODE_API_MAX	8
+#define IWL7260_UCODE_API_MAX	9
+#define IWL3160_UCODE_API_MAX	9
 
 /* Oldest version we won't warn about */
 #define IWL7260_UCODE_API_OK	8
-- 
1.8.3.2

