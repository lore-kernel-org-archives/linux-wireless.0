Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14D0C43460
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Apr 2021 10:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7F186108F
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Apr 2021 10:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhDKK0G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Apr 2021 06:26:06 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44510 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235299AbhDKK0G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Apr 2021 06:26:06 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.lan)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1lVXHn-000K0H-K3; Sun, 11 Apr 2021 13:25:49 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Sun, 11 Apr 2021 13:25:40 +0300
Message-Id: <iwlwifi.20210411132130.a588a9dacd98.Ie4f96b8988c2cbd5f096ee64d0eb0f4829d55aee@changeid>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210411102545.438654-1-luca@coelho.fi>
References: <20210411102545.438654-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 3/8] iwlwifi: bump FW API to 63 for AX devices
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Start supporting API version 63 for AX devices.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index d775cd9c1394..44735a6d1d39 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -9,7 +9,7 @@
 #include "iwl-prph.h"
 
 /* Highest firmware API version supported */
-#define IWL_22000_UCODE_API_MAX	62
+#define IWL_22000_UCODE_API_MAX	63
 
 /* Lowest firmware API version supported */
 #define IWL_22000_UCODE_API_MIN	39
-- 
2.31.0

