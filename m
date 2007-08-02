Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18761 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbXHBCSu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 22:18:50 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 4/4] iwlwifi: Update version iwl-base.c stamp to 0.1.8
Date: Thu,  2 Aug 2007 10:16:05 +0800
Message-Id: <11860209721595-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11860209712781-git-send-email-yi.zhu@intel.com>
References: <1186020965807-git-send-email-yi.zhu@intel.com>
 <11860209683483-git-send-email-yi.zhu@intel.com>
 <1186020969666-git-send-email-yi.zhu@intel.com>
 <11860209712781-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 0209219..9a5041a 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -106,7 +106,7 @@ BUILD_BUG()
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "0.1.6k" VD VS
+#define IWLWIFI_VERSION "0.1.8k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
-- 
1.5.2
