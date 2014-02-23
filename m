Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36937 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaBWT5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:36 -0500
Received: by mail-wg0-f45.google.com with SMTP id l18so3960962wgh.0
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:35 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Inbal Hacohen <Inbal.Hacohen@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/17] iwlwifi: mvm: remove redundant define in fw.c
Date: Sun, 23 Feb 2014 21:57:06 +0200
Message-Id: <1393185428-8524-15-git-send-email-egrumbach@gmail.com> (sfid-20140223_211709_711351_9F179616)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Inbal Hacohen <Inbal.Hacohen@intel.com>

This define is a leftover from dvm (in mvm, it
was replaced by MVM_UCODE_ALIVE_TIMEOUT).

Signed-off-by: Inbal Hacohen <Inbal.Hacohen@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 93e1b4d..7ce2006 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -369,8 +369,6 @@ out:
 	return ret;
 }
 
-#define UCODE_CALIB_TIMEOUT	(2*HZ)
-
 int iwl_mvm_up(struct iwl_mvm *mvm)
 {
 	int ret, i;
-- 
1.7.9.5

