Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758620Ab1CCSTl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:19:41 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Fry, Donald H" <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>, stable@kernel.org
Subject: [PATCH wireless-2.6] iwlagn: Support new 1000 microcode.
Date: Thu,  3 Mar 2011 10:04:09 -0800
Message-Id: <1299175449-7487-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fry, Donald H <donald.h.fry@intel.com>

iwlagn: Support new 1000 microcode.

New iwlwifi-1000 microcode requires driver support for API version 5.
(There is no version 4)

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
CC: stable@kernel.org
---
these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index ba78bc8..507cab4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -49,7 +49,7 @@
 #include "iwl-agn-debugfs.h"
 
 /* Highest firmware API version supported */
-#define IWL1000_UCODE_API_MAX 3
+#define IWL1000_UCODE_API_MAX 5
 #define IWL100_UCODE_API_MAX 5
 
 /* Lowest firmware API version supported */
-- 
1.7.0.4

