Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47896 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab2DPWBb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/16] iwlwifi: remove uneeded include from iwl-pci.c
Date: Mon, 16 Apr 2012 14:57:05 -0700
Message-Id: <1334613430-30720-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000154_123866_7D0ECB14)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index f3e56b0..7540015 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -67,10 +67,8 @@
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
 
-#include "iwl-io.h"
 #include "iwl-shared.h"
 #include "iwl-trans.h"
-#include "iwl-csr.h"
 #include "iwl-cfg.h"
 #include "iwl-drv.h"
 #include "iwl-trans.h"
-- 
1.7.0.4

