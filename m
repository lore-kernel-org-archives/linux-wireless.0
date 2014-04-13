Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62255 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaDMNCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:02:53 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 06/13] iwlwifi: add MODULE_FIRMWARE for 7265
Date: Sun, 13 Apr 2014 16:01:56 +0300
Message-Id: <1397394123-25102-6-git-send-email-egrumbach@gmail.com> (sfid-20140413_150257_509209_F7C7CC8F)
In-Reply-To: <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
References: <534A8A49.2030100@gmail.com>
 <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It was missing.

Cc: stable@vger.kernel.org [3.13+]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 8425130..4c2d4ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -244,3 +244,4 @@ const struct iwl_cfg iwl7265_n_cfg = {
 
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
+MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-- 
1.8.3.2

