Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:56504 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaBCU6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:30 -0500
Received: by mail-ea0-f173.google.com with SMTP id d10so3908618eaj.18
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:29 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/62] iwlwifi: 7000: warn about old firmware
Date: Mon,  3 Feb 2014 22:57:15 +0200
Message-Id: <1391461088-8082-9-git-send-email-egrumbach@gmail.com> (sfid-20140203_215835_715104_F50CBB51)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwlwifi-7260-8.ucode has been release. Warn if it is not
on the file system.
iwlwifi-7260-7.ucode is still supported for another kernel
version.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 1270f0c..a43e4d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -71,8 +71,8 @@
 #define IWL3160_UCODE_API_MAX	8
 
 /* Oldest version we won't warn about */
-#define IWL7260_UCODE_API_OK	7
-#define IWL3160_UCODE_API_OK	7
+#define IWL7260_UCODE_API_OK	8
+#define IWL3160_UCODE_API_OK	8
 
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	7
-- 
1.7.9.5

