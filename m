Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825Ab2DWVw4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/29] iwlwifi: include net/mac80211.h to avoid compiler error
Date: Mon, 23 Apr 2012 14:47:23 -0700
Message-Id: <1335217660-21950-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235333_917361_BF8D2DE3)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

without the include, kernel compiling will fail, but not compat.
this patch need to be merge with iwlwifi-clean-up-iwl-shared.h-includes.patch

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 8e36bdc..2153e4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -63,6 +63,7 @@
 #ifndef __iwl_fw_h__
 #define __iwl_fw_h__
 #include <linux/types.h>
+#include <net/mac80211.h>
 
 /**
  * enum iwl_ucode_tlv_flag - ucode API flags
-- 
1.7.0.4

