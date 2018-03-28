Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37050 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753199AbeC1O1F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 10:27:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Mar 2018 17:27:00 +0300
Message-Id: <20180328142700.9443-1-luca@coelho.fi> (sfid-20180328_162708_462902_9DF4CC2A)
In-Reply-To: <20180328141157.5427-1-luca@coelho.fi>
References: <20180328141157.5427-1-luca@coelho.fi>
Subject: [PATCH 12/14] iwlwifi: bump the max API version for 9000 and 22000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We are now ready to load 38.ucode

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 4 +++-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c  | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 48f6f80eb24b..dffd9df782b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -19,6 +20,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -55,7 +57,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL_22000_UCODE_API_MAX	36
+#define IWL_22000_UCODE_API_MAX	38
 
 /* Lowest firmware API version supported */
 #define IWL_22000_UCODE_API_MIN	24
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index ab1469473e4f..e1c869a1f8cc 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -19,6 +20,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -56,7 +58,7 @@
 #include "fw/file.h"
 
 /* Highest firmware API version supported */
-#define IWL9000_UCODE_API_MAX	36
+#define IWL9000_UCODE_API_MAX	38
 
 /* Lowest firmware API version supported */
 #define IWL9000_UCODE_API_MIN	30
-- 
2.16.2
