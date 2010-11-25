Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab0KYBib (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:31 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/12] iwlagn: minor change in bt coex normal LUT
Date: Wed, 24 Nov 2010 17:32:48 -0800
Message-Id: <1290648768-10075-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Minor changes in LUT

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3342513..407f0bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1778,7 +1778,7 @@ static const __le32 iwlagn_def_3w_lookup[12] = {
 	cpu_to_le32(0xc0004000),
 	cpu_to_le32(0x00004000),
 	cpu_to_le32(0xf0005000),
-	cpu_to_le32(0xf0004000),
+	cpu_to_le32(0xf0005000),
 };
 
 static const __le32 iwlagn_concurrent_lookup[12] = {
-- 
1.7.0.4

