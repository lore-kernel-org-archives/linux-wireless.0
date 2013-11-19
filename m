Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37214 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3KSUw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 15:52:26 -0500
Received: by mail-wi0-f174.google.com with SMTP id fb10so2099452wid.7
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 12:52:24 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 7/7] iwlwifi: bump required firmware API version for 3160/7260
Date: Tue, 19 Nov 2013 22:52:06 +0200
Message-Id: <1384894326-24676-7-git-send-email-egrumbach@gmail.com> (sfid-20131119_215231_754582_416FF363)
In-Reply-To: <528BCEDB.8010703@gmail.com>
References: <528BCEDB.8010703@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A new firmware is coming out soon with new APIs.
To make sure that this new firmware won't be loaded on old
driver that don't support it, it's API version has been
updated to 8. In order to be able to load it, bump the API
version to 8.
API version 7 is still supported and will be for another
year or so.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 1ed861f..3c34a72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -67,8 +67,8 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL7260_UCODE_API_MAX	7
-#define IWL3160_UCODE_API_MAX	7
+#define IWL7260_UCODE_API_MAX	8
+#define IWL3160_UCODE_API_MAX	8
 
 /* Oldest version we won't warn about */
 #define IWL7260_UCODE_API_OK	7
-- 
1.7.9.5

