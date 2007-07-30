Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13420 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760142AbXG3C7r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 22:59:47 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 8/8] Update version iwl-base.c stamp to 0.1.6
Date: Mon, 30 Jul 2007 10:57:06 +0800
Message-Id: <11857642471001-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11857642463341-git-send-email-yi.zhu@intel.com>
References: <11857642261522-git-send-email-yi.zhu@intel.com>
 <11857642343783-git-send-email-yi.zhu@intel.com>
 <11857642362891-git-send-email-yi.zhu@intel.com>
 <1185764238442-git-send-email-yi.zhu@intel.com>
 <11857642401149-git-send-email-yi.zhu@intel.com>
 <11857642421391-git-send-email-yi.zhu@intel.com>
 <11857642444000-git-send-email-yi.zhu@intel.com>
 <11857642463341-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index a98ad77..6e77a51 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -106,7 +106,7 @@ BUILD_BUG()
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "0.1.5k" VD VS
+#define IWLWIFI_VERSION "0.1.6k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
-- 
1.5.2
