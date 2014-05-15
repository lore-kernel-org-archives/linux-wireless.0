Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:44053 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbaEORFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:00 -0400
Received: by mail-we0-f181.google.com with SMTP id w61so1343335wes.26
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:04:59 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/24] iwlwifi: mvm: add channel 14 to the low band list
Date: Thu, 15 May 2014 20:04:22 +0300
Message-Id: <1400173481-9047-5-git-send-email-egrumbach@gmail.com> (sfid-20140515_190510_738357_592CDC16)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

in family 8000: additional channel 14 added to the low
band list. now the number of channels in the low band
is 15.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 49963e4..85eee79 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -128,7 +128,7 @@ static const u8 iwl_nvm_channels[] = {
 
 static const u8 iwl_nvm_channels_family_8000[] = {
 	/* 2.4 GHz */
-	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
+	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
 	/* 5 GHz */
 	36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92,
 	96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144,
@@ -138,7 +138,7 @@ static const u8 iwl_nvm_channels_family_8000[] = {
 #define IWL_NUM_CHANNELS		ARRAY_SIZE(iwl_nvm_channels)
 #define IWL_NUM_CHANNELS_FAMILY_8000	ARRAY_SIZE(iwl_nvm_channels_family_8000)
 #define NUM_2GHZ_CHANNELS		14
-#define NUM_2GHZ_CHANNELS_FAMILY_8000	13
+#define NUM_2GHZ_CHANNELS_FAMILY_8000	14
 #define FIRST_2GHZ_HT_MINUS		5
 #define LAST_2GHZ_HT_PLUS		9
 #define LAST_5GHZ_HT			161
-- 
1.8.3.2

